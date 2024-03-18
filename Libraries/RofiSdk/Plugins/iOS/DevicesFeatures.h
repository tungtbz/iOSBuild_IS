//
//  DevicesFeatures.h
//  UnityFramework
//
//  Created by Admin on 01/08/2023.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <StoreKit/StoreKit.h>
#import "BZReachability.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <UserNotifications/UserNotifications.h>
@interface DevicesFeatures : NSObject{
    AVCaptureDevice *device;
    BZReachability *internetReachableFoo;
}

+(DevicesFeatures *_Nonnull) sharedObject;

-(void) TurnTorchOn;
-(void) Vibrate;
-(void) OpenRate;

-(void) requestCameraPermission:(void (^ _Nonnull)(BOOL granted)) handler;
-(void) requestATT:(void (^ _Nonnull)(BOOL granted)) handler;
-(void) requestNotification:(void (^ _Nonnull)(BOOL granted)) handler;

-(void) openSetting;
-(BOOL) isCameraPermissionGranted;
-(BOOL) isOnline;
-(int) internetStatus;

-(void) OpenRateIos13:(UIWindowScene *_Nonnull) win API_AVAILABLE(ios(13.0));

-(BOOL) isCameraPermissionGranted;

@end

