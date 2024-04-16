//
//  IronsourceAdsHelper.m
//  UnityFramework
//
//  Created by Admin on 07/08/2023.
//
#define RESUME_INTER_KEY 123456

#define INTERNAL_TIME 1.0

#define TEST YES

#import "IronsourceAdsHelper.h"
#import "InitializationDelegate.h"
#import "RewardedVideoDelegate.h"
#import "InterstitialDelegate.h"
#import "BannerDelegate.h"
#import "ImpressionDataDelegate.h"

#define KEY_WINDOW_IS [UIApplication sharedApplication].keyWindow
#ifdef __cplusplus
extern "C" {
#endif

    // UnityAppController.mm
    UIViewController* UnityGetGLViewController(void);
    UIWindow* UnityGetMainWindow(void);

    // life cycle management
    void UnityPause(int pause);
    void UnitySendMessage(const char* obj, const char* method, const char* msg);
#ifdef __cplusplus
}
#endif

#define BANNER_POSITION_TOP 1
#define BANNER_POSITION_BOTTOM 2

#define BANNER_SIZE_BANNER 1
#define BANNER_SIZE_MREC 2


@interface IronsourceAdsHelper(){
    ISBannerView* _bannerView;
    NSInteger _position;
    NSInteger _bannerSize;
    UIViewController* _bannerViewController;
    BOOL _shouldHideBanner;
    int _currentBannerType;

}
    @property (nonatomic, strong) InitializationDelegate *initializationDelegate;

    @property (nonatomic, strong) RewardedVideoDelegate *rewardedVideoDelegate;
    @property (nonatomic, strong) InterstitialDelegate *interstitialDelegate;
    @property (nonatomic, strong) BannerDelegate *bannerDelegate;

    @property (nonatomic, strong) ImpressionDataDelegate *impressionDataDelegate;

    //plist data
    @property (nonatomic, strong) NSDictionary *plistData;

    @property (nonatomic, assign) NSInteger codeRequestRewarded;
    @property (nonatomic, assign) NSInteger codeRequestInter;

@property (nonatomic, strong) void (^blockCallbackWhenFinishInit)(void);

    @property (nonatomic, strong) void (^blockCallbackWhenAdClicked)(NSDictionary<NSString *, id> *);
    @property (nonatomic, strong) void (^blockCallbackAdRevenue)(NSDictionary<NSString *, id> *);
    @property (nonatomic, strong) void (^blockCallbackAdRewarded)(NSDictionary<NSString *, id> *);
    @property (nonatomic, strong) void (^blockCallbackAdReady)(NSDictionary<NSString *, id> *);
    @property (nonatomic, strong) void (^blockCallbackAdDisplayed)(NSDictionary<NSString *, id> *);
    @property (nonatomic, strong) void (^blockCallbackInterAdClosed)(NSDictionary<NSString *, id> *);

    @property (nonatomic, assign) NSInteger retryAttemptInter;
    @property (nonatomic, assign) NSInteger retryAttemptRewarded;


@end

@implementation IronsourceAdsHelper
static NSString *const SDK_TAG = @"IronsourceAdsHelper";
static NSString *const TAG = @"MAUnityAdManager";
#pragma mark Init
- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        self.plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        _position = BANNER_POSITION_BOTTOM;
        _bannerSize = BANNER_SIZE_BANNER;
        _bannerView = nil;
        _bannerViewController = nil;
        _shouldHideBanner = false;
        
        //[self initSdk];

    }
    return self;
}

- (void) initSDK{
    NSString* appKey =[self.plistData  objectForKey:@"IronsourceAppKey"];
    
    self.initializationDelegate = [[InitializationDelegate alloc] initWithDelegate:self];
    
    self.rewardedVideoDelegate = [[RewardedVideoDelegate alloc] initWithDelegate:self];
    self.interstitialDelegate = [[InterstitialDelegate alloc] initWithDelegate:self];
    self.bannerDelegate = [[BannerDelegate alloc] initWithDelegate:self];
    
    self.impressionDataDelegate = [[ImpressionDataDelegate alloc] initWithDelegate:self];
    
    
    [IronSource setMetaDataWithKey:@"is_test_suite" value:@"enable"];
    
    [IronSource setLevelPlayBannerDelegate:self.bannerDelegate];
    [IronSource setLevelPlayInterstitialDelegate:self.interstitialDelegate];
    [IronSource setLevelPlayRewardedVideoManualDelegate:self.rewardedVideoDelegate];
    
    [IronSource addImpressionDataDelegate:self.impressionDataDelegate];
    
    [IronSource setConsent:true];
    [IronSource setMetaDataWithKey:@"do_not_sell" value:@"NO"];
    [IronSource setMetaDataWithKey:@"is_child_directed" value:@"NO"];
    
    [IronSource initWithAppKey:appKey delegate:self.initializationDelegate];
    
}


