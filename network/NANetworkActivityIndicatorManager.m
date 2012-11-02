
#import "NANetworkActivityIndicatorManager.h"


@implementation NANetworkActivityIndicatorActivityObject
@end

static NSTimeInterval const kAFNetworkActivityIndicatorInvisibilityDelay = 0.17;

@interface NANetworkActivityIndicatorManager ()
@property (readwrite, assign) NSInteger activityCount;
@property (readwrite, nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
@property (readonly, getter = isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;
@end

@implementation NANetworkActivityIndicatorManager
@synthesize activityCount = _activityCount;
@synthesize activityIndicatorVisibilityTimer = _activityIndicatorVisibilityTimer;
@synthesize enabled = _enabled;
@dynamic networkActivityIndicatorVisible;

+ (NANetworkActivityIndicatorManager *)sharedManager {
    static NANetworkActivityIndicatorManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.defaultSVProgressHUDMaskType = SVProgressHUDMaskTypeNone;
        _sharedManager.enableSVProgress = YES;
        _sharedManager.activityObjectWithIdentifiers = [@{} mutableCopy];
    });
    
    return _sharedManager;
}

//+ (NSSet *)keyPathsForValuesAffectingIsNetworkActivityIndicatorVisible {
//    return [NSSet setWithObject:@"activityCount"];
//}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.errors = [@[] mutableCopy];
    self.activityObjectWithIdentifiers = [@{} mutableCopy];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_activityIndicatorVisibilityTimer invalidate];
    
}

- (void)updateNetworkActivityIndicatorVisibilityDelayed:(NSDictionary *)option {
    if (self.enabled) {
        
        if (![self isNetworkActivityIndicatorVisible]) {
            [self.activityIndicatorVisibilityTimer invalidate];
            self.activityIndicatorVisibilityTimer = [NSTimer timerWithTimeInterval:kAFNetworkActivityIndicatorInvisibilityDelay target:self selector:@selector(updateNetworkActivityIndicatorVisibilityForTimer) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer forMode:NSRunLoopCommonModes];
        } else {
            [self performSelectorOnMainThread:@selector(updateNetworkActivityIndicatorVisibility:) withObject:option waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (BOOL)isNetworkActivityIndicatorVisible {
    return _activityCount > 0;
}

- (NSString *)errorString{
    NSMutableString *temp = [@"" mutableCopy];
    if(self.errors && [self.errors count]){
        for (NSString *err in self.errors) {
            [temp appendString:err];
        }
    }
    return temp;
}

- (void)updateNetworkActivityIndicatorVisibilityForTimer{
    [self updateNetworkActivityIndicatorVisibility:nil];
}

- (void)updateNetworkActivityIndicatorVisibility:(NSDictionary *)option {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self isNetworkActivityIndicatorVisible]];
    if(![self enableSVProgress])
        return;
    if([self isNetworkActivityIndicatorVisible]){
        SVProgressHUDMaskType maskType = self.defaultSVProgressHUDMaskType;
        if(option[@"defaultSVProgressHUDMaskType"]){
            maskType = [option[@"defaultSVProgressHUDMaskType"] integerValue];
        }
        [SVProgressHUD showWithMaskType:maskType];
    }else{
        if([self.errors count] > 0){
            [SVProgressHUD showErrorWithStatus:[self errorString]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@""];
        }
    }
}

- (NSInteger)activityCount {
    return _activityCount;
}

- (void)setActivityCount:(NSInteger)activityCount option:(NSDictionary *)option {
    @synchronized(self) {
        _activityCount = activityCount;
    }
    [self updateNetworkActivityIndicatorVisibilityDelayed: option];
}

- (void)setActivityCount:(NSInteger)activityCount {
    @synchronized(self) {
        _activityCount = activityCount;
    }
    [self updateNetworkActivityIndicatorVisibilityDelayed: nil];
}

- (void)incrementActivityCount:(NSString *)identifier option:(NSDictionary *)option{
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        if(_activityCount == 0){
            [self.errors removeAllObjects];
        }
        _activityCount++;
        if(identifier){
            NANetworkActivityIndicatorActivityObject *io = self.activityObjectWithIdentifiers[identifier];
            if(io){
                io.activityCount++;
            }else{
                io = [[NANetworkActivityIndicatorActivityObject alloc] init];
                io.activityCount = 1;
                io.identifier = identifier;
                self.activityObjectWithIdentifiers[identifier] = io;
            }
        }
    }
    [self didChangeValueForKey:@"activityCount"];
    [self updateNetworkActivityIndicatorVisibilityDelayed: option];
}

- (void)decrementActivityCount:(NSString *)identifier{
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        _activityCount = MAX(_activityCount - 1, 0);
        if(identifier){
            NANetworkActivityIndicatorActivityObject *io = self.activityObjectWithIdentifiers[identifier];
            if(io){
                io.activityCount = MAX(io.activityCount - 1, 0);
                if (io.activityCount == 0) {
                    [self.activityObjectWithIdentifiers removeObjectForKey:identifier];
                }
            }
        }
    }
    [self didChangeValueForKey:@"activityCount"];
    [self updateNetworkActivityIndicatorVisibilityDelayed: nil];
}

- (void)decrementActivityCount:(NSString *)identifier error:(NSString *)error{
    [self.errors addObject:error];
    if(identifier){
        NANetworkActivityIndicatorActivityObject *io = self.activityObjectWithIdentifiers[identifier];
        if(io){
            io.activityCount++;
            if(io.errors){
                [io.errors addObject:error];
            }else{
                io.errors = [@[error] mutableCopy];
            }
        }
    }
    [self decrementActivityCount:identifier];
}

- (void)insert:(NSString *)identifier error:(NSString *)error option:(NSDictionary *)option{
    [self incrementActivityCount:identifier option:option];
    [self decrementActivityCount:identifier error:error];
}

@end
