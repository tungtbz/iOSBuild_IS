////
////  ApplovinAdsHelper.m
////  UnityFramework
////
////  Created by Admin on 01/08/2023.
////
//
//#import "ApplovinAdsHelper.h"
//
//#define RESUME_INTER_KEY 123456
//
//#define INTERNAL_TIME 1.0
//
//#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
//
//#define DEVICE_SPECIFIC_ADVIEW_AD_FORMAT ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? MAAdFormat.leader : MAAdFormat.banner
//#define IS_VERTICAL_BANNER_POSITION(_POS) ( [@"center_left" isEqual: adViewPosition] || [@"center_right" isEqual: adViewPosition] )
//#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
//
//#ifdef __cplusplus
//extern "C" {
//#endif
//    
//    // UnityAppController.mm
//    UIViewController* UnityGetGLViewController(void);
//    UIWindow* UnityGetMainWindow(void);
//    
//    // life cycle management
//    void UnityPause(int pause);
//    void UnitySendMessage(const char* obj, const char* method, const char* msg);
//    
//    void max_unity_dispatch_on_main_thread(dispatch_block_t block)
//    {
//        if ( block )
//        {
//            if ( [NSThread isMainThread] )
//            {
//                block();
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), block);
//            }
//        }
//    }
//#ifdef __cplusplus
//}
//#endif
//
//
//@interface ApplovinAdsHelper()<MAAdViewAdDelegate,MARewardedAdDelegate,MAAdRevenueDelegate,MAAdViewAdDelegate, MANativeAdDelegate>
//// Parent Fields
//@property (nonatomic, weak) ALSdk *sdk;
//
////Native Ad Fields
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MANativeAdLoader *> *nativeAdLoaders;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue*> *nativeAdSizes;
//
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAd *> *nativeAds;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *nativeAdViews;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, UIView *> *nativeAdContainerViews;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber*> *nativeRetryCounts;
//
//// Fullscreen Ad Fields
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAInterstitialAd *> *interstitials;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MARewardedAd *> *rewardedAds;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAppOpenAd *> *appOpenAds;
//// AdView Fields
//
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAdView *> *adViews;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAdFormat *> *adViewAdFormats;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *adViewPositions;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *adViewOffsets;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *adViewWidths;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *crossPromoAdViewHeights;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *crossPromoAdViewRotations;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAdFormat *> *verticalAdViewFormats;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<NSLayoutConstraint *> *> *adViewConstraints;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSString *> *> *adViewExtraParametersToSetAfterCreate;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, id> *> *adViewLocalExtraParametersToSetAfterCreate;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *adViewCustomDataToSetAfterCreate;
//
//@property (nonatomic, strong) NSMutableArray<NSString *> *adUnitIdentifiersToShowAfterCreate;
//@property (nonatomic, strong) NSMutableSet<NSString *> *disabledAdaptiveBannerAdUnitIdentifiers;
//@property (nonatomic, strong) NSMutableSet<NSString *> *disabledAutoRefreshAdViewAdUnitIdentifiers;
//@property (nonatomic, strong) UIView *safeAreaBackground;
//@property (nonatomic, strong, nullable) UIColor *publisherBannerBackgroundColor;
//
//@property (nonatomic, strong) NSMutableDictionary<NSString *, MAAd *> *adInfoDict;
//@property (nonatomic, strong) NSObject *adInfoDictLock;
//
//@property (nonatomic, strong) MAAdView *bannerAdView;
//
////local
//@property (nonatomic, assign) NSInteger retryAttemptInter;
//@property (nonatomic, assign) NSInteger retryAttemptRewarded;
//@property (nonatomic, assign) NSInteger codeRequestRewarded;
//@property (nonatomic, assign) NSInteger codeRequestInter;
////plist data
//@property (nonatomic, strong) NSDictionary *plistData;
//
////cache
//@property (nonatomic, strong) NSString *bannerUnitId;
//@property (nonatomic, strong) NSString *mrecUnitId;
//@property (nonatomic, strong) NSString *interUnitId;
//@property (nonatomic, strong) NSString *rewardUnitId;
//@property (nonatomic, strong) NSString *nativeUnitId;
//
////callback
//@property (nonatomic, strong) void (^blockCallbackWhenFinishInit)(void);
//
//@property (nonatomic, strong) void (^blockCallbackWhenAdClicked)(NSDictionary<NSString *, id> *);
//@property (nonatomic, strong) void (^blockCallbackAdRevenue)(NSDictionary<NSString *, id> *);
//@property (nonatomic, strong) void (^blockCallbackAdRewarded)(NSDictionary<NSString *, id> *);
//@property (nonatomic, strong) void (^blockCallbackAdReady)(NSDictionary<NSString *, id> *);
//@property (nonatomic, strong) void (^blockCallbackAdDisplayed)(NSDictionary<NSString *, id> *);
//@property (nonatomic, strong) void (^blockCallbackInterAdClosed)(NSDictionary<NSString *, id> *);
//
//@end
//
//// Internal
//@interface UIColor (ALUtils)
//+ (nullable UIColor *)al_colorWithHexString:(NSString *)hexString;
//@end
//
//@interface NSNumber (ALUtils)
//+ (NSNumber *)al_numberWithString:(NSString *)string;
//@end
//
//@interface NSString (ALUtils)
//@property (assign, readonly, getter=al_isValidString) BOOL al_validString;
//@end
//
//@interface MAAdFormat (ALUtils)
//@property (nonatomic, assign, readonly, getter=isFullscreenAd) BOOL fullscreenAd;
//@property (nonatomic, assign, readonly, getter=isAdViewAd) BOOL adViewAd;
//@end
//
//@implementation ApplovinAdsHelper
//static NSString *const SDK_TAG = @"ApplovinAdsHelper";
//static NSString *const TAG = @"MAUnityAdManager";
//
//
//+ (ApplovinAdsHelper * _Nonnull)sharedObject {
//    static ApplovinAdsHelper *sharedClass = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        sharedClass = [[self alloc] init];
//    });
//    
//    return sharedClass;
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if ( self )
//    {
//        _isInterAdsShowing = false;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//        self.plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
//        
//        self.nativeAdLoaders = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.nativeAds = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.nativeAdViews = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.nativeAdContainerViews = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.nativeRetryCounts = [NSMutableDictionary dictionaryWithCapacity: 2];
//        
//        self.interstitials = [NSMutableDictionary dictionaryWithCapacity: 2];
//
//        self.rewardedAds = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.appOpenAds = [NSMutableDictionary dictionaryWithCapacity: 2];
//        
//        self.adViews = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewAdFormats = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewPositions = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewOffsets = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewWidths = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.crossPromoAdViewHeights = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.crossPromoAdViewRotations = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.verticalAdViewFormats = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewConstraints = [NSMutableDictionary dictionaryWithCapacity: 2];
//        self.adViewExtraParametersToSetAfterCreate = [NSMutableDictionary dictionaryWithCapacity: 1];
//        self.adViewLocalExtraParametersToSetAfterCreate = [NSMutableDictionary dictionaryWithCapacity: 1];
//        self.adViewCustomDataToSetAfterCreate = [NSMutableDictionary dictionaryWithCapacity: 1];
//        self.adUnitIdentifiersToShowAfterCreate = [NSMutableArray arrayWithCapacity: 2];
//        self.disabledAdaptiveBannerAdUnitIdentifiers = [NSMutableSet setWithCapacity: 2];
//        self.disabledAutoRefreshAdViewAdUnitIdentifiers = [NSMutableSet setWithCapacity: 2];
//        self.adInfoDict = [NSMutableDictionary dictionary];
//        self.adInfoDictLock = [[NSObject alloc] init];
//        
//        max_unity_dispatch_on_main_thread(^{
//            self.safeAreaBackground = [[UIView alloc] init];
//            self.safeAreaBackground.hidden = YES;
//            self.safeAreaBackground.backgroundColor = UIColor.clearColor;
//            self.safeAreaBackground.translatesAutoresizingMaskIntoConstraints = NO;
//            self.safeAreaBackground.userInteractionEnabled = NO;
//            
//            UIViewController *rootViewController = [self unityViewController];
//            [rootViewController.view addSubview: self.safeAreaBackground];
//        });
//        
//// Enable orientation change listener, so that the position can be updated for vertical banners.
////        [[NSNotificationCenter defaultCenter] addObserverForName: UIDeviceOrientationDidChangeNotification
////                                                          object: nil
////                                                           queue: [NSOperationQueue mainQueue]
////                                                      usingBlock:^(NSNotification *notification) {
////
////            for ( NSString *adUnitIdentifier in self.verticalAdViewFormats )
////            {
////                [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: self.verticalAdViewFormats[adUnitIdentifier]];
////            }
////        }];
//    }
//    return self;
//}
//
//- (void) initWithCallback:(void (^)(void))callback {
//    self.blockCallbackWhenFinishInit = callback;
//}
//
//- (void)setAdClickCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackWhenAdClicked = callback;
//}
//
//- (void)setAdRevenueCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackAdRevenue = callback;
//}
//
//- (void)setAdDisplayCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackAdDisplayed = callback;
//}
//
//- (void)setAdRewardedCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackAdRewarded = callback;
//}
//
//- (void)setAdReadyCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackAdReady = callback;
//}
//
//- (void)setInterAdClosedCallback:(void (^)(NSDictionary<NSString *,id> * _Nullable))callback{
//    self.blockCallbackInterAdClosed = callback;
//}
//
//-(void) initAdsWithConsentFlow{
//    NSString* privacyLink = [self.plistData  objectForKey:@"PrivacyLink"];
//    NSString* sdkKey = [self.plistData  objectForKey:@"AppLovinSdkKey"];
////    BOOL debug = [self.plistData  objectForKey:@"IsDebug"];
//    
//    __weak ApplovinAdsHelper *weakSelf = self;
//    
//    ALSdkSettings *settings = [[ALSdkSettings alloc] init];
//    settings.termsAndPrivacyPolicyFlowSettings.enabled = NO;
//    settings.termsAndPrivacyPolicyFlowSettings.privacyPolicyURL = [NSURL URLWithString : privacyLink];
//    
//    [ALPrivacySettings setIsAgeRestrictedUser:false];
//    [ALPrivacySettings setHasUserConsent:true];
//    [ALPrivacySettings setDoNotSell:false];
//    
//    self.sdk = [ALSdk sharedWithKey: sdkKey settings: settings];
//    
//    // Please make sure to set the mediation provider value to @"max" to ensure proper functionality
//    self.sdk.mediationProvider = @"max";
//    [self.sdk initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
//        max_unity_dispatch_on_main_thread(^{
//            //init complete
//            _isPluginInitialized = true;
//            
//            ApplovinAdsHelper *strongSelf = weakSelf;
//            
//            //fire callback func
//            if(strongSelf.blockCallbackWhenFinishInit != nil){
//                [strongSelf log:@"initializeSdkWithCompletionHandler ==="];
//                strongSelf.blockCallbackWhenFinishInit();
//            }
////
////            if(debug)
////                [[ALSdk shared] showMediationDebugger];
//            
//        });
//        
//        //call on other
//        
//        [self createBanner];
//        [self createMrec];
//        [self loadInterstitial];
//        [self loadRewarded];
//    }];
//}
//
//-(BOOL) isPluginInitialized {
//    return _isPluginInitialized;
//}
//
//#pragma mark - Banner
//-(void) createBanner{
//    NSString* bannerPosition = [self.plistData  objectForKey:@"ALBannerPosition"];
//    self.bannerUnitId = [self.plistData  objectForKey:@"ALBannerId"];
//    
//    [self createBannerWithAdUnitIdentifier:self.bannerUnitId atPosition:bannerPosition];
//    [self setBannerExtraParameterForAdUnitIdentifier: self.bannerUnitId
//                                                       key: @"adaptive_banner"
//                                                     value: @"true"];
//    [self setBannerBackgroundColorForAdUnitIdentifier:self.bannerUnitId hexColorCode:@"#000000"];
//}
//
//- (void)createBannerWithAdUnitIdentifier:(NSString *)adUnitIdentifier atPosition:(NSString *)bannerPosition
//{
//    [self createAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier] atPosition: bannerPosition withOffset: CGPointZero];
//}
//
//- (void)showBannerWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self showAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier]];
//}
//
//- (void)hideBannerWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self hideAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier]];
//}
//
//- (void)destroyBannerWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self destroyAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier]];
//}
//
//#pragma mark MREC
//-(void) createMrec{
//    NSString* bannerPosition = [self.plistData  objectForKey:@"ALBannerPosition"];
//    self.mrecUnitId = [self.plistData  objectForKey:@"ALMrecId"];
//    
//    [self createMRecWithAdUnitIdentifier:self.mrecUnitId atPosition:bannerPosition];
//}
//
//- (void)createMRecWithAdUnitIdentifier:(NSString *)adUnitIdentifier atPosition:(NSString *)mrecPosition
//{
//    [self createAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: MAAdFormat.mrec atPosition: mrecPosition withOffset: CGPointZero];
//}
//
//- (void)setMRecExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier key:(NSString *)key value:(nullable NSString *)value
//{
//    [self setAdViewExtraParameterForAdUnitIdentifier: adUnitIdentifier adFormat: MAAdFormat.mrec key: key value: value];
//}
//
//- (void)showMRecWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self showAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: MAAdFormat.mrec];
//}
//
//- (void)destroyMRecWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self destroyAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: MAAdFormat.mrec];
//}
//
//- (void)hideMRecWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self hideAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: MAAdFormat.mrec];
//}
//
//#pragma mark - Inter
//-(void) loadInterstitial
//{
//    self.interUnitId = [self.plistData  objectForKey:@"ALInterId"];
//    [self loadInterstitialWithAdUnitIdentifier:self.interUnitId];
//}
//
//- (void)loadInterstitialWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MAInterstitialAd *interstitial = [self retrieveInterstitialForAdUnitIdentifier: adUnitIdentifier];
//    [interstitial loadAd];
//}
//
//- (BOOL)isInterstitialReadyWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    [self log: @"isInterstitialReadyWithAdUnitIdentifier"];
//    MAInterstitialAd *interstitial = [self retrieveInterstitialForAdUnitIdentifier: adUnitIdentifier];
//    return [interstitial isReady];
//}
//
//- (void)showInterstitialWithAdUnitIdentifier:(NSString *)adUnitIdentifier placement:(nullable NSString *)placement customData:(nullable NSString *)customData
//{
//    [self log: @"showInterstitialWithAdUnitIdentifier"];
//    MAInterstitialAd *interstitial = [self retrieveInterstitialForAdUnitIdentifier: adUnitIdentifier];
//    [interstitial showAdForPlacement: placement customData: customData];
//}
//
//- (void)setInterstitialExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier key:(NSString *)key value:(nullable NSString *)value
//{
//    MAInterstitialAd *interstitial = [self retrieveInterstitialForAdUnitIdentifier: adUnitIdentifier];
//    [interstitial setExtraParameterForKey: key value: value];
//}
//
//- (void)setInterstitialLocalExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier key:(NSString *)key value:(nullable id)value
//{
//    MAInterstitialAd *interstitial = [self retrieveInterstitialForAdUnitIdentifier: adUnitIdentifier];
//    [interstitial setLocalExtraParameterForKey: key value: value];
//}
//
//- (MAInterstitialAd *)retrieveInterstitialForAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MAInterstitialAd *result = self.interstitials[adUnitIdentifier];
//    if ( !result )
//    {
//        result = [[MAInterstitialAd alloc] initWithAdUnitIdentifier: adUnitIdentifier sdk: self.sdk];
//        result.delegate = self;
//        result.revenueDelegate = self;
////        result.adReviewDelegate = self;
//        
//        self.interstitials[adUnitIdentifier] = result;
//    }
//    
//    return result;
//}
//
//#pragma mark - Rewarded
//
//- (void)loadRewarded{
//    self.rewardUnitId = [self.plistData  objectForKey:@"ALRewardId"];
//    [self loadRewardedAdWithAdUnitIdentifier:self.rewardUnitId];
//}
//
//- (void)loadRewardedAdWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MARewardedAd *rewardedAd = [self retrieveRewardedAdForAdUnitIdentifier: adUnitIdentifier];
//    [rewardedAd loadAd];
//}
//
//- (BOOL)isRewardedAdReadyWithAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MARewardedAd *rewardedAd = [self retrieveRewardedAdForAdUnitIdentifier: adUnitIdentifier];
//    return [rewardedAd isReady];
//}
//
//- (void)showRewardedAdWithAdUnitIdentifier:(NSString *)adUnitIdentifier placement:(nullable NSString *)placement customData:(nullable NSString *)customData
//{
//    MARewardedAd *rewardedAd = [self retrieveRewardedAdForAdUnitIdentifier: adUnitIdentifier];
//    [rewardedAd showAdForPlacement: placement customData: customData];
//}
//
//- (void)setRewardedAdExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier key:(NSString *)key value:(nullable NSString *)value
//{
//    MARewardedAd *rewardedAd = [self retrieveRewardedAdForAdUnitIdentifier: adUnitIdentifier];
//    [rewardedAd setExtraParameterForKey: key value: value];
//}
//
//- (MARewardedAd *)retrieveRewardedAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MARewardedAd *result = self.rewardedAds[adUnitIdentifier];
//    if ( !result )
//    {
//        result = [MARewardedAd sharedWithAdUnitIdentifier: adUnitIdentifier sdk: self.sdk];
//        result.delegate = self;
//        result.revenueDelegate = self;
//        //result.adReviewDelegate = self;
//        
//        self.rewardedAds[adUnitIdentifier] = result;
//    }
//    
//    return result;
//}
//
//#pragma mark Appopen Ads
//
//-(NSString*) getAppOpenAdsId{
//    return [self.plistData objectForKey:@"ALAppOpenId"];
//}
//
//-(void)loadAppOpenAds{
//    [self loadAppOpenAdWithAdUnitIdentifier:[self getAppOpenAdsId]];
//}
//
//-(void)showAppOpenAds{
//    [self showAppOpenAdWithAdUnitIdentifier:[self getAppOpenAdsId] placement:nil customData:nil];
//}
//
//-(BOOL)isAppOpenAdsReady{
//    return [self isAppOpenAdReadyWithAdUnitIdentifier:[self getAppOpenAdsId]];
//}
//
//- (void)loadAppOpenAdWithAdUnitIdentifier:(NSString *)adUnitIdentifier{
//    MAAppOpenAd *appOpenAd = [self retrieveAppOpenAdForAdUnitIdentifier: adUnitIdentifier];
//    [appOpenAd loadAd];
//}
//
//- (BOOL)isAppOpenAdReadyWithAdUnitIdentifier:(NSString *)adUnitIdentifier{
//    MAAppOpenAd *appOpenAd = [self retrieveAppOpenAdForAdUnitIdentifier: adUnitIdentifier];
//    return [appOpenAd isReady];
//}
//
//- (void)showAppOpenAdWithAdUnitIdentifier:(NSString *)adUnitIdentifier placement:(nullable NSString *)placement customData:(nullable NSString *)customData{
//    MAAppOpenAd *appOpenAd = [self retrieveAppOpenAdForAdUnitIdentifier: adUnitIdentifier];
//    [appOpenAd showAdForPlacement: placement customData: customData];
//}
//
//- (MAAppOpenAd *)retrieveAppOpenAdForAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    MAAppOpenAd *result = self.appOpenAds[adUnitIdentifier];
//    if ( !result )
//    {
//        result = [[MAAppOpenAd alloc] initWithAdUnitIdentifier: adUnitIdentifier sdk: self.sdk];
//        result.delegate = self;
//        result.revenueDelegate = self;
//        
//        self.appOpenAds[adUnitIdentifier] = result;
//    }
//    
//    return result;
//}
//
//
//#pragma mark Native Ads
//
//- (void) showNativeMrec{
//    NSString* adUnitId = [self.plistData  objectForKey:@"ALNativeNormal"];
//    MANativeAdLoader * nativeAdLoader = [self getNativeAdLoader:adUnitId];
//    CGRect adViewSize = CGRectMake(0, 0, 300, 250);
//    self.nativeAdSizes[adUnitId] = [NSValue valueWithCGRect: adViewSize];
//    //create container view
//    
//    [nativeAdLoader loadAd];
//}
//
//- (void) hideNativeMrec{
//    NSString* adUnitId = [self.plistData  objectForKey:@"ALNativeNormal"];
//    UIView * cachedView = self.nativeAdContainerViews[adUnitId];
//    if(cachedView){
//        [cachedView setHidden:true];
//    }
//}
//
//- (void) showNativeBanner{
//    NSString* adUnitId = [self.plistData  objectForKey:@"ALNativeSmall"];
//    MANativeAdLoader * nativeAdLoader = [self getNativeAdLoader:adUnitId];
//    CGRect adViewSize = CGRectMake(0, 0, 360, 120);
//    self.nativeAdSizes[adUnitId] = [NSValue valueWithCGRect: adViewSize];
//    
//    [nativeAdLoader loadAd];
//}
//
//- (void) hideNativeBanner{
//    NSString* adUnitId = [self.plistData  objectForKey:@"ALNativeSmall"];
//    UIView * cachedView = self.nativeAdViews[adUnitId];
//    if(cachedView){
//        [cachedView setHidden:true];
//    }
//}
//
//-(MANativeAdLoader *) getNativeAdLoader :(NSString*) adUnitId{
//    MANativeAdLoader * result = self.nativeAdLoaders[adUnitId];
//    if(!result){
//        result = [[MANativeAdLoader alloc] initWithAdUnitIdentifier: adUnitId];
//        result.nativeAdDelegate = self;
//        result.revenueDelegate = self;
//        
//        self.nativeAdLoaders[adUnitId] = result;
//    }
//    
//    return result;
//}
//
//-(NSNumber *) getNativeAdRetryCount :(NSString*) adUnitId{
//    NSNumber * result = self.nativeRetryCounts[adUnitId];
//    if(!result){
//        result = [NSNumber numberWithInt:0];
//        self.nativeRetryCounts[adUnitId] = result;
//    }
//    
//    return result;
//}
//
//-(UIView *) getNativeAdView :(NSString*) adUnitId{
//    UIView * result = self.nativeAdViews[adUnitId];
//    if(!result){
//        
//    }
//    
//    return result;
//}
//
//- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
//    NSString * adUnitIdentifier = [ad adUnitIdentifier];
//    //reset count
//    NSNumber * retryCount = [self getNativeAdRetryCount:adUnitIdentifier];
//    NSNumber * newNum = [NSNumber numberWithInt:0];
//    self.nativeRetryCounts[adUnitIdentifier] = newNum;
//    
//    //clean old ad
//    MANativeAdLoader * nativeAdLoader = [self getNativeAdLoader:adUnitIdentifier];
//    MAAd * cachedAd = self.nativeAds[adUnitIdentifier];
//    if(cachedAd){
//        [nativeAdLoader destroyAd:cachedAd];
//    }
//    
//    UIView * cachedView = self.nativeAdViews[adUnitIdentifier];
//    if(cachedView){
//        [cachedView removeFromSuperview];
//    }
//    
//    //save new ad
//    cachedAd = ad;
//    self.nativeAds[adUnitIdentifier] = cachedAd;
//    
//    cachedView = nativeAdView;
//    self.nativeAdViews[adUnitIdentifier] = cachedView;
//    
//    //add view
//    
//    UIViewController *rootViewController = [self unityViewController];
//    [rootViewController.view addSubview: cachedView];
//}
//
//- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
//    // We recommend retrying with exponentially higher delays up to a maximum delay
//    NSNumber * retryCount = [self getNativeAdRetryCount:adUnitIdentifier];
//    NSNumber * newNum = [NSNumber numberWithInt:[retryCount intValue] + 1];
//    self.nativeRetryCounts[adUnitIdentifier] = newNum;
//    
//    NSInteger delaySec = pow(2, MIN(6, [newNum intValue]));
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        MANativeAdLoader * nativeAdLoader = [self getNativeAdLoader:adUnitIdentifier];
//        [nativeAdLoader loadAd];
//    });
//}
//
//- (void)didClickNativeAd:(MAAd *)ad {
//    // Optional click callback
//}
//
////=========
//
//- (void)showAdViewWithAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Showing %@ with ad unit identifier \"%@\"", adFormat, adUnitIdentifier];
//        
//        MAAdView *view = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        if ( !view )
//        {
//            [self log: @"%@ does not exist for ad unit identifier %@.", adFormat, adUnitIdentifier];
//            
//            // The adView has not yet been created. Store the ad unit ID, so that it can be displayed once the banner has been created.
//            [self.adUnitIdentifiersToShowAfterCreate addObject: adUnitIdentifier];
//        }
//        else
//        {
//            // Check edge case where ad may be detatched from view controller
//            if ( !view.window.rootViewController )
//            {
//                [self log: @"%@ missing view controller - re-attaching to %@...", adFormat, [self unityViewController]];
//                
//                UIViewController *rootViewController = [self unityViewController];
//                [rootViewController.view addSubview: view];
//                
//                [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//            }
//        }
//        
//        self.safeAreaBackground.hidden = NO;
//        view.hidden = NO;
//        
//        if ( ![self.disabledAutoRefreshAdViewAdUnitIdentifiers containsObject: adUnitIdentifier] )
//        {
//            [self log: @"Refresh ad unit identifier \"%@\"", adUnitIdentifier];
//            [view startAutoRefresh];
//        }
//    });
//}
//
//- (void)hideAdViewWithAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Hiding %@ with ad unit identifier \"%@\"", adFormat, adUnitIdentifier];
//        [self.adUnitIdentifiersToShowAfterCreate removeObject: adUnitIdentifier];
//        
//        MAAdView *view = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        view.hidden = YES;
//        self.safeAreaBackground.hidden = YES;
//        
//        [view stopAutoRefresh];
//    });
//}
//
//- (void)destroyAdViewWithAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Destroying %@ with ad unit identifier \"%@\"", adFormat, adUnitIdentifier];
//        
//        MAAdView *view = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        view.delegate = nil;
//        view.revenueDelegate = nil;
//        view.adReviewDelegate = nil;
//        
//        [view removeFromSuperview];
//        
//        [self.adViews removeObjectForKey: adUnitIdentifier];
//        [self.adViewAdFormats removeObjectForKey: adUnitIdentifier];
//        [self.adViewPositions removeObjectForKey: adUnitIdentifier];
//        [self.adViewOffsets removeObjectForKey: adUnitIdentifier];
//        [self.adViewWidths removeObjectForKey: adUnitIdentifier];
//        [self.crossPromoAdViewHeights removeObjectForKey: adUnitIdentifier];
//        [self.crossPromoAdViewRotations removeObjectForKey: adUnitIdentifier];
//        [self.verticalAdViewFormats removeObjectForKey: adUnitIdentifier];
//        [self.disabledAdaptiveBannerAdUnitIdentifiers removeObject: adUnitIdentifier];
//    });
//}
//
//- (UIViewController *)unityViewController
//{
//    // Handle edge case where `UnityGetGLViewController()` returns nil
//    return UnityGetGLViewController() ?: UnityGetMainWindow().rootViewController ?: [KEY_WINDOW rootViewController];
//}
//
//- (void)setBannerExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier key:(NSString *)key value:(nullable NSString *)value
//{
//    [self setAdViewExtraParameterForAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier] key: key value: value];
//}
//
//- (void)setAdViewExtraParameterForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat key:(NSString *)key value:(nullable NSString *)value
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Setting %@ extra with key: \"%@\" value: \"%@\"", adFormat, key, value];
//        
//        MAAdView *adView = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        if ( adView )
//        {
//            [adView setExtraParameterForKey: key value: value];
//        }
//        else
//        {
//            [self log: @"%@ does not exist for ad unit identifier %@. Saving extra parameter to be set when it is created.", adFormat, adUnitIdentifier];
//            
//            // The adView has not yet been created. Store the extra parameters, so that they can be added once the banner has been created.
//            NSMutableDictionary<NSString *, NSString *> *extraParameters = self.adViewExtraParametersToSetAfterCreate[adUnitIdentifier];
//            if ( !extraParameters )
//            {
//                extraParameters = [NSMutableDictionary dictionaryWithCapacity: 1];
//                self.adViewExtraParametersToSetAfterCreate[adUnitIdentifier] = extraParameters;
//            }
//            
//            extraParameters[key] = value;
//        }
//        
//        // Certain extra parameters need to be handled immediately
//        [self handleExtraParameterChangesIfNeededForAdUnitIdentifier: adUnitIdentifier
//                                                            adFormat: adFormat
//                                                                 key: key
//                                                               value: value];
//    });
//}
//
//- (void)setBannerBackgroundColorForAdUnitIdentifier:(NSString *)adUnitIdentifier hexColorCode:(NSString *)hexColorCode
//{
//    [self setAdViewBackgroundColorForAdUnitIdentifier: adUnitIdentifier adFormat: [self adViewAdFormatForAdUnitIdentifier: adUnitIdentifier] hexColorCode: hexColorCode];
//}
//
//- (void)setAdViewBackgroundColorForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat hexColorCode:(NSString *)hexColorCode
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Setting %@ with ad unit identifier \"%@\" to color: \"%@\"", adFormat, adUnitIdentifier, hexColorCode];
//        
//        // In some cases, black color may get redrawn on each frame update, resulting in an undesired flicker
//        NSString *hexColorCodeToUse = [hexColorCode containsString: @"FF000000"] ? @"FF000001" : hexColorCode;
//        UIColor *convertedColor = [UIColor al_colorWithHexString: hexColorCodeToUse];
//        
//        MAAdView *view = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        self.publisherBannerBackgroundColor = convertedColor;
//        self.safeAreaBackground.backgroundColor = view.backgroundColor = convertedColor;
//        
//        // Position adView to ensure logic that depends on background color is properly run
//        [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//    });
//}
//
//- (void)createAdViewWithAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat atPosition:(NSString *)adViewPosition withOffset:(CGPoint)offset
//{
//    max_unity_dispatch_on_main_thread(^{
//        [self log: @"Creating %@ with ad unit identifier \"%@\" and position: \"%@\"", adFormat, adUnitIdentifier, adViewPosition];
//        
//        if ( self.adViews[adUnitIdentifier] )
//        {
//            [self log: @"Trying to create a %@ that was already created. This will cause the current ad to be hidden.", adFormat.label];
//        }
//        
//        // Retrieve ad view from the map
//        MAAdView *adView = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat atPosition: adViewPosition withOffset: offset];
//        adView.hidden = YES;
//        self.safeAreaBackground.hidden = YES;
//        
//        // Position ad view immediately so if publisher sets color before ad loads, it will not be the size of the screen
//        self.adViewAdFormats[adUnitIdentifier] = adFormat;
//        [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        
//        // Enable adaptive banners by default.
//        if ( ( self.adViewExtraParametersToSetAfterCreate[@"adaptive_banner"] != nil ) && ( adFormat == MAAdFormat.banner || adFormat == MAAdFormat.leader ) )
//        {
//            [adView setExtraParameterForKey: @"adaptive_banner" value: @"true"];
//        }
//        
//        // Handle initial extra parameters if publisher sets it before creating ad view
//        if ( self.adViewExtraParametersToSetAfterCreate[adUnitIdentifier] )
//        {
//            NSDictionary<NSString *, NSString *> *extraParameters = self.adViewExtraParametersToSetAfterCreate[adUnitIdentifier];
//            for ( NSString *key in extraParameters )
//            {
//                [adView setExtraParameterForKey: key value: extraParameters[key]];
//                
//                [self handleExtraParameterChangesIfNeededForAdUnitIdentifier: adUnitIdentifier
//                                                                    adFormat: adFormat
//                                                                         key: key
//                                                                       value: extraParameters[key]];
//            }
//            
//            [self.adViewExtraParametersToSetAfterCreate removeObjectForKey: adUnitIdentifier];
//        }
//        
//        // Handle initial local extra parameters if publisher sets it before creating ad view
//        if ( self.adViewLocalExtraParametersToSetAfterCreate[adUnitIdentifier] )
//        {
//            NSDictionary<NSString *, NSString *> *localExtraParameters = self.adViewLocalExtraParametersToSetAfterCreate[adUnitIdentifier];
//            for ( NSString *key in localExtraParameters )
//            {
//                [adView setLocalExtraParameterForKey: key value: localExtraParameters[key]];
//            }
//            
//            [self.adViewLocalExtraParametersToSetAfterCreate removeObjectForKey: adUnitIdentifier];
//        }
//        
//        // Handle initial custom data if publisher sets it before creating ad view
//        if ( self.adViewCustomDataToSetAfterCreate[adUnitIdentifier] )
//        {
//            NSString *customData = self.adViewCustomDataToSetAfterCreate[adUnitIdentifier];
//            adView.customData = customData;
//            
//            [self.adViewCustomDataToSetAfterCreate removeObjectForKey: adUnitIdentifier];
//        }
//        
//        [adView loadAd];
//        
//        // Disable auto-refresh if publisher sets it before creating the ad view.
//        if ( [self.disabledAutoRefreshAdViewAdUnitIdentifiers containsObject: adUnitIdentifier] )
//        {
//            [adView stopAutoRefresh];
//        }
//        
//        // The publisher may have requested to show the banner before it was created. Now that the banner is created, show it.
//        if ( [self.adUnitIdentifiersToShowAfterCreate containsObject: adUnitIdentifier] )
//        {
//            [self showAdViewWithAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//            [self.adUnitIdentifiersToShowAfterCreate removeObject: adUnitIdentifier];
//        }
//    });
//}
//
//- (void)positionAdViewForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat
//{
//    max_unity_dispatch_on_main_thread(^{
//        MAAdView *adView = [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        NSString *adViewPosition = self.adViewPositions[adUnitIdentifier];
//        NSValue *adViewPositionValue = self.adViewOffsets[adUnitIdentifier];
//        CGPoint adViewOffset = [adViewPositionValue CGPointValue];
//        BOOL isAdaptiveBannerDisabled = [self.disabledAdaptiveBannerAdUnitIdentifiers containsObject: adUnitIdentifier];
//        BOOL isWidthPtsOverridden = self.adViewWidths[adUnitIdentifier] != nil;
//        BOOL isCrossPromoHeightPtsOverridden = self.crossPromoAdViewHeights[adUnitIdentifier] != nil;
//        BOOL isCrossPromoRotationOverridden = self.crossPromoAdViewRotations[adUnitIdentifier] != nil;
//        
//        UIView *superview = adView.superview;
//        if ( !superview ) return;
//        
//        // Deactivate any previous constraints and reset rotation so that the banner can be positioned again.
//        NSArray<NSLayoutConstraint *> *activeConstraints = self.adViewConstraints[adUnitIdentifier];
//        [NSLayoutConstraint deactivateConstraints: activeConstraints];
//        adView.transform = CGAffineTransformIdentity;
//        [self.verticalAdViewFormats removeObjectForKey: adUnitIdentifier];
//        
//        // Ensure superview contains the safe area background.
//        if ( ![superview.subviews containsObject: self.safeAreaBackground] )
//        {
//            [self.safeAreaBackground removeFromSuperview];
//            [superview insertSubview: self.safeAreaBackground belowSubview: adView];
//        }
//        
//        // Deactivate any previous constraints and reset visibility state so that the safe area background can be positioned again.
//        [NSLayoutConstraint deactivateConstraints: self.safeAreaBackground.constraints];
//        self.safeAreaBackground.hidden = adView.hidden;
//        
//        //
//        // Determine ad width
//        //
//        CGFloat adViewWidth;
//        
//        // Check if publisher has overridden width as points
//        if ( isWidthPtsOverridden )
//        {
//            adViewWidth = self.adViewWidths[adUnitIdentifier].floatValue;
//        }
//        // Top center / bottom center stretches full screen
//        else if ( [adViewPosition isEqual: @"top_center"] || [adViewPosition isEqual: @"bottom_center"] )
//        {
//            adViewWidth = CGRectGetWidth(KEY_WINDOW.bounds);
//        }
//        // Else use standard widths of 320, 728, or 300
//        else
//        {
//            adViewWidth = adFormat.size.width;
//        }
//        
//        //
//        // Determine ad height
//        //
//        CGFloat adViewHeight;
//        
//        if ( isCrossPromoHeightPtsOverridden )
//        {
//            adViewHeight = self.crossPromoAdViewHeights[adUnitIdentifier].floatValue;
//        }
//        else if ( (adFormat == MAAdFormat.banner || adFormat == MAAdFormat.leader) && !isAdaptiveBannerDisabled )
//        {
//            adViewHeight = [adFormat adaptiveSizeForWidth: adViewWidth].height;
//        }
//        else
//        {
//            adViewHeight = adFormat.size.height;
//        }
//        
//        CGSize adViewSize = CGSizeMake(adViewWidth, adViewHeight);
//        
//        // All positions have constant height
//        NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray arrayWithObject: [adView.heightAnchor constraintEqualToConstant: adViewSize.height]];
//        
//        UILayoutGuide *layoutGuide;
//        if ( @available(iOS 11.0, *) )
//        {
//            layoutGuide = superview.safeAreaLayoutGuide;
//        }
//        else
//        {
//            layoutGuide = superview.layoutMarginsGuide;
//        }
//        
//        if ( [adViewPosition isEqual: @"top_center"] || [adViewPosition isEqual: @"bottom_center"] )
//        {
//            // Non AdMob banners will still be of 50/90 points tall. Set the auto sizing mask such that the inner ad view is pinned to the bottom or top according to the ad view position.
//            if ( !isAdaptiveBannerDisabled )
//            {
//                adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//                
//                if ( [@"top_center" isEqual: adViewPosition] )
//                {
//                    adView.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
//                }
//                else // bottom_center
//                {
//                    adView.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
//                }
//            }
//            
//            // If publisher actually provided a banner background color
//            if ( self.publisherBannerBackgroundColor && adFormat != MAAdFormat.mrec )
//            {
//                if ( isWidthPtsOverridden )
//                {
//                    [constraints addObjectsFromArray: @[[adView.widthAnchor constraintEqualToConstant: adViewWidth],
//                                                        [adView.centerXAnchor constraintEqualToAnchor: layoutGuide.centerXAnchor],
//                                                        [self.safeAreaBackground.widthAnchor constraintEqualToConstant: adViewWidth],
//                                                        [self.safeAreaBackground.centerXAnchor constraintEqualToAnchor: layoutGuide.centerXAnchor]]];
//                    
//                    if ( [adViewPosition isEqual: @"top_center"] )
//                    {
//                        [constraints addObjectsFromArray: @[[adView.topAnchor constraintEqualToAnchor: layoutGuide.topAnchor],
//                                                            [self.safeAreaBackground.topAnchor constraintEqualToAnchor: superview.topAnchor],
//                                                            [self.safeAreaBackground.bottomAnchor constraintEqualToAnchor: adView.topAnchor]]];
//                    }
//                    else // bottom_center
//                    {
//                        [constraints addObjectsFromArray: @[[adView.bottomAnchor constraintEqualToAnchor: layoutGuide.bottomAnchor],
//                                                            [self.safeAreaBackground.topAnchor constraintEqualToAnchor: adView.bottomAnchor],
//                                                            [self.safeAreaBackground.bottomAnchor constraintEqualToAnchor: superview.bottomAnchor]]];
//                    }
//                }
//                else
//                {
//                    [constraints addObjectsFromArray: @[[adView.leftAnchor constraintEqualToAnchor: superview.leftAnchor],
//                                                        [adView.rightAnchor constraintEqualToAnchor: superview.rightAnchor],
//                                                        [self.safeAreaBackground.leftAnchor constraintEqualToAnchor: superview.leftAnchor],
//                                                        [self.safeAreaBackground.rightAnchor constraintEqualToAnchor: superview.rightAnchor]]];
//                    
//                    if ( [adViewPosition isEqual: @"top_center"] )
//                    {
//                        [constraints addObjectsFromArray: @[[adView.topAnchor constraintEqualToAnchor: layoutGuide.topAnchor],
//                                                            [self.safeAreaBackground.topAnchor constraintEqualToAnchor: superview.topAnchor],
//                                                            [self.safeAreaBackground.bottomAnchor constraintEqualToAnchor: adView.topAnchor]]];
//                    }
//                    else // bottom_center
//                    {
//                        [constraints addObjectsFromArray: @[[adView.bottomAnchor constraintEqualToAnchor: layoutGuide.bottomAnchor],
//                                                            [self.safeAreaBackground.topAnchor constraintEqualToAnchor: adView.bottomAnchor],
//                                                            [self.safeAreaBackground.bottomAnchor constraintEqualToAnchor: superview.bottomAnchor]]];
//                    }
//                }
//            }
//            // If pub does not have a background color set or this is not a banner
//            else
//            {
//                self.safeAreaBackground.hidden = YES;
//                
//                [constraints addObjectsFromArray: @[[adView.widthAnchor constraintEqualToConstant: adViewWidth],
//                                                    [adView.centerXAnchor constraintEqualToAnchor: layoutGuide.centerXAnchor]]];
//                
//                if ( [adViewPosition isEqual: @"top_center"] )
//                {
//                    [constraints addObject: [adView.topAnchor constraintEqualToAnchor: layoutGuide.topAnchor]];
//                }
//                else // BottomCenter
//                {
//                    [constraints addObject: [adView.bottomAnchor constraintEqualToAnchor: layoutGuide.bottomAnchor]];
//                }
//            }
//        }
//        // Check if the publisher wants vertical banners.
//        else if ( [adViewPosition isEqual: @"center_left"] || [adViewPosition isEqual: @"center_right"] )
//        {
//            if ( MAAdFormat.mrec == adFormat )
//            {
//                [constraints addObject: [adView.widthAnchor constraintEqualToConstant: adViewSize.width]];
//                
//                if ( [adViewPosition isEqual: @"center_left"] )
//                {
//                    [constraints addObjectsFromArray: @[[adView.centerYAnchor constraintEqualToAnchor: layoutGuide.centerYAnchor],
//                                                        [adView.leftAnchor constraintEqualToAnchor: superview.leftAnchor]]];
//                    
//                    [constraints addObjectsFromArray: @[[self.safeAreaBackground.rightAnchor constraintEqualToAnchor: layoutGuide.leftAnchor],
//                                                        [self.safeAreaBackground.leftAnchor constraintEqualToAnchor: superview.leftAnchor]]];
//                }
//                else // center_right
//                {
//                    [constraints addObjectsFromArray: @[[adView.centerYAnchor constraintEqualToAnchor: layoutGuide.centerYAnchor],
//                                                        [adView.rightAnchor constraintEqualToAnchor: superview.rightAnchor]]];
//                    
//                    [constraints addObjectsFromArray: @[[self.safeAreaBackground.leftAnchor constraintEqualToAnchor: layoutGuide.rightAnchor],
//                                                        [self.safeAreaBackground.rightAnchor constraintEqualToAnchor: superview.rightAnchor]]];
//                }
//            }
//            else
//            {
//                /* Align the center of the view such that when rotated it snaps into place.
//                 *
//                 *                  +---+---+-------+
//                 *                  |   |           |
//                 *                  |   |           |
//                 *                  |   |           |
//                 *                  |   |           |
//                 *                  |   |           |
//                 *                  |   |           |
//                 *    +-------------+---+-----------+--+
//                 *    |             | + |   +       |  |
//                 *    +-------------+---+-----------+--+
//                 *                  <+> |           |
//                 *                  |+  |           |
//                 *                  ||  |           |
//                 *                  ||  |           |
//                 *                  ||  |           |
//                 *                  ||  |           |
//                 *                  +|--+-----------+
//                 *                   v
//                 *            Banner Half Height
//                 */
//                self.safeAreaBackground.hidden = YES;
//                
//                adView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
//                
//                CGFloat width;
//                // If the publiser has a background color set - set the width to the height of the screen, to span the ad across the screen after it is rotated.
//                if ( self.publisherBannerBackgroundColor )
//                {
//                    if ( isWidthPtsOverridden )
//                    {
//                        width = adViewWidth;
//                    }
//                    else
//                    {
//                        width = CGRectGetHeight(KEY_WINDOW.bounds);
//                    }
//                }
//                // Otherwise - we shouldn't span the banner the width of the realm (there might be user-interactable UI on the sides)
//                else
//                {
//                    width = adViewWidth;
//                }
//                [constraints addObject: [adView.widthAnchor constraintEqualToConstant: width]];
//                
//                // Set constraints such that the center of the banner aligns with the center left or right as needed. That way, once rotated, the banner snaps into place.
//                [constraints addObject: [adView.centerYAnchor constraintEqualToAnchor: superview.centerYAnchor]];
//                
//                // Place the center of the banner half the height of the banner away from the side. If we align the center exactly with the left/right anchor, only half the banner will be visible.
//                CGFloat bannerHalfHeight = adViewSize.height / 2.0;
//                UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//                if ( [adViewPosition isEqual: @"center_left"] )
//                {
//                    NSLayoutAnchor *anchor = ( orientation == UIInterfaceOrientationLandscapeRight ) ? layoutGuide.leftAnchor : superview.leftAnchor;
//                    [constraints addObject: [adView.centerXAnchor constraintEqualToAnchor: anchor constant: bannerHalfHeight]];
//                }
//                else // CenterRight
//                {
//                    NSLayoutAnchor *anchor = ( orientation == UIInterfaceOrientationLandscapeLeft ) ? layoutGuide.rightAnchor : superview.rightAnchor;
//                    [constraints addObject: [adView.centerXAnchor constraintEqualToAnchor: anchor constant: -bannerHalfHeight]];
//                }
//                
//                // Store the ad view with format, so that it can be updated when the orientation changes.
//                self.verticalAdViewFormats[adUnitIdentifier] = adFormat;
//                
//                // If adaptive - make top flexible since we anchor with the bottom of the banner at the edge of the screen
//                if ( !isAdaptiveBannerDisabled )
//                {
//                    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//                }
//            }
//        }
//        // Otherwise, publisher will likely construct his own views around the adview
//        else
//        {
//            self.safeAreaBackground.hidden = YES;
//            
//            [constraints addObject: [adView.widthAnchor constraintEqualToConstant: adViewWidth]];
//            
//            if ( [adViewPosition isEqual: @"top_left"] )
//            {
//                [constraints addObjectsFromArray: @[[adView.leftAnchor constraintEqualToAnchor: superview.leftAnchor constant: adViewOffset.x],
//                                                    [adView.topAnchor constraintEqualToAnchor: layoutGuide.topAnchor constant: adViewOffset.y]]];
//            }
//            else if ( [adViewPosition isEqual: @"top_right"] )
//            {
//                [constraints addObjectsFromArray: @[[adView.topAnchor constraintEqualToAnchor: layoutGuide.topAnchor],
//                                                    [adView.rightAnchor constraintEqualToAnchor: superview.rightAnchor]]];
//            }
//            else if ( [adViewPosition isEqual: @"centered"] )
//            {
//                [constraints addObjectsFromArray: @[[adView.centerXAnchor constraintEqualToAnchor: layoutGuide.centerXAnchor],
//                                                    [adView.centerYAnchor constraintEqualToAnchor: layoutGuide.centerYAnchor]]];
//            }
//            else if ( [adViewPosition isEqual: @"bottom_left"] )
//            {
//                [constraints addObjectsFromArray: @[[adView.bottomAnchor constraintEqualToAnchor: layoutGuide.bottomAnchor],
//                                                    [adView.leftAnchor constraintEqualToAnchor: superview.leftAnchor]]];
//            }
//            else if ( [adViewPosition isEqual: @"bottom_right"] )
//            {
//                [constraints addObjectsFromArray: @[[adView.bottomAnchor constraintEqualToAnchor: layoutGuide.bottomAnchor],
//                                                    [adView.rightAnchor constraintEqualToAnchor: superview.rightAnchor]]];
//            }
//        }
//        
//        if ( isCrossPromoRotationOverridden )
//        {
//            adView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(self.crossPromoAdViewRotations[adUnitIdentifier].floatValue));
//        }
//        
//        self.adViewConstraints[adUnitIdentifier] = constraints;
//        
//        [NSLayoutConstraint activateConstraints: constraints];
//    });
//}
//
//- (MAAdView *)retrieveAdViewForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat
//{
//    return [self retrieveAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat atPosition: nil withOffset: CGPointZero];
//}
//
//- (MAAdView *)retrieveAdViewForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat atPosition:(NSString *)adViewPosition withOffset:(CGPoint)offset
//{
//    MAAdView *result = self.adViews[adUnitIdentifier];
//    if ( !result && adViewPosition )
//    {
//        result = [[MAAdView alloc] initWithAdUnitIdentifier: adUnitIdentifier adFormat: adFormat sdk: self.sdk];
//        // There is a Unity bug where if an empty UIView is on screen with user interaction enabled, and a user interacts with it, it just passes the events to random parts of the screen.
//        result.userInteractionEnabled = NO;
//        result.translatesAutoresizingMaskIntoConstraints = NO;
//        result.delegate = self;
//        result.revenueDelegate = self;
////        result.adReviewDelegate = self;
//        
//        self.adViews[adUnitIdentifier] = result;
//        self.adViewPositions[adUnitIdentifier] = adViewPosition;
//        self.adViewOffsets[adUnitIdentifier] = [NSValue valueWithCGPoint: offset];
//        
//        UIViewController *rootViewController = [self unityViewController];
//        [rootViewController.view addSubview: result];
//        
//        // Allow pubs to pause auto-refresh immediately, by default.
//        [result setExtraParameterForKey: @"allow_pause_auto_refresh_immediately" value: @"true"];
//    }
//    
//    return result;
//}
//
//- (void)handleExtraParameterChangesIfNeededForAdUnitIdentifier:(NSString *)adUnitIdentifier adFormat:(MAAdFormat *)adFormat key:(NSString *)key value:(nullable NSString *)value
//{
//    if ( MAAdFormat.mrec != adFormat )
//    {
//        if ( [@"force_banner" isEqualToString: key] )
//        {
//            BOOL shouldForceBanner = [NSNumber al_numberWithString: value].boolValue;
//            MAAdFormat *forcedAdFormat = shouldForceBanner ? MAAdFormat.banner : DEVICE_SPECIFIC_ADVIEW_AD_FORMAT;
//            
//            self.adViewAdFormats[adUnitIdentifier] = forcedAdFormat;
//            [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: forcedAdFormat];
//        }
//        else if ( [@"adaptive_banner" isEqualToString: key] )
//        {
//            BOOL shouldUseAdaptiveBanner = [NSNumber al_numberWithString: value].boolValue;
//            if ( shouldUseAdaptiveBanner )
//            {
//                [self.disabledAdaptiveBannerAdUnitIdentifiers removeObject: adUnitIdentifier];
//            }
//            else
//            {
//                [self.disabledAdaptiveBannerAdUnitIdentifiers addObject: adUnitIdentifier];
//            }
//            
//            [self positionAdViewForAdUnitIdentifier: adUnitIdentifier adFormat: adFormat];
//        }
//    }
//}
//
//- (MAAdFormat *)adViewAdFormatForAdUnitIdentifier:(NSString *)adUnitIdentifier
//{
//    if ( self.adViewAdFormats[adUnitIdentifier] )
//    {
//        return self.adViewAdFormats[adUnitIdentifier];
//    }
//    else
//    {
//        return DEVICE_SPECIFIC_ADVIEW_AD_FORMAT;
//    }
//}
//
//- (void)positionAdViewForAd:(MAAd *)ad
//{
//    [self positionAdViewForAdUnitIdentifier: ad.adUnitIdentifier adFormat: ad.format];
//}
//
//
//- (void)logInvalidAdFormat:(MAAdFormat *)adFormat
//{
//    [self log: @"invalid ad format: %@, from %@", adFormat, [NSThread callStackSymbols]];
//}
//
//- (void)log:(NSString *)format, ...
//{
//    va_list valist;
//    va_start(valist, format);
//    NSString *message = [[NSString alloc] initWithFormat: format arguments: valist];
//    va_end(valist);
//    
//    NSLog(@"[%@] [%@] %@", SDK_TAG, TAG, message);
//}
//
//+ (void)log:(NSString *)format, ...
//{
//    va_list valist;
//    va_start(valist, format);
//    NSString *message = [[NSString alloc] initWithFormat: format arguments: valist];
//    va_end(valist);
//    
//    NSLog(@"[%@] [%@] %@", SDK_TAG, TAG, message);
//}
//
//+ (void)forwardUnityEventWithArgs:(NSDictionary<NSString *, id> *)args
//{
//    [ApplovinAdsHelper forwardUnityEventWithArgs: args forwardInBackground: NO];
//}
//
//+ (void)forwardUnityEventWithArgs:(NSDictionary<NSString *, id> *)args forwardInBackground:(BOOL)forwardInBackground
//{
//#if !IS_TEST_APP
//    char *serializedParameters = [self serializeParameters: args].UTF8String;
////    if ( forwardInBackground )
////    {
////        backgroundCallback(serializedParameters);
////    }
////    else
////    {
////        UnitySendMessage("MaxSdkCallbacks", "ForwardEvent", serializedParameters);
////    }
//    
//    UnitySendMessage("MaxSdkCallbacks", "ForwardEvent", serializedParameters);
//#endif
//}
//
//+ (NSString *)serializeParameters:(NSDictionary<NSString *, id> *)dict
//{
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict options: 0 error: nil];
//    return [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
//}
//
//+ (NSDictionary<NSString *, id> *)deserializeParameters:(NSString *)serialized
//{
//    if ( serialized.length > 0 )
//    {
//        NSError *error;
//        NSDictionary<NSString *, id> *deserialized = [NSJSONSerialization JSONObjectWithData: [serialized dataUsingEncoding:NSUTF8StringEncoding]
//                                                                                     options: 0
//                                                                                       error: &error];
//        if ( error )
//        {
////            [self log: @"Failed to deserialize (%@) with error %@", serialized, error];
//            NSLog(@"Failed to deserialize (%@) with error %@", serialized, error);
//            return @{};
//        }
//        
//        return deserialized;
//    }
//    else
//    {
//        return @{};
//    }
//}
//
//- (void)didClickAd:(nonnull MAAd *)ad {
//    //block inter auto show
//    _isAdClicked = true;
////    NSInteger delaySec = 30;
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
////        _isBlockInterAds = false;
////    });
//    
//    MAAdFormat *adFormat = ad.format;
//    if ( ![adFormat isFullscreenAd] ) return;
//    
//    NSString *name;
//
//    if ( MAAdFormat.interstitial == adFormat ){
//        name = @"OnInterstitialAdDisplayEvent";
//        _isAdClicked = false;
//    }
//    else if ( MAAdFormat.rewarded == adFormat ){
//        name = @"OnRewardedAdDisplayEvent";
//    }
//    
//    NSDictionary<NSString *, id> *args = [self defaultAdEventParametersForName: name withAd: ad];
//    if(self.blockCallbackWhenAdClicked != nil)
//        self.blockCallbackWhenAdClicked(args);
//}
//
//- (void)didDisplayAd:(nonnull MAAd *)ad {
//    MAAdFormat *adFormat = ad.format;
//    if ( ![adFormat isFullscreenAd] ) return;
//    
//    NSString *name;
//
//    if ( MAAdFormat.interstitial == adFormat ){
//        name = @"OnInterstitialAdDisplayEvent";
//        _isInterAdsShowing = true;
//    }
//    else if ( MAAdFormat.rewarded == adFormat ){
//        name = @"OnRewardedAdDisplayEvent";
//        _isRewardAdsShowing = true;
//        
////        if(_isCountingDownBlockInter){
////            _isRewardAdsShowing = true;
////            _videoRewardShowTime = [NSDate date];
////            [self log: @"did ad display _videoRewardShowTime %@", _videoRewardShowTime];
////        }
//    }
//    
//    NSDictionary<NSString *, id> *args = [self defaultAdEventParametersForName: name withAd: ad];
//    if(self.blockCallbackAdDisplayed != nil)
//        self.blockCallbackAdDisplayed(args);
//}
//
//- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {
//    // BMLs do not support [DISPLAY] events in Unity
//    MAAdFormat *adFormat = ad.format;
//    if ( ![adFormat isFullscreenAd] ) return;
//    
//    NSString *name;
//    if ( MAAdFormat.interstitial == adFormat )
//    {
//        name = @"OnInterstitialAdFailedToDisplayEvent";
//        [self loadInterstitialWithAdUnitIdentifier:ad.adUnitIdentifier];
//    }
//    else if ( MAAdFormat.appOpen == adFormat )
//    {
//        name = @"OnAppOpenAdFailedToDisplayEvent";
//    }
//    else if ( MAAdFormat.rewarded == adFormat )
//    {
//        name = @"OnRewardedAdFailedToDisplayEvent";
//        [self loadRewardedAdWithAdUnitIdentifier:ad.adUnitIdentifier];
//    }
//    else // rewarded inters
//    {
//        name = @"OnRewardedInterstitialAdFailedToDisplayEvent";
//    }
//}
//
//- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
//    if ( !adUnitIdentifier )
//    {
//        [self log: @"adUnitIdentifier cannot be nil from %@", [NSThread callStackSymbols]];
//        return;
//    }
//    
//    NSString *name;
//    if ( self.adViews[adUnitIdentifier] )
//    {
//        MAAdFormat *adFormat = self.adViewAdFormats[adUnitIdentifier];
//        if ( MAAdFormat.mrec == adFormat )
//        {
//            name = @"OnMRecAdLoadFailedEvent";
//        }
//        else if ( MAAdFormat.crossPromo == adFormat )
//        {
//            name = @"OnCrossPromoAdLoadFailedEvent";
//        }
//        else
//        {
//            name = @"OnBannerAdLoadFailedEvent";
//        }
//    }
//    else if ( self.interstitials[adUnitIdentifier] )
//    {
//        name = @"OnInterstitialLoadFailedEvent";
//        
//        // Interstitial ad failed to load
//        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
//            
//        self.retryAttemptInter++;
//        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptInter));
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self loadInterstitialWithAdUnitIdentifier:adUnitIdentifier];
//        });
//    }
//    else if ( self.rewardedAds[adUnitIdentifier] )
//    {
//        name = @"OnRewardedAdLoadFailedEvent";
//        // Rewarded ad failed to load
//        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
//        
//        self.retryAttemptRewarded++;
//        NSInteger delaySec = pow(2, MIN(6, self.retryAttemptRewarded));
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self loadRewardedAdWithAdUnitIdentifier:adUnitIdentifier];
//        });
//    }
//    
//    @synchronized ( self.adInfoDictLock )
//    {
//        [self.adInfoDict removeObjectForKey: adUnitIdentifier];
//    }
//}
//
//- (void)didHideAd:(nonnull MAAd *)ad {
//    // BMLs do not support [HIDDEN] events in Unity
//    MAAdFormat *adFormat = ad.format;
//    if ( ![adFormat isFullscreenAd] ) return;
//    
//    UnityPause(0);
//    
////    NSString *name;
//    if ( MAAdFormat.interstitial == adFormat )
//    {
//        _isInterAdsShowing = false;
////        name = @"OnInterstitialHiddenEvent";
//        [self loadInterstitialWithAdUnitIdentifier:ad.adUnitIdentifier];
//        
//        [self log:@"didHideAd: Inter"];
//        
//        if(self.codeRequestInter != RESUME_INTER_KEY){
//            
//            [self startCountDownDelayInter];
//
//            self.blockCallbackInterAdClosed(@{@"requestCode" : [@(self.codeRequestInter) stringValue]});
//        }else{
//
//        }
//
//    }
//    else if ( MAAdFormat.appOpen == adFormat )
//    {
////        name = @"OnAppOpenAdHiddenEvent";
//    }
//    else if ( MAAdFormat.rewarded == adFormat )
//    {
//        [self log:@"didHide reward ad"];
////        name = @"OnRewardedAdHiddenEvent";
//        [self loadRewardedAdWithAdUnitIdentifier:ad.adUnitIdentifier];
//        
//        _isRewardAdsShowing = false;
//        
//        if(!_isCountingDownDelayInterAds){
//            NSInteger delaySec = _extraDelayInterAdsInSecond;
//                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                                        _isCountingDownDelayInterAds = false;
//                        
//                                        [self log:@" finish extra block inter time"];
//                                    });
//        }
//    }
//    else // rewarded inters
//    {
////        name = @"OnRewardedInterstitialAdHiddenEvent";
//    }
//}
//
//- (void)startCountDownDelayInter{
//    _runtimeDelayInterAdsInSecond = _delayShowInter;
//    _isCountingDownDelayInterAds = true;
//    
//    [self stopCountDownDelayInter];
//    
//    _interDelayTimer = [NSTimer scheduledTimerWithTimeInterval: INTERNAL_TIME
//                          target: self
//                        selector:@selector(onTick)
//                          userInfo: nil repeats:YES];
//}
//
//-(void)onTick{
//    if(_isRewardAdsShowing){
//        [self log:@"reward ads is showing, skip this tick"];
//        return;
//    }
//    
//    if(_isInterAdsShowing){
//        [self log:@"inter ads is showing, skip this tick"];
//        return;
//    }
//    
//    _runtimeDelayInterAdsInSecond -= INTERNAL_TIME;
//    [self log:@"onTick current delaytime: %f",_runtimeDelayInterAdsInSecond];
//    
//    if(_runtimeDelayInterAdsInSecond <= 0){
//        _isCountingDownDelayInterAds = false;
//        [self stopCountDownDelayInter];
//    }
//}
//
//-(void)stopCountDownDelayInter{
//    [self log:@"stop countdown"];
//    if(_interDelayTimer) {
//        [_interDelayTimer invalidate];
//        _interDelayTimer = nil;
//    }
//}
//
//- (void)didLoadAd:(nonnull MAAd *)ad {
//    NSString *name;
//    MAAdFormat *adFormat = ad.format;
//    if ( [adFormat isAdViewAd] )
//    {
//        MAAdView *adView = [self retrieveAdViewForAdUnitIdentifier: ad.adUnitIdentifier adFormat: adFormat];
//        // An ad is now being shown, enable user interaction.
//        adView.userInteractionEnabled = YES;
//        
//        if ( MAAdFormat.mrec == adFormat )
//        {
//            name = @"OnMRecAdLoadedEvent";
//        }
//        else if ( MAAdFormat.crossPromo == adFormat )
//        {
//            name = @"OnCrossPromoAdLoadedEvent";
//        }
//        else
//        {
//            name = @"OnBannerAdLoadedEvent";
//        }
//        [self positionAdViewForAd: ad];
//        [self log:@"didLoadAd %@",name];
//        
//        // Do not auto-refresh by default if the ad view is not showing yet (e.g. first load during app launch and publisher does not automatically show banner upon load success)
//        // We will resume auto-refresh in -[MAUnityAdManager showBannerWithAdUnitIdentifier:].
//        if ( adView && [adView isHidden] )
//        {
//            [adView stopAutoRefresh];
//        }
//    }
//    else if ( MAAdFormat.interstitial == adFormat )
//    {
//        name = @"OnInterstitialLoadedEvent";
//        self.retryAttemptInter = 0;
//    }
//    else if ( MAAdFormat.appOpen == adFormat )
//    {
//        name = @"OnAppOpenAdLoadedEvent";
//    }
//    else if ( MAAdFormat.rewarded == adFormat )
//    {
//        name = @"OnRewardedAdLoadedEvent";
//        self.retryAttemptRewarded = 0;
//    }
//    else if ( MAAdFormat.rewardedInterstitial == adFormat )
//    {
//        name = @"OnRewardedInterstitialAdLoadedEvent";
//    }
//    else
//    {
//        [self logInvalidAdFormat: adFormat];
//        return;
//    }
//    
//    @synchronized ( self.adInfoDictLock )
//    {
//        self.adInfoDict[ad.adUnitIdentifier] = ad;
//    }
//    
//    NSDictionary<NSString *, id> *args = [self defaultAdEventParametersForName: name withAd: ad];
//    
//    if(self.blockCallbackAdReady != nil)
//        self.blockCallbackAdReady(args);
//
//}
//
//- (void)didCollapseAd:(nonnull MAAd *)ad {
// 
//}
//
//- (void)didExpandAd:(nonnull MAAd *)ad {
//
//}
//
//- (void)didPayRevenueForAd:(nonnull MAAd *)ad {
//    NSString *name;
//    MAAdFormat *adFormat = ad.format;
//    if ( MAAdFormat.banner == adFormat || MAAdFormat.leader == adFormat )
//    {
//        name = @"OnBannerAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.mrec == adFormat )
//    {
//        name = @"OnMRecAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.crossPromo == adFormat )
//    {
//        name = @"OnCrossPromoAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.interstitial == adFormat )
//    {
//        name = @"OnInterstitialAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.appOpen == adFormat )
//    {
//        name = @"OnAppOpenAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.rewarded == adFormat )
//    {
//        name = @"OnRewardedAdRevenuePaidEvent";
//    }
//    else if ( MAAdFormat.rewardedInterstitial == adFormat )
//    {
//        name = @"OnRewardedInterstitialAdRevenuePaidEvent";
//    }
//    else
//    {
//        [self logInvalidAdFormat: adFormat];
//        return;
//    }
//    
//    NSDictionary<NSString *, id> *args = [self defaultAdEventParametersForName: name withAd: ad];
//    //Log revenue
//    if(self.blockCallbackAdRevenue != nil) {
//        self.blockCallbackAdRevenue(args);
//    }
//}
//
//- (void)didRewardUserForAd:(nonnull MAAd *)ad withReward:(nonnull MAReward *)reward {
//    MAAdFormat *adFormat = ad.format;
//    if ( ![adFormat isFullscreenAd] ) return;
//    
//    NSString *name;
//
//    if ( MAAdFormat.rewarded == adFormat ){
//        name = @"OnRewardedAdRewardedUserEvent";
//        
//        NSMutableDictionary<NSString *, id> *args = [self defaultAdEventParametersForName: name withAd: ad];
//        args[@"requestCode"] = [@(self.codeRequestRewarded) stringValue];
//        
//        if(self.blockCallbackAdRewarded != nil)
//            self.blockCallbackAdRewarded(args);
//    }
//}
//
//- (NSMutableDictionary<NSString *, id> *)defaultAdEventParametersForName:(NSString *)name withAd:(MAAd *)ad
//{
//    NSMutableDictionary<NSString *, id> *args = [[self adInfoForAd: ad] mutableCopy];
//    args[@"name"] = name;
//    
//    return args;
//}
//
//- (NSDictionary<NSString *, id> *)adInfoForAd:(MAAd *)ad
//{
//    return @{@"adUnitId" : ad.adUnitIdentifier,
//             @"adFormat" : ad.format.label,
//             @"networkName" : ad.networkName,
//             @"networkPlacement" : ad.networkPlacement,
//             @"creativeId" : ad.creativeIdentifier ?: @"",
//             @"placement" : ad.placement ?: @"",
//             @"revenue" : [@(ad.revenue) stringValue],
//             @"revenuePrecision" : ad.revenuePrecision,
//             @"waterfallInfo" : [self createAdWaterfallInfo: ad.waterfall],
//             @"dspName" : ad.DSPName ?: @""};
//}
//
//- (NSDictionary<NSString *, id> *)createAdWaterfallInfo:(MAAdWaterfallInfo *)waterfallInfo
//{
//    NSMutableDictionary<NSString *, NSObject *> *waterfallInfoDict = [NSMutableDictionary dictionary];
//    if ( !waterfallInfo ) return waterfallInfoDict;
//    
//    waterfallInfoDict[@"name"] = waterfallInfo.name;
//    waterfallInfoDict[@"testName"] = waterfallInfo.testName;
//    
//    NSMutableArray<NSDictionary<NSString *, NSObject *> *> *networkResponsesArray = [NSMutableArray arrayWithCapacity: waterfallInfo.networkResponses.count];
//    for ( MANetworkResponseInfo *response in  waterfallInfo.networkResponses )
//    {
//        [networkResponsesArray addObject: [self createNetworkResponseInfo: response]];
//    }
//    waterfallInfoDict[@"networkResponses"] = networkResponsesArray;
//    
//    // Convert latency from seconds to milliseconds to match Android.
//    long latencyMillis = waterfallInfo.latency * 1000;
//    waterfallInfoDict[@"latencyMillis"] = @(latencyMillis).stringValue;
//    
//    return waterfallInfoDict;
//}
//
//- (NSDictionary<NSString *, id> *)createNetworkResponseInfo:(MANetworkResponseInfo *)response
//{
//    NSMutableDictionary<NSString *, NSObject *> *networkResponseDict = [NSMutableDictionary dictionary];
//    
//    networkResponseDict[@"adLoadState"] = @(response.adLoadState).stringValue;
//    
//    MAMediatedNetworkInfo *mediatedNetworkInfo = response.mediatedNetwork;
//    if ( mediatedNetworkInfo )
//    {
//        NSMutableDictionary <NSString *, NSObject *> *networkInfoObject = [NSMutableDictionary dictionary];
//        networkInfoObject[@"name"] = response.mediatedNetwork.name;
//        networkInfoObject[@"adapterClassName"] = response.mediatedNetwork.adapterClassName;
//        networkInfoObject[@"adapterVersion"] = response.mediatedNetwork.adapterVersion;
//        networkInfoObject[@"sdkVersion"] = response.mediatedNetwork.sdkVersion;
//        
//        networkResponseDict[@"mediatedNetwork"] = networkInfoObject;
//    }
//    
//    networkResponseDict[@"credentials"] = response.credentials;
//    networkResponseDict[@"isBidding"] = @([response isBidding]);
//    
//    MAError *error = response.error;
//    if ( error )
//    {
//        NSMutableDictionary<NSString *, NSObject *> *errorObject = [NSMutableDictionary dictionary];
//        errorObject[@"errorMessage"] = error.message;
//        errorObject[@"adLoadFailure"] = error.adLoadFailureInfo;
//        errorObject[@"errorCode"] = @(error.code).stringValue;
//        
//        networkResponseDict[@"error"] = errorObject;
//    }
//    
//    // Convert latency from seconds to milliseconds to match Android.
//    long latencySeconds = response.latency * 1000;
//    networkResponseDict[@"latencyMillis"] = @(latencySeconds).stringValue;
//    
//    return networkResponseDict;
//}
//
//
//- (void)showBanner {
//    if(!_isPluginInitialized) return;
//    [self showBannerWithAdUnitIdentifier:self.bannerUnitId];
//}
//
//- (void)hideBanner {
//    if(!_isPluginInitialized) return;
//    [self hideBannerWithAdUnitIdentifier:self.bannerUnitId];
//}
//
//- (void)hideMrec {
//    if(!_isPluginInitialized) return;
//    [self hideMRecWithAdUnitIdentifier:self.mrecUnitId];
//}
//
//- (void)showMrec {
//    if(!_isPluginInitialized) return;
//    [self showMRecWithAdUnitIdentifier:self.mrecUnitId];
//}
//
//- (BOOL)isInterReady {
//    if(!_isPluginInitialized) return FALSE;
//    if(_isCountingDownDelayInterAds) return FALSE;
//    return [self isInterstitialReadyWithAdUnitIdentifier:self.interUnitId];
//}
//
//- (void)showInter:(int) code {
//    if(!_isPluginInitialized) 
//    {
//        [self log:@"Block Show Inter 0"];
//        return;
//    }
//    if(_isDisableInterAds) {
//        [self log:@"Block Show Inter 1"];
//        return;
//    }
//    if(_isInterAdsShowing) {
//        [self log:@"Block Show Inter 2"];
//        return;
//    }
//    if(![self isInterReady]) {
//        [self log:@"Block Show Inter 3"];
//        return;
//    }
//    if(_isCountingDownDelayInterAds) {
//        [self log:@"Block Show Inter 4"];
//        return;
//    }
//    [self log:@"Show Inter with code %d", code];
//    self.codeRequestInter = code;
//    [self showInterstitialWithAdUnitIdentifier:self.interUnitId placement:nil customData:nil];
//}
//
//-(void) showResumeAds{
//    if(!_isPluginInitialized) return;
//    
//    if(_isDisableInterAds) {
//        [self log:@"Block Show Resume Inter 0"];
//        return;
//    }
//    
//    if(_isDisableResumeAds) {
//        [self log:@"Block Show Resume Inter zz"];
//        return;
//    }
//    
//    if(!_isShowResumeAdsRemoteValue) {
//        [self log:@"Block Show Resume Inter 1"];
//        return;
//    }
//    
//    if(_isInterAdsShowing) {
//        [self log:@"Block Show Resume Inter 2"];
//        return;
//    }
//    
//    if(_isAdClicked){
//        _isAdClicked = false;
//        [self log:@"Block Show Resume Inter 3"];
//        return;
//    }
//    
//    if(_blockAutoShowInterCount > 0){
//        [self decreaseBlockAutoShowInterCount];
//        [self log:@"Block Show Resume Inter 4"];
//        return;
//    }
//    
//    if([self isInterstitialReadyWithAdUnitIdentifier:self.interUnitId]){
//        self.codeRequestInter = RESUME_INTER_KEY;
//        [self showInterstitialWithAdUnitIdentifier:self.interUnitId placement:nil customData:nil];
//    }
//}
//
//- (void)showReward:(int)code {
//    if(!_isPluginInitialized) return;
//    if(![self isRewardReady]) return;
//    [self log:@"Show Reward with code %d", code];
//    
//    self.codeRequestRewarded = code;
//    [self showRewardedAdWithAdUnitIdentifier:self.rewardUnitId placement:nil customData:nil];
//    
//}
//
//- (BOOL)isRewardReady {
//    if(!_isPluginInitialized) return FALSE;
//    return [self isRewardedAdReadyWithAdUnitIdentifier:self.rewardUnitId];
//}
//
//- (void)setConfigValues:(int)delayShowInter isShowResume:(BOOL)isShowResume {
//    [self log:@"Delay show inter %d", delayShowInter];
//    [self log:@"Is show Resume Ads %d", isShowResume];
//    
//    _delayShowInter = delayShowInter;
//    _isShowResumeAdsRemoteValue = isShowResume;
//}
//
//-(void) increaseBlockAutoShowInterCount{
//    _blockAutoShowInterCount += 1;
//}
//
//-(void) decreaseBlockAutoShowInterCount{
//    _blockAutoShowInterCount -= 1;
//}
//
//-(void) onReadyToShowAutoInter{
////    _isInterAdsShowing = false;
//}
//
//-(void) enableInterAds{
//    _isDisableInterAds = false;
//}
//
//-(void) disableInterAds{
//    _isDisableInterAds = true;
//}
//
//-(void) enableResumeAds{
//    _isDisableResumeAds = false;
//}
//
//-(void) disableResumeAds{
//    _isDisableResumeAds = true;
//}
//
//@end
