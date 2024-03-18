//
//  DevicesFeatures.m
//  UnityFramework
//
//  Created by Admin on 01/08/2023.
//

#import "DevicesFeatures.h"

// Converts NSString to C style string by way of copy (Mono will free it)
#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL

#ifdef __cplusplus
extern "C" {
#endif
    void UnityPause(int pause);
    extern void UnitySendMessage( const char *className, const char *methodName, const char *param );
    
#ifdef __cplusplus
}
#endif

@implementation DevicesFeatures{
    int internetStatus;
}
char *const SDK_OBJECT_NAME = "RofiSdkHelper";

+ (DevicesFeatures * _Nonnull)sharedObject {
    static DevicesFeatures *sharedClass = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    
    return sharedClass;
}

-(id) init{
    self = [super init];
    if(self){
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        internetStatus = 0;
        [self testInternetConnection];
    }
    return self;
}

- (void)TurnTorchOn {
    float torchLevel = 1.0f;
    
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device != nil && [device hasTorch] && [device hasFlash]) {
        [device lockForConfiguration:nil];
        
        if (torchLevel >= 1.0){
            torchLevel = AVCaptureMaxAvailableTorchLevel;
        }
        BOOL success = [device setTorchModeOnWithLevel:torchLevel error:nil];
        
        if(success){
            //auto turn-off
            double delayInMSeconds = 50;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMSeconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
              //code to be executed on the main queue after delay
                [device setTorchMode:AVCaptureTorchModeOff];
                [device unlockForConfiguration];
            });
        }
    }
}

- (void)Vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)OpenRate {
    if([SKStoreReviewController class]){
           [SKStoreReviewController requestReview] ;
        }
}

- (void)OpenRateIos13:(UIWindowScene * _Nonnull)win __attribute__((availability(ios, introduced=13.0))) {
    if([SKStoreReviewController class]){
        if (@available(iOS 14.0, *)) {
            [SKStoreReviewController requestReviewInScene:win] ;
        } else {
            // Fallback on earlier versions
            [self OpenRate];
        }
    }
}

// Checks if we have an internet connection or not
- (void) testInternetConnection
{
    internetReachableFoo = [BZReachability reachabilityWithHostname:@"www.google.com"];

    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(BZReachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"DevicesFeatures-Yayyy, we have the interwebs!");
            self->internetStatus = 1;
            UnitySendMessage(SDK_OBJECT_NAME, "OnNetworkAvailable", MakeStringCopy(@""));
        });
    };

    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(BZReachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"DevicesFeatures-Someone broke the internet :(");
            self->internetStatus = 2;
            UnitySendMessage(SDK_OBJECT_NAME, "OnNetworkLost", MakeStringCopy(@""));
        });
    };

    [internetReachableFoo startNotifier];
}

- (BOOL)isOnline{
    return self->internetStatus == 1;
}

-(int)internetStatus{
    return self->internetStatus;
}

- (BOOL)isCameraPermissionGranted {
    // check camera authorization status
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return authStatus == AVAuthorizationStatusAuthorized;
}

-(void) requestCameraPermission{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(granted) {
                            //do camera intensive stuff
                            UnitySendMessage(SDK_OBJECT_NAME, "OnCameraPermissionGranted", MakeStringCopy(@"true"));
                        } else {
                            //user denied
                            UnitySendMessage(SDK_OBJECT_NAME, "OnCameraPermissionDenied", MakeStringCopy(@"ShowAlert"));
                        }
                    });
                }];
}

-(void) openSetting{
    NSLog(@"[DevicesFeatures] -openSetting ");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:^(BOOL success) {
        
    }];
}

- (void)requestCameraPermission:(void (^__strong)(BOOL))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
}

-(void) requestATT:(void (^)(BOOL))handler{
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                
                handler(true);
                
                switch (status) {
                    case ATTrackingManagerAuthorizationStatusAuthorized:
                        break;
                    case ATTrackingManagerAuthorizationStatusDenied:
                        break;
                    case ATTrackingManagerAuthorizationStatusRestricted:
                        break;
                    case ATTrackingManagerAuthorizationStatusNotDetermined:
                        break;
                    default:
                        break;
                }
            }];
        }else{
            handler(true);
        }
}

-(void) requestNotification:(void (^ _Nonnull)(BOOL granted)) handler{
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                                handler(granted);
                          }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set here for local notification.
    });
    
}

@end
