//
//  IronsourceAdsHelper.h
//  UnityFramework
//
//  Created by Admin on 07/08/2023.
//

#import <Foundation/Foundation.h>
#import <Ironsource/IronSource.h>
NS_ASSUME_NONNULL_BEGIN

#define logCallbackName(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);

@protocol IronSourceAdsDelegate <NSObject>
- (void) initializationDidComplete;
- (void) onVideoRewarded;

- (void) onAdLoaded:(int) adType;
- (void) onBannerLoaded:(ISBannerView *)bannerView;

- (void) onAdOpened:(int) adType;
- (void) onAdClosed:(int) adType;
- (void) onAdLoadFailed:(int) adType;

- (void) onAdClicked;
- (void) onAdImpressionRecorded:(ISImpressionData *)impressionData;
@end

@interface IronsourceAdsHelper : NSObject <IronSourceAdsDelegate>{
    BOOL _isPluginInitialized;
    
    BOOL _isShowResumeAdsRemoteValue;
    
    BOOL _isCountingDownDelayInterAds;
    int _extraDelayInterAdsInSecond;
    
    BOOL _isBlockInterAds;
    BOOL _isAdClicked;

    int _delayShowInter;
    bool _isDisableResumeAds;
    BOOL _isDisableInterAds;
    
    BOOL _isInterAdsShowing;
    bool _isRewardAdsShowing;
    
    int _blockAutoShowInterCount;
    
    NSDate *_videoRewardShowTime;
    
    float _runtimeDelayInterAdsInSecond;
    NSTimer * _interDelayTimer;
}


+(IronsourceAdsHelper *_Nonnull) sharedObject;
- (instancetype)init NS_UNAVAILABLE;

-(void) SetSDKInitCallback:(void(^_Nullable)(void)) callback;

-(void) setAdRevenueCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
-(void) setAdClickCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
-(void) setAdDisplayCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
-(void) setAdRewardedCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
-(void) setAdReadyCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;
-(void) setInterAdClosedCallback : (void(^_Nullable)(NSDictionary<NSString *, id> *_Nullable)) callback;

-(void) initSDK;

-(void) showBanner;
-(void) hideBanner;

-(void) showMrec;
-(void) showResumeAds;
-(void) hideMrec;

-(void) showInter:(int) code;
-(BOOL) isInterReady;

-(void) showReward:(int) code;
-(BOOL) isRewardReady;

- (void) enableInterAds;
- (void) disableInterAds;

- (void) enableResumeAds;
- (void) disableResumeAds;

-(void) setConfigValues:(int) delayShowInter isShowResume:(BOOL) isShowResume;

- (void) increaseBlockAutoShowInterCount;
- (void) decreaseBlockAutoShowInterCount;

@end

NS_ASSUME_NONNULL_END