#pragma mark VideoReward
-(void) loadVideo{
    [IronSource loadRewardedVideo];
}

- (void)showReward:(int)code {
    self.codeRequestRewarded = code;
    [IronSource showRewardedVideoWithViewController:[self unityViewController]];
}

- (BOOL)isRewardReady {
    return [IronSource hasRewardedVideo];
}

#pragma mark Inter
-(void)loadInter{
    [IronSource loadInterstitial];
}

- (BOOL)isInterReady {
    return [IronSource hasInterstitial];
}

- (void)showInter:(int) code {
    if(!_isPluginInitialized) {
        [self log:@"Block Show Inter 0"];
        return;
    }
    if(_isDisableInterAds) {
        [self log:@"Block Show Inter 1"];
        return;
    }
    if(_isInterAdsShowing) {
        [self log:@"Block Show Inter 2"];
        return;
    }
    if(![self isInterReady]) {
        [self log:@"Block Show Inter 3"];
        return;
    }
    if(_isCountingDownDelayInterAds) {
        [self log:@"Block Show Inter 4"];
        return;
    }
    
    self.codeRequestInter = code;
    
    [IronSource showInterstitialWithViewController:[self unityViewController]];
}

#pragma mark BANNER/MREC
-(void) loadBanner{
    if(_currentBannerType == 1 && _bannerView)
       [self destroyBanner];
    
    _currentBannerType = 0;
    [IronSource loadBannerWithViewController:[self unityViewController] size:ISBannerSize_SMART];
}

- (void)destroyBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (_bannerView != nil) {
                [IronSource destroyBanner:_bannerView];
                _bannerView = nil;
                _bannerViewController = nil;
                _shouldHideBanner = NO;
            }
        }
    });
}

- (void)showBanner {
    _shouldHideBanner = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (_bannerView != nil) {
                if(_currentBannerType == 0)
                    [_bannerView setHidden:_shouldHideBanner];
            }else{
                [self loadBanner];
            }
        }
    });
}

- (void)hideBanner {
    _shouldHideBanner = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (_bannerView != nil) {
                [_bannerView setHidden:_shouldHideBanner];
            }
        }
    });
}

-(void) loadMREC{
    if(_currentBannerType == 0 && _bannerView)
       [self destroyBanner];
    
    _currentBannerType = 1;
    [self log:@"Load MREC"];
    [IronSource loadBannerWithViewController:[self unityViewController] size:ISBannerSize_RECTANGLE];
}

- (CGPoint)getBannerCenter:(NSInteger)position rootView:(UIView *)rootView {
    CGFloat y;
    if (position == BANNER_POSITION_TOP) {
        y = (_bannerView.frame.size.height / 2);
        if (@available(ios 11.0, *)) {
            y += rootView.safeAreaInsets.top;
        }
    }
    else {
        y = rootView.frame.size.height/2 - (_bannerView.frame.size.height / 2);
        if (@available(ios 11.0, *)) {
            y -= rootView.safeAreaInsets.bottom;
        }
    }
    
    return CGPointMake(rootView.frame.size.width / 2, y);
}

- (void)hideMrec {
    [self hideBanner];
}

- (void)showMrec {
    _shouldHideBanner = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (_bannerView != nil) {
                if(_currentBannerType == 1)
                    [_bannerView setHidden:_shouldHideBanner];
            }else{
                [self loadMREC];
            }
        }
    });
}

+ (IronsourceAdsHelper * _Nonnull)sharedObject {
    static IronsourceAdsHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    
    return sharedClass;
}


