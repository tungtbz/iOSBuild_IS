#import "rofisdk.h"
#import "DevicesFeatures.h"

// Converts NSString to C style string by way of copy (Mono will free it)
#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL

// Converts C style string to NSString
#define GetStringParam( _x_ ) ( _x_ != NULL ) ? [NSString stringWithUTF8String:_x_] : [NSString stringWithUTF8String:""]

#ifdef __cplusplus
extern "C" {
#endif
    void UnityPause(int pause);
    extern void UnitySendMessage( const char *className, const char *methodName, const char *param );
    
#ifdef __cplusplus
}
#endif

@interface rofisdk()
@property (nonatomic, assign) NSInteger totalInterAdsHasShown;
@end

@implementation rofisdk
char *const SDK_OBJECT_NAME = "RofiSdkHelper";

+ (rofisdk *) sharedObject {
    static rofisdk *sharedClass = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    
    return sharedClass;
}

- (instancetype)init{
    if(self = [super init]){
        consentCode = -1;
    }
    return self;
}

- (void) warmUp{
    
    if(_isWarmUped) return;
    isAATFlowFinished = false;
    
    __weak __typeof__(self) weakSelf = self;
    
    
    [[DevicesFeatures sharedObject] requestATT:^(BOOL granted) {
        NSLog(@"XXX AAT Finish");
        __strong __typeof__(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
          return;
        }
        [[DevicesFeatures sharedObject] requestNotification:^(BOOL granted) {
            isAATFlowFinished =  true;
        }];
    }];
    
    [self loadLocalCache];
    
    [self initFirebaseService];
    
    delayStartTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(onTick)
                                                       userInfo: nil repeats:YES];

    _isWarmUped = YES;
}

-(void) startTick{

}

-(void)onTick{
    if(!isAATFlowFinished) return;
    NSLog(@"XXX onTick");
    
    currentTick += 1;
    if(!isRunConsentFlow && currentTick >= 3){
        [self runConsentFlow];
    }
    
    if(!isRunConsentFlow && [[DevicesFeatures sharedObject] internetStatus] != 0){
        [self runConsentFlow];
    }
}

-(void)stopTimeTick{
    if(delayStartTimer) {
        [delayStartTimer invalidate];
        delayStartTimer = nil;
    }
}

- (void) runConsentFlow{
    isRunConsentFlow = true;
    
    if(![[DevicesFeatures sharedObject] isOnline]){
        [GoogleMobileAdsConsentManager.sharedInstance byPassConsentForm];
        NSLog(@"XXX runConsentFlow 1");
        [self InitAdsService];
    }else{
        __weak __typeof__(self) weakSelf = self;
        [GoogleMobileAdsConsentManager.sharedInstance gatherConsentFromConsentPresentationViewController:^(NSError * _Nullable error) {
            __strong __typeof__(self) strongSelf = weakSelf;
            
            if (!strongSelf) {
              return;
            }
            
            if(error){
                consentCode = 0;
            }else{
                consentCode = 1;
            }
            
            NSLog(@"XXX runConsentFlow 2");
            [strongSelf InitAdsService];
            
            if (GoogleMobileAdsConsentManager.sharedInstance.canRequestAds) {
                                                [strongSelf startGoogleMobileAdsSDK];
                                              }
        }];
    }
    
    // This sample attempts to load ads using consent obtained in the previous session.
      if (GoogleMobileAdsConsentManager.sharedInstance.canRequestAds) {
        [self startGoogleMobileAdsSDK];
      }
    
    [self stopTimeTick];
}

- (void)startGoogleMobileAdsSDK {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    //if use admob MREC
    [AdmodAdsManager.sharedInstance createBanner:GADAdSizeMediumRectangle];

    [AdmodAdsManager.sharedInstance customInit];
  });
}

-(void) setupSdk{
}

#pragma mark - AppOpenAdManagerDelegate

- (void)adDidComplete {
    NSLog(@"Open Ad adDidComplete");
    [[IronsourceAdsHelper sharedObject] enableResumeAds];
}

- (void)onAdShow{
    NSLog(@"Open Ad onAdShow");
    [[IronsourceAdsHelper sharedObject] disableResumeAds];
}

- (void)adRevenue:(NSString * _Nonnull)adSourceName adFormat:(NSString * _Nonnull)adFormat adUnitId:(NSString * _Nonnull)adUnitId adValue:(float)adValue { 
    [[AnalyticHelper sharedObject] logRevenueAdmodAds:adSourceName adFormat:adFormat adUnitId:adUnitId adValue:adValue];
}

-(void) loadLocalCache{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.totalInterAdsHasShown = (int) [prefs integerForKey:@"totalInter"];
}

-(void) initFirebaseService{
    [AnalyticHelper sharedObject];
    
    [[FirebaseRemoteConfigHelper sharedObject] setFinishInitCallback:^{
        //refresh
        int delayShowInter = [[FirebaseRemoteConfigHelper sharedObject] getIntValue:@"ads_interval"];
        BOOL isShowResumeAds = [[FirebaseRemoteConfigHelper sharedObject] getBoolValue:@"resume_ads"];
        [[IronsourceAdsHelper sharedObject] setConfigValues:delayShowInter isShowResume:isShowResumeAds];
    }];
}

