
#import <Foundation/Foundation.h>

#import <Availability.h>

@interface NANetworkActivityIndicatorManager : NSObject

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

+ (void)setEnableSVProgress:(BOOL)bl;
+ (BOOL)enableSVProgress;

+ (NANetworkActivityIndicatorManager *)sharedManager;

- (void)incrementActivityCount;

- (void)decrementActivityCount;

@end