- (void)showResumeAds {
    if(!_isPluginInitialized) return;
    
    if(_isDisableInterAds) {
        [self log:@"Block Show Resume Inter 0"];
        return;
    }
    
    if(_isDisableResumeAds) {
        [self log:@"Block Show Resume Inter zz"];
        return;
    }
    
    if(!_isShowResumeAdsRemoteValue) {
        [self log:@"Block Show Resume Inter 1"];
        return;
    }
    
    if(_isRewardAdsShowing){
        [self log:@"Block Show Resume Inter 2"];
        return;
    }
    
    if(_isInterAdsShowing) {
        [self log:@"Block Show Resume Inter 2"];
        return;
    }
    
    if(_isAdClicked){
        _isAdClicked = false;
        [self log:@"Block Show Resume Inter 3"];
        return;
    }
    
    if(_blockAutoShowInterCount > 0){
        [self decreaseBlockAutoShowInterCount];
        [self log:@"Block Show Resume Inter 4"];
        return;
    }
    
    self.codeRequestInter = RESUME_INTER_KEY;
    [IronSource showInterstitialWithViewController:[self unityViewController]];

}

-(void) enableInterAds{
    _isDisableInterAds = false;
}

-(void) disableInterAds{
    _isDisableInterAds = true;
}

-(void) enableResumeAds{
    _isDisableResumeAds = false;
}

-(void) disableResumeAds{
    _isDisableResumeAds = true;
}

- (void)setConfigValues:(int)delayShowInter isShowResume:(BOOL)isShowResume {
    [self log:@"Delay show inter %d", delayShowInter];
    [self log:@"Is show Resume Ads %d", isShowResume];
    
    _delayShowInter = delayShowInter;
    _isShowResumeAdsRemoteValue = isShowResume;
}

-(void) increaseBlockAutoShowInterCount{
    _blockAutoShowInterCount += 1;
}

-(void) decreaseBlockAutoShowInterCount{
    _blockAutoShowInterCount -= 1;
}

#pragma mark ADS CALLBACKS
/**
 Called after an rewarded video has been loaded in manual mode
 @param adInfo The info of the ad.
 */
- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo{
    //The ad unit displayed (Rewarded Video/Interstitial/Banner)
//    [IronsourceAdsHelper log:@"didLoadWithAdInfo %@", adInfo.ad_unit];
//    NSString* adFormat = @"";
//    
//    if([adInfo.ad_unit isEqual: @"Interstitial"]){
//        adFormat = @"INTER";
//        self.retryAttemptInter = 0;
//    }else if([adInfo.ad_unit isEqual: @"Interstitial"]){
//        adFormat = @"REWARDED";
//        self.retryAttemptRewarded = 0;
//    }
//    
//    if(self.blockCallbackAdReady != nil){
//        self.blockCallbackAdReady(@{@"adFormat" : adFormat});
//    }
}

/**
 Called after a rewarded video has attempted to load but failed in manual mode
 @param error The reason for the error
 */
- (void)didFailToLoadWithError:(NSError *)error {
    //The ad unit displayed (Rewarded Video/Interstitial/Banner)
//    [IronsourceAdsHelper log:@"didFailToLoadWithError %@", error.code];
//    NSString* adFormat = @"";
//    
//    if(error.code == 1055){
//        self.retryAttemptRewarded += 1;
//        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptRewarded));
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [IronSource loadRewardedVideo];
//        });
//    }else if(error.code == 1036 || error.code == 510){
//        self.retryAttemptInter += 1;
//        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptInter));
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [IronSource loadInterstitial];
//        });
//    }
}

/**
 Called after a rewarded video has changed its availability to true.
 @param adInfo The info of the ad.
 Replaces the delegate rewardedVideoHasChangedAvailability:(true)available
 */
- (void)hasAdAvailableWithAdInfo:(ISAdInfo *)adInfo{
    [self log:@"hasAdAvailableWithAdInfo"];
}
/**
 Called after a rewarded video has changed its availability to false.
 Replaces the delegate rewardedVideoHasChangedAvailability:(false)available
 */
- (void)hasNoAvailableAd{
    [self log:@"hasNoAvailableAd"];
}

/**
 Called after a rewarded video has been viewed completely and the user is eligible for a reward.
 @param placementInfo An object that contains the placement's reward name and amount.
 @param adInfo The info of the ad.
 */
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
//    if(self.blockCallbackAdRewarded != nil){
//        self.blockCallbackAdRewarded(@{@"requestCode" : [@(self.codeRequestRewarded) stringValue]});
//    }
}
/**
 Called after a rewarded video has attempted to show but failed.
 @param error The reason for the error
 @param adInfo The info of the ad.
 */
- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
}
/**
 Called after a rewarded video has been opened.
 @param adInfo The info of the ad.
 */
- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    //The ad unit displayed (Rewarded Video/Interstitial/Banner)
//    [IronsourceAdsHelper log:@"didOpenWithAdInfo %@", adInfo.ad_unit];
//    NSString* adFormat = @"";
//    
//    if([adInfo.ad_unit isEqual: @"Interstitial"]){
//        adFormat = @"INTER";
//    }else if([adInfo.ad_unit isEqual: @"Interstitial"]){
//        adFormat = @"REWARDED";
//    }
//    
//    if(self.blockCallbackAdDisplayed != nil){
//        self.blockCallbackAdDisplayed(@{@"adFormat" : adFormat});
//    }
}

/**
 Called after a rewarded video has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {}
/**
 Called after a rewarded video has been clicked.
 This callback is not supported by all networks, and we recommend using it
 only if it's supported by all networks you included in your build
 @param adInfo The info of the ad.
 */
- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {}

- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {}

- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {}

- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {}

- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {}

- (UIViewController *)unityViewController
{
    return UnityGetGLViewController() ?: UnityGetMainWindow().rootViewController ?: [KEY_WINDOW_IS rootViewController];
}

- (void)log:(NSString *)format, ...
{
    va_list valist;
    va_start(valist, format);
    NSString *message = [[NSString alloc] initWithFormat: format arguments: valist];
    va_end(valist);

    NSLog(@"[%@] [%@] %@", SDK_TAG, TAG, message);
}

+ (void)log:(NSString *)format, ...
{
    va_list valist;
    va_start(valist, format);
    NSString *message = [[NSString alloc] initWithFormat: format arguments: valist];
    va_end(valist);

    NSLog(@"[%@] [%@] %@", SDK_TAG, TAG, message);
}

- (void) SetSDKInitCallback:(void (^)(void))callback {
    self.blockCallbackWhenFinishInit = callback;
}

- (void)setAdClickCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback {
    self.blockCallbackWhenAdClicked = callback;
}

- (void)setAdDisplayCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback {
    self.blockCallbackAdDisplayed = callback;
}

- (void)setAdReadyCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback {
    self.blockCallbackAdReady = callback;
}

- (void)setAdRevenueCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback {
    self.blockCallbackAdRevenue = callback;
}

- (void)setAdRewardedCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback {
    self.blockCallbackAdRewarded = callback;
}

-(void)setInterAdClosedCallback:(void (^ _Nullable __strong)(NSDictionary<NSString *,id> * _Nullable __strong))callback{
    self.blockCallbackInterAdClosed = callback;
}

- (void)startCountDownDelayInter{
    _runtimeDelayInterAdsInSecond = _delayShowInter;
    _isCountingDownDelayInterAds = true;
    
    [self stopCountDownDelayInter];
    
    _interDelayTimer = [NSTimer scheduledTimerWithTimeInterval: INTERNAL_TIME
                          target: self
                        selector:@selector(onTick)
                          userInfo: nil repeats:YES];
}

-(void)onTick{
    if(_isRewardAdsShowing){
        [self log:@"reward ads is showing, skip this tick"];
        return;
    }
    
    if(_isInterAdsShowing){
        [self log:@"inter ads is showing, skip this tick"];
        return;
    }
    
    _runtimeDelayInterAdsInSecond -= INTERNAL_TIME;
    [self log:@"onTick current delaytime: %f",_runtimeDelayInterAdsInSecond];
    
    if(_runtimeDelayInterAdsInSecond <= 0){
        _isCountingDownDelayInterAds = false;
        [self stopCountDownDelayInter];
    }
}

-(void)stopCountDownDelayInter{
    [self log:@"stop countdown"];
    if(_interDelayTimer) {
        [_interDelayTimer invalidate];
        _interDelayTimer = nil;
    }
}

//

- (void)initializationDidComplete{
    // init iron sdk complete
    [ISIntegrationHelper validateIntegration];
    
    //test
    if(TEST)
        [IronSource launchTestSuite:[self unityViewController]];
    [self loadVideo];
    [self loadInter];
    
    _isPluginInitialized = true;
    if(self.blockCallbackWhenFinishInit)
        self.blockCallbackWhenFinishInit();
}

- (void)onAdClicked {
  
}

