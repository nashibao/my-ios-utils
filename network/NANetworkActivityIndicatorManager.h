
#import <Foundation/Foundation.h>

#import <Availability.h>

#import "SVProgressHUD.h"


@interface NANetworkActivityIndicatorActivityObject : NSObject
@property (strong, nonatomic) NSString *identifier;
@property (nonatomic) NSInteger activityCount;
@property (strong, nonatomic) NSMutableArray *errors;
@end


/** indicator manager
 */
@interface NANetworkActivityIndicatorManager : NSObject

/** enable option : default = YES */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

/** getter. to be YES when network count > 0 */
@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

/** error array.
 
 
 */
@property (strong, nonatomic) NSMutableArray *errors;
@property (strong, nonatomic) NSMutableDictionary *activityObjectWithIdentifiers;

@property (nonatomic) BOOL enableSVProgress;
@property (nonatomic) SVProgressHUDMaskType defaultSVProgressHUDMaskType;

+ (NANetworkActivityIndicatorManager *)sharedManager;

- (void)incrementActivityCount:(NSString *)identifier option:(NSDictionary *)option;
- (void)decrementActivityCount:(NSString *)identifier;
- (void)decrementActivityCount:(NSString *)identifier error:(NSString *)error;
- (void)insert:(NSString *)identifier error:(NSString *)error option:(NSDictionary *)option;

@end
