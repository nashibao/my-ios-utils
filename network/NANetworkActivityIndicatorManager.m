
#import "NANetworkActivityIndicatorManager.h"

#import "SVProgressHUD.h"

static NSTimeInterval const kAFNetworkActivityIndicatorInvisibilityDelay = 0.17;

@interface NANetworkActivityIndicatorManager ()
@property (readwrite, assign) NSInteger activityCount;
@property (readwrite, nonatomic, strong) NSTimer *activityIndicatorVisibilityTimer;
@property (readonly, getter = isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;

- (void)updateNetworkActivityIndicatorVisibility;
- (void)updateNetworkActivityIndicatorVisibilityDelayed;
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
    });
    
    return _sharedManager;
}

+ (NSSet *)keyPathsForValuesAffectingIsNetworkActivityIndicatorVisible {
    return [NSSet setWithObject:@"activityCount"];
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_activityIndicatorVisibilityTimer invalidate];
    
}

static BOOL __enable_svprogress__ = YES;

+ (void)setEnableSVProgress:(BOOL)bl{
    __enable_svprogress__ = bl;
}

+ (BOOL)enableSVProgress{
    return __enable_svprogress__;
}

- (void)updateNetworkActivityIndicatorVisibilityDelayed {
    if (self.enabled) {
        
        if (![self isNetworkActivityIndicatorVisible]) {
            [self.activityIndicatorVisibilityTimer invalidate];
            self.activityIndicatorVisibilityTimer = [NSTimer timerWithTimeInterval:kAFNetworkActivityIndicatorInvisibilityDelay target:self selector:@selector(updateNetworkActivityIndicatorVisibility) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.activityIndicatorVisibilityTimer forMode:NSRunLoopCommonModes];
        } else {
            [self performSelectorOnMainThread:@selector(updateNetworkActivityIndicatorVisibility) withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }
}

- (BOOL)isNetworkActivityIndicatorVisible {
    return _activityCount > 0;
}

- (void)updateNetworkActivityIndicatorVisibility {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[self isNetworkActivityIndicatorVisible]];
    if(![[self class] enableSVProgress])
        return;
    if([self isNetworkActivityIndicatorVisible]){
        [SVProgressHUD show];
    }else{
        [SVProgressHUD showSuccessWithStatus:@""];
    }
}

- (NSInteger)activityCount {
    return _activityCount;
}

- (void)setActivityCount:(NSInteger)activityCount {
    @synchronized(self) {
        _activityCount = activityCount;
    }
    [self updateNetworkActivityIndicatorVisibilityDelayed];
}

- (void)incrementActivityCount {
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        _activityCount++;
    }
    [self didChangeValueForKey:@"activityCount"];
    [self updateNetworkActivityIndicatorVisibilityDelayed];
}

- (void)decrementActivityCount {
    [self willChangeValueForKey:@"activityCount"];
    @synchronized(self) {
        _activityCount = MAX(_activityCount - 1, 0);
    }
    [self didChangeValueForKey:@"activityCount"];
    [self updateNetworkActivityIndicatorVisibilityDelayed];
}

@end
