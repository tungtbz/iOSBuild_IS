////
////  ApplovinAdsHelper.h
////  UnityFramework
////
////  Created by Admin on 01/08/2023.
////
//
//#import <Foundation/Foundation.h>
//#import <AppLovinSDK/AppLovinSDK.h>
//
//typedef void (*ALUnityBackgroundCallback)(const char* _Nullable args);
//typedef void (*ALFinishInitCallback)();
//
//@interface ApplovinAdsHelper : NSObject{
//    BOOL _isPluginInitialized;
//    
//    BOOL _isCountingDownDelayInterAds;
//    BOOL _isInterAdsShowing;
//    BOOL _isDisableInterAds;
//    BOOL _isDisableResumeAds;
//    
//    BOOL _isAdClicked;
//    
//    int _delayShowInter;
//    
//    int _blockAutoShowInterCount;
//    
//    bool _isShowResumeAdsRemoteValue;
//    bool _isCountingDownBlockInter;
//    bool _isRewardAdsShowing;
//    int _extraDelayInterAdsInSecond;
//
//    
//    NSDate *_videoRewardShowTime;
//    
//    float _runtimeDelayInterAdsInSecond;
//    NSTimer * _interDelayTimer;
//}
//
//+(ApplovinAdsHelper *_Nonnull) sharedObject;
//
//-(void) initWithCallback:(void(^_Nullable)(void)) callback;
//
//-(void) setConfigValues:(int) delayShowInter isShowResume:(BOOL) isShowResume;
//
//-(void) setAdRevenueCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//-(void) setAdClickCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//-(void) setAdDisplayCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//-(void) setAdRewardedCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//-(void) setAdReadyCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//-(void) setInterAdClosedCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
//
//-(void) showResumeAds;
//
//-(void) showBanner;
//-(void) hideBanner;
//
//-(void) showMrec;
//-(void) hideMrec;
//
//-(void) showNativeMrec;
//-(void) hideNativeMrec;
//
//-(void) showNativeBanner;
//-(void) hideNativeBanner;
//
//-(void) showInter:(int) code;
//-(BOOL) isInterReady;
//
//-(void) showReward:(int) code;
//-(BOOL) isRewardReady;
//
//-(BOOL) isAppOpenAdsReady;
//-(void) loadAppOpenAds;
//-(void) showAppOpenAds;
//
//-(BOOL) isPluginInitialized;
//
//- (void)showBannerWithAdUnitIdentifier:(NSString *_Nonnull)adUnitIdentifier;
//- (void)destroyBannerWithAdUnitIdentifier:(NSString *_Nonnull)adUnitIdentifier;
//- (void)hideBannerWithAdUnitIdentifier:(NSString *_Nonnull)adUnitIdentifier;
//
//- (void) increaseBlockAutoShowInterCount;
//- (void) decreaseBlockAutoShowInterCount;
//
//- (void) onReadyToShowAutoInter;
//- (void) enableInterAds;
//- (void) disableInterAds;
//
//- (void) enableResumeAds;
//- (void) disableResumeAds;
//
//-(void) initAdsWithConsentFlow;
//
//@end
