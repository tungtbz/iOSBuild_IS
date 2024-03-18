//
//  GoogleMobileAdsConsentManager.m
//  UnityFramework
//
//  Created by Admin on 15/01/2024.
//

#import "GoogleMobileAdsConsentManager.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UserMessagingPlatform/UserMessagingPlatform.h>

@implementation GoogleMobileAdsConsentManager

+ (instancetype)sharedInstance {
    static GoogleMobileAdsConsentManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GoogleMobileAdsConsentManager alloc] init];
        
    });
    return shared;
}

- (BOOL)canRequestAds {
    return UMPConsentInformation.sharedInstance.canRequestAds;
}

- (BOOL)isPrivacyOptionsRequired {
    return UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus ==
    UMPPrivacyOptionsRequirementStatusRequired;
}

- (void)gatherConsentFromConsentPresentationViewController: (void (^)(NSError *_Nullable))consentGatheringComplete {
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
    
    // For testing purposes, you can force a UMPDebugGeography of EEA or not EEA.
//    UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
//    debugSettings.testDeviceIdentifiers = @[ @"A1B2166D-4561-4285-9D85-DD4333A4AD93" ];
//    debugSettings.geography = UMPDebugGeographyEEA;
//    parameters.debugSettings = debugSettings;
    
    __weak GoogleMobileAdsConsentManager *weakSelf = self;
    
    // Requesting an update to consent information should be called on every app launch.
    [UMPConsentInformation.sharedInstance
     requestConsentInfoUpdateWithParameters:parameters
     completionHandler:^(NSError *_Nullable requestConsentError) {
        
        GoogleMobileAdsConsentManager *strongSelf = weakSelf;
        
        if (requestConsentError) {
            NSLog(@"GoogleMobileAdsConsentManager: requestConsentInfoUpdateWithParameters: %@ " , requestConsentError.description);
            consentGatheringComplete(requestConsentError);
            strongSelf._isFlowFinished = true;
        } else {
            [UMPConsentForm loadAndPresentIfRequiredFromViewController:[strongSelf unityViewController]
                                                     completionHandler:^(NSError*_Nullable loadAndPresentError) {
                // Consent has been gathered.
                NSLog(@"GoogleMobileAdsConsentManager: loadAndPresentIfRequiredFromViewController: %@ " , loadAndPresentError.description);
                consentGatheringComplete(loadAndPresentError);
                strongSelf._isFlowFinished = true;
            }];
        }
    }];
}

- (void)presentPrivacyOptionsFormFromViewController:(void (^)(NSError *_Nullable))completionHandler {
    [UMPConsentForm presentPrivacyOptionsFormFromViewController:[self unityViewController]
                                              completionHandler:completionHandler];
}

- (void)byPassConsentForm{
    self._isFlowFinished = true;
}

-(BOOL) isFlowFinished{
    return self._isFlowFinished;
}

- (UIWindow *) keyWindow
{
    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}

- (UIViewController *)unityViewController
{
    // Handle edge case where `UnityGetGLViewController()` returns nil
    UIWindow * keyWin = [self keyWindow];
    return UnityGetGLViewController() ?: UnityGetMainWindow().rootViewController ?: [keyWin rootViewController];
}


@end