- (void)onAdClosed:(int)adType { 
    if(adType == 0) //rewared
    {
        
        _isRewardAdsShowing = false;
        [self loadVideo];
        
        if(!_isCountingDownDelayInterAds){
            NSInteger delaySec = _extraDelayInterAdsInSecond;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                _isCountingDownDelayInterAds = false;

                [self log:@" finish extra block inter time"];
            });
        }
    }else if(adType == 1) //inter ads
    {
        [self log:@"didHideAd: Inter"];
    
        _isInterAdsShowing = false;
        [self loadInter];
        
        if(self.codeRequestInter != RESUME_INTER_KEY){
            
            [self startCountDownDelayInter];

            self.blockCallbackInterAdClosed(@{@"requestCode" : [@(self.codeRequestInter) stringValue]});
        }else{
            self.blockCallbackInterAdClosed(@{@"requestCode" : [@(RESUME_INTER_KEY) stringValue]});
        }
        
    }
}

- (void)onAdImpressionRecorded: (ISImpressionData *)impressionData{
    NSMutableDictionary<NSString *, id> *adData = [NSMutableDictionary dictionary];
    adData[@"adPlatform"] = @"ironSource";
    adData[@"networkName"] = impressionData.ad_network;
    adData[@"revenue"] = impressionData.revenue;
    adData[@"adUnitId"] = impressionData.auction_id;

    if(impressionData.ad_network != nil)
        NSLog(@"onAdImpressionRecorded %@" ,impressionData.ad_network);
    
    if(impressionData.ad_unit != nil)
    {
        if([impressionData.ad_unit isEqualToString:@"banner"]){
            if(_currentBannerType == 1){
                adData[@"adFormat"] = @"mrec";
            }else{
                adData[@"adFormat"] = impressionData.ad_unit;
            }
        }else{
            adData[@"adFormat"] = impressionData.ad_unit;
        }
        
        NSLog(@"onAdImpressionRecorded %@" ,adData[@"adFormat"]);
    }
    
    
    if(self.blockCallbackAdRevenue != nil){
        self.blockCallbackAdRevenue(adData);
    }
}

- (void)onAdLoadFailed:(int)adType {
    if(adType == 0){
        // Rewarded ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        
        self.retryAttemptRewarded++;
        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptRewarded));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loadVideo];
        });
    }
    else if(adType == 1){
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
            
        self.retryAttemptInter++;
        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptInter));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loadInter];
        });
    }
}

- (void)onAdOpened:(int)adType {
    [self log:@"onAdOpened"];
    
    NSString* adFormat = @"";
    
    if(adType == 0){

        _isRewardAdsShowing = true;
        adFormat = @"REWARDED";
    }else if(adType == 1){
     
        _isInterAdsShowing = true;
        adFormat = @"INTER";
    }
    
    if(self.blockCallbackAdDisplayed != nil){
        self.blockCallbackAdDisplayed(@{@"adFormat" : adFormat});
    }
}

- (void)onAdLoaded:(int)adType {
    NSString* adFormat = @"";
    
    if(adType == 1){
        adFormat = @"INTER";
        self.retryAttemptInter = 0;
    }else if(adType == 0){
        adFormat = @"REWARDED";
        self.retryAttemptRewarded = 0;
    }
    
    if(self.blockCallbackAdReady != nil){
        self.blockCallbackAdReady(@{@"adFormat" : adFormat});
    }
}

- (void) onBannerLoaded:(ISBannerView *)bannerView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self log:@"onBanner Loaded"];
        @synchronized(self) {
            if (_bannerView) {
                [_bannerView removeFromSuperview];
            }
            
            _bannerView = bannerView;
            _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
            
            UIViewController *rootViewController = [self unityViewController];
            [rootViewController.view addSubview: _bannerView];
            
            NSLayoutConstraint *centerX = [_bannerView.centerXAnchor constraintEqualToAnchor:rootViewController.view.centerXAnchor];
            
            NSLayoutConstraint *bottom = [_bannerView.bottomAnchor constraintEqualToAnchor:rootViewController.view.safeAreaLayoutGuide.bottomAnchor];
            
//            NSLayoutConstraint *topAnchor = [_bannerView.topAnchor constraintEqualToAnchor:rootViewController.view.safeAreaLayoutGuide.topAnchor];
            
            NSLayoutConstraint *width = [_bannerView.widthAnchor constraintEqualToConstant:bannerView.frame.size.width];
            NSLayoutConstraint *height = [_bannerView.heightAnchor constraintEqualToConstant:bannerView.frame.size.height];
            [NSLayoutConstraint activateConstraints:@[centerX, bottom, width, height]];

        }
    });
}

- (void)onVideoRewarded { 
    if(self.blockCallbackAdRewarded != nil){
        self.blockCallbackAdRewarded(@{@"requestCode" : [@(self.codeRequestRewarded) stringValue]});
    }
}

@end