-(BOOL)IsConsentFlowDone{
    return isAATFlowFinished;
}

-(int)consentCode{
    return consentCode;
}

-(void) InitAdsService
{
    NSLog(@"XXX InitAdsService ====");
    AdmodAdsManager.sharedInstance.delegate = self;

    //set init callback
    [[IronsourceAdsHelper sharedObject] SetSDKInitCallback:^{
        //init analytic after
        NSLog(@"XXX Finish Max Term N Privacy Flow ====");
        [[AnalyticHelper sharedObject] start];
    }];
    
    [[IronsourceAdsHelper sharedObject] disableInterAds];
    
    [[IronsourceAdsHelper sharedObject] setAdClickCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            //ad clicked
        }
    }];
    
    [[IronsourceAdsHelper sharedObject] setAdDisplayCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            //ad displayed

            if ( [@"INTER" isEqualToString: adData[@"adFormat"]] ){
                NSLog(@"Log event inter Ad Displayed");
                [[AnalyticHelper sharedObject] logEvent:@"af_inters_displayed" parameters:nil];
                
                //count show inter
                self.totalInterAdsHasShown += 1;
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setInteger:self.totalInterAdsHasShown forKey:@"totalInter"];
                
                if(self.totalInterAdsHasShown >= 1 && self.totalInterAdsHasShown <= 20){
                    NSString* eventName = [NSString stringWithFormat:@"af_inters_displayed_%d_times",(int) self.totalInterAdsHasShown];
                    NSLog(@"eventName: %@", eventName);
                    [[AnalyticHelper sharedObject] logEvent:eventName parameters:nil];
                }
                
                UnitySendMessage(SDK_OBJECT_NAME, "OnInterAdsDisplay",MakeStringCopy(@""));
                
                
            }else if( [@"REWARDED" isEqualToString: adData[@"adFormat"]] ){
                NSLog(@"Log event reward Ad Displayed");
                [[AnalyticHelper sharedObject] logEvent:@"af_rewarded_ad_displayed" parameters:nil];
            }
        }
    }];
    
    [[IronsourceAdsHelper sharedObject] setAdReadyCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            //ad ready to show
            if ( [@"INTER" isEqualToString: adData[@"adFormat"]] ){
                NSLog(@"Log event inter Ad Loaded");
                [[AnalyticHelper sharedObject] logEvent:@"af_inters_api_called" parameters:nil];
            }else if( [@"REWARDED" isEqualToString: adData[@"adFormat"]] ){
                NSLog(@"Log event reward ad Loaded");
                [[AnalyticHelper sharedObject] logEvent:@"af_rewarded_api_called" parameters:nil];
            }
        }
    }];
    
    [[IronsourceAdsHelper sharedObject] setAdRevenueCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            [[AnalyticHelper sharedObject] logRevenue:adData];
        }
    }];
    
    [[IronsourceAdsHelper sharedObject] setAdRewardedCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            NSString * requestCode = adData[@"requestCode"];
            UnitySendMessage(SDK_OBJECT_NAME, "OnVideoRewardedWithCode", MakeStringCopy(requestCode));
        }
    }];
    
    [[IronsourceAdsHelper sharedObject] setInterAdClosedCallback:^(NSDictionary<NSString *,id> * _Nullable adData) {
        if(adData != nil){
            NSLog(@"On Inter Ad Closed");
            NSString * requestCode = adData[@"requestCode"];
            UnitySendMessage(SDK_OBJECT_NAME, "OnShowInterAds", MakeStringCopy(requestCode));
        }
    }];
    
    //set default value
    int delayShowInter = [[FirebaseRemoteConfigHelper sharedObject] getIntValue:@"ads_interval"];
    BOOL isShowResumeAds = [[FirebaseRemoteConfigHelper sharedObject] getBoolValue:@"resume_ads"];
    
    [[IronsourceAdsHelper sharedObject] setConfigValues:delayShowInter isShowResume:isShowResumeAds];
    
    [[IronsourceAdsHelper sharedObject] initSDK];
    
}

- (NSString *)getJsonFromObj:(id)obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end

