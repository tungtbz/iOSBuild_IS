//
//  GoogleMobileAdsConsentManager.h
//  UnityFramework
//
//  Created by Admin on 15/01/2024.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GoogleMobileAdsConsentManager : NSObject

@property(class, atomic, readonly, strong, nonnull) GoogleMobileAdsConsentManager *sharedInstance;
@property(nonatomic, readonly) BOOL canRequestAds;
@property(nonatomic, readonly) BOOL isPrivacyOptionsRequired;
@property(nonatomic) BOOL _isFlowFinished;

/// Helper method to call the UMP SDK methods to request consent information and load/present a
/// consent form if necessary.
- (void)gatherConsentFromConsentPresentationViewController:(void (^)(NSError *_Nullable error))completionHandler;

/// Helper method to call the UMP SDK method to present the privacy options form.
- (void)presentPrivacyOptionsFormFromViewController:(void (^)(NSError *_Nullable error))completionHandler;

- (void)byPassConsentForm;

- (BOOL) isFlowFinished;


@end

NS_ASSUME_NONNULL_END
