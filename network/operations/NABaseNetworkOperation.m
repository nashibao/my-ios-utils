//
//  NAOperation.m
//  SK3
//
//  Created by nashibao on 2012/10/10.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NABaseNetworkOperation.h"


typedef enum AFOperationState: NSInteger {
    AFOperationPausedState      = -1,
    AFOperationReadyState       = 1,
    AFOperationExecutingState   = 2,
    AFOperationFinishedState    = 3,
} AFOperationState;

static inline NSString * AFKeyPathFromOperationState(AFOperationState state) {
    switch (state) {
        case AFOperationReadyState:
            return @"isReady";
        case AFOperationExecutingState:
            return @"isExecuting";
        case AFOperationFinishedState:
            return @"isFinished";
        case AFOperationPausedState:
            return @"isPaused";
        default:
            return @"state";
    }
}

static inline BOOL AFStateTransitionIsValid(AFOperationState fromState, AFOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case AFOperationReadyState:
            switch (toState) {
                case AFOperationPausedState:
                case AFOperationExecutingState:
                    return YES;
                case AFOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case AFOperationExecutingState:
            switch (toState) {
                case AFOperationPausedState:
                case AFOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case AFOperationFinishedState:
            return NO;
        case AFOperationPausedState:
            return toState == AFOperationReadyState;
        default:
            return YES;
    }
}

@interface NABaseNetworkOperation()

@property(nonatomic)AFOperationState state;
@property(nonatomic)BOOL cancelled;
@property(nonatomic, strong)NSSet *runLoopModes;
@property(nonatomic, strong)NSMutableData *mutableData;
@property(nonatomic, strong)NSURLConnection *connection;

@end


@implementation NABaseNetworkOperation

/*
 thread
 */
+ (void)networkRequestThreadEntryPoint:(id)object {
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

/*
 initialize
 */
- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super init];
    if (!self) {
		return nil;
    }
    
    self.request = urlRequest;
    
    self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    
    self.state = AFOperationReadyState;
	
    return self;
}

/*
 state
 */
- (void)setState:(AFOperationState)state {
    if (AFStateTransitionIsValid(self.state, state, [self isCancelled])) {
        NSString *oldStateKey = AFKeyPathFromOperationState(self.state);
        NSString *newStateKey = AFKeyPathFromOperationState(state);
        
        [self willChangeValueForKey:newStateKey];
        [self willChangeValueForKey:oldStateKey];
        _state = state;
        [self didChangeValueForKey:oldStateKey];
        [self didChangeValueForKey:newStateKey];
    }
}

- (void)pause {
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }
    
    if ([self isExecuting]) {
        [self.connection performSelector:@selector(cancel) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    
    self.state = AFOperationPausedState;
}

- (void)resume {
    if (![self isPaused]) {
        return;
    }
    self.state = AFOperationReadyState;
    
    [self start];
}

#pragma mark - NSOperation

- (BOOL)isReady {
    return self.state == AFOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == AFOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == AFOperationFinishedState;
}

- (BOOL)isPaused {
    return self.state == AFOperationPausedState;
}

- (BOOL)isConcurrent {
    return YES;
}

/*
 start
 */
- (void)start {
    if ([self isReady]) {
        self.state = AFOperationExecutingState;
        
        [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
}

- (void)operationDidStart {
    if ([self isCancelled]) {
        [self finish];
    } else {
        self.mutableData = [[NSMutableData alloc] initWithCapacity:0];
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        for (NSString *runLoopMode in self.runLoopModes) {
            [self.connection scheduleInRunLoop:runLoop forMode:runLoopMode];
        }
        
        [self.connection start];
    }
}

/*
 finish
 */
- (void)finish {
    self.state = AFOperationFinishedState;
}

/*
 cancel -> cancelConnection
 */
- (void)cancel {
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = YES;
        [super cancel];
        [self didChangeValueForKey:@"isCancelled"];
        
        // Cancel the connection on the thread it runs on to prevent race conditions
        [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
}

- (void)cancelConnection {
    
    // Manually send this delegate message since `[self.connection cancel]` causes the connection to never send another message to its delegate
    NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = [NSDictionary dictionaryWithObject:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
    }
    NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    self.error = err;
    
    if (self.connection) {
        [self.connection cancel];
        
#warning ポーズしているときにキャンセルが来た場合、完全なキャンセルにならなくちゃいけない．
        if([self isPaused])
            return;
        
        [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:err];
    }
}


#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_mutableData setLength:0];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.responseData = [NSData dataWithData:_mutableData];
    
    [self finish];
    
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.error = error;
    
    [self finish];
    
    self.connection = nil;
}

@end