#ifdef __cplusplus
extern "C" {
#endif
    void _WarmUp(){
    //not used
    }
    
    void _OnReadyToShowAutoInterAds(){
//        [[IronsourceAdsHelper sharedObject] onReadyToShowAutoInter];
    }
    
    bool _IsRewardAvailable(){
        return [[IronsourceAdsHelper sharedObject] isRewardReady];;
    }
    
    void _ShowReward(int code){
        [[IronsourceAdsHelper sharedObject] showReward:code];
    }
    
    bool _IsInterAdsAvailable(){
        return [[IronsourceAdsHelper sharedObject] isInterReady];;
    }
    
    void _ShowInterAds(int code){
        [[IronsourceAdsHelper sharedObject] showInter: code];
    }
    
    void _ShowBanner(){
        [[IronsourceAdsHelper sharedObject] showBanner];
    }
     
    void _HideBanner(){
        [[IronsourceAdsHelper sharedObject] hideBanner];
    }
         
    void _HideMrec(){
//        [[IronsourceAdsHelper sharedObject] hideMrec];
        [[AdmodAdsManager sharedInstance] hideBanner];
    }

    void _ShowMrec(){
//        [[IronsourceAdsHelper sharedObject] showMrec];
        [[AdmodAdsManager sharedInstance] showBanner];
    }
    
    void _ShowNativeRect(){
//        [[IronsourceAdsHelper sharedObject] showNativeMrec];
    }
    
    void _HideNativeRect(){
//        [[IronsourceAdsHelper sharedObject] hideNativeMrec];
    }
    
    void _ShowNativeBanner(){
//        [[IronsourceAdsHelper sharedObject] showNativeBanner];
    }
    
    void _HideNativeBanner(){
//        [[IronsourceAdsHelper sharedObject] hideNativeBanner];
    }
    
    void _HideAllBanner(){
        _HideBanner();
    }
    
    void _HideAllRectADS(){
        _HideMrec();
    }
    
    void _LoadAppOpenAds(){
        [[AdmodAdsManager sharedInstance] loadOpenAds];
//        [[ApplovinAdsHelper sharedObject] loadAppOpenAds];
    }
    void _ShowAppOpenAds(){
        [[AdmodAdsManager sharedInstance] showOpenAdsIfAvailable];
//        [[ApplovinAdsHelper sharedObject] showAppOpenAds];
        
    }
    bool _IsAppOpenAdsReady(){
        return [[AdmodAdsManager sharedInstance] isOpenAdsAvailable];
//        return [[ApplovinAdsHelper sharedObject] isAppOpenAdsReady];
    }

    char* _GetAdsId(){
        if([[AppsFlyerLib shared] advertisingIdentifier])
            return MakeStringCopy([[AppsFlyerLib shared] advertisingIdentifier]);
        return MakeStringCopy(@"");
    }
    
    //remote config apis
    bool _GetBoolValue(char* key){
        return [[FirebaseRemoteConfigHelper sharedObject] getBoolValue:GetStringParam(key)];
    }
   
    int _GetIntValue(char* key){
        return [[FirebaseRemoteConfigHelper sharedObject] getIntValue:GetStringParam(key)];
    }
     
    char* _GetStringValue(char* key){
        NSString* rtn = [[FirebaseRemoteConfigHelper sharedObject] getStringValue:GetStringParam(key)];
        return MakeStringCopy(rtn);
    }
    
    //device features
    void _Flash(){
        [[DevicesFeatures sharedObject] TurnTorchOn];
    }

    void _Vibrate(){
        [[DevicesFeatures sharedObject] Vibrate];
    }
	
    void _ShowRate(){
        if (@available(iOS 13.0, *)) {
            [[DevicesFeatures sharedObject] OpenRateIos13:[UIApplication sharedApplication].keyWindow.windowScene];
        } else {
            // Fallback on earlier versions
            [[DevicesFeatures sharedObject] OpenRate];
        }
    }

    bool _IsOnline(){
        return [[DevicesFeatures sharedObject] isOnline];
    }

    bool _IsCameraPermissionGranted(){
        return [[DevicesFeatures sharedObject] isCameraPermissionGranted];
    }
    
    void _ShowAppSetting(){
        [[IronsourceAdsHelper sharedObject] increaseBlockAutoShowInterCount];
        
        [[DevicesFeatures sharedObject] openSetting];
    }
    
    void _RequestCameraPermission(){
        [[IronsourceAdsHelper sharedObject] increaseBlockAutoShowInterCount];
        
        [[DevicesFeatures sharedObject] requestCameraPermission:^(BOOL granted) {
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
    
    void _LogEvent(char* eventName,char* eventData){
        NSError*error;
        
        NSData *data = [GetStringParam(eventData) dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) {
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!dict) {
            return;
        }
        
        [[AnalyticHelper sharedObject] logEvent:GetStringParam(eventName) parameters:dict];
    }
    
    void _EnableInterAds(){
//        [[ApplovinAdsHelper sharedObject] enableInterAds];
        [[IronsourceAdsHelper sharedObject] enableInterAds];
    }
    
    void _DisableInterAds(){
//        [[ApplovinAdsHelper sharedObject] disableInterAds];
        [[IronsourceAdsHelper sharedObject] disableInterAds];
    }
    
    bool _IsConsentFlowDone(){
        return [[rofisdk sharedObject] IsConsentFlowDone] && 
        [[GoogleMobileAdsConsentManager sharedInstance ] isFlowFinished];
    }
    
    bool _AdMobCanRequestAds(){
        //case ko bat UMP
        if([[rofisdk sharedObject] consentCode] == 1){
            return true;
        }
        //case co UMP
        return [[GoogleMobileAdsConsentManager sharedInstance ] canRequestAds];
    }
    
#ifdef __cplusplus
}
#endif
