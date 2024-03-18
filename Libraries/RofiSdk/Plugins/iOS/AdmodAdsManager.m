//
//  Copyright 2021 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
#define KEY_WINDOW_ADMOB [UIApplication sharedApplication].keyWindow

void admob_unity_dispatch_on_main_thread(dispatch_block_t block)
{
    if ( block )
    {
        if ( [NSThread isMainThread] )
        {
            block();
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

#import "AdmodAdsManager.h"

//#import "GoogleMobileAdsConsentManager.h"

/// Ad references in the app open beta will time out after four hours, but this time limit
/// may change in future beta versions. For details, see:
/// https://support.google.com/admob/answer/9341964?hl=en
static const NSInteger TimeoutInterval = 4;

@interface AdmodAdsManager ()
@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation AdmodAdsManager {
    /// The app open ad.
    GADAppOpenAd *_appOpenAd;
    /// Keeps track of if an app open ad is loading.
    BOOL _isLoadingAd;
    
    BOOL _isLoadingBannerAds;
    BOOL _isBannerAdsLoaded;
    
    /// Keeps track of if an app open ad is showing.
    BOOL _isShowingAd;
    /// Keeps track of the time when an app open ad was loaded to discard expired ad.
    NSDate *_loadTime;
    
    NSString* adUnitId;
    NSString* bannerAdUnitId;
}

+ (nonnull AdmodAdsManager *)sharedInstance {
    static AdmodAdsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AdmodAdsManager alloc] init];
    });
    return instance;
}

-(void)customInit{
    // Initialize the Google Mobile Ads SDK.
    [GADMobileAds.sharedInstance startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
        admob_unity_dispatch_on_main_thread(^{
            // Request an appOpen ads.
            [self loadOpenAds];
            // Request banner
            [self loadBanner];
        });
    }];
}

-(void) createBanner:(GADAdSize) adSize{
    //  Set the ad unit ID and view controller that contains the GADBannerView.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary* infoData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self->bannerAdUnitId = [infoData  objectForKey:@"AdmodBanner"];
    NSLog(@"Admob Banner Id : %@", self->bannerAdUnitId);
    
    UIViewController *rootViewController = [self unityViewController];
    
//    // Here safe area is taken into account, hence the view frame is used after the
//    // view has been laid out.
//    CGRect frame = UIEdgeInsetsInsetRect(rootViewController.view.frame, rootViewController.view.safeAreaInsets);
//    CGFloat viewWidth = frame.size.width;
//
//    // Here the current interface orientation is used. If the ad is being preloaded
//    // for a future orientation change or different orientation, the function for the
//    // relevant orientation should be used.
//    GADAdSize adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    
    
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:adSize];
    
    __weak AdmodAdsManager *weakSelf = self;
    self.bannerView.delegate = self;
    self.bannerView.paidEventHandler = ^(GADAdValue * _Nonnull value) {	
        
        NSDecimalNumber *reveneValue = value.value;
    
        AdmodAdsManager *strongSelf = weakSelf;
        GADAdNetworkResponseInfo *loadedAdNetworkResponseInfo =
        strongSelf->_bannerView.responseInfo.loadedAdNetworkResponseInfo;
        
        NSString *adSourceName = loadedAdNetworkResponseInfo.adSourceName;

        if (!strongSelf->_delegate) {
            return;
        }
        
        [strongSelf->_delegate adRevenue:adSourceName adFormat:@"banner" adUnitId:strongSelf->bannerAdUnitId adValue:[reveneValue floatValue]];
    };
    
    self.bannerView.adUnitID = self->bannerAdUnitId;
    self.bannerView.rootViewController = rootViewController;
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.bannerView setHidden:YES];
    
    //add banner to screen
    [rootViewController.view addSubview: _bannerView];
}

-(void)showBanner{
    if(self.bannerView == nil) return;
    if(self->_isLoadingBannerAds) return;
    
    [self.bannerView setHidden:NO];
}

-(void)hideBanner{
    if(self.bannerView == nil) return;
    if(self->_isLoadingBannerAds) return;
    
    [self.bannerView setHidden:YES];
}

-(void)loadBanner{
    if(self.bannerView == nil) return;
    if(self->_isLoadingBannerAds) return;
    
    self->_isLoadingBannerAds = YES;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"bannerViewDidReceiveAd");

    self->_isLoadingBannerAds = NO;
    UIViewController *rootViewController = [self unityViewController];
    NSLayoutConstraint *centerX = [_bannerView.centerXAnchor constraintEqualToAnchor:rootViewController.view.centerXAnchor];
    NSLayoutConstraint *bottom = [_bannerView.bottomAnchor constraintEqualToAnchor:rootViewController.view.safeAreaLayoutGuide.bottomAnchor];
    
//    NSLayoutConstraint *topAnchor = [_bannerView.topAnchor constraintEqualToAnchor:rootViewController.view.safeAreaLayoutGuide.topAnchor];
    
    NSLayoutConstraint *width = [_bannerView.widthAnchor constraintEqualToConstant:self.bannerView.frame.size.width];
    NSLayoutConstraint *height = [_bannerView.heightAnchor constraintEqualToConstant:self.bannerView.frame.size.height];
    [NSLayoutConstraint activateConstraints:@[centerX, bottom, width, height]];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

-   (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
    NSLog(@"bannerViewDidRecordImpression");
}

-   (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"bannerViewWillPresentScreen");
}

-   (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"bannerViewWillDismissScreen");
}

-   (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"bannerViewDidDismissScreen");
}

- (UIViewController *)unityViewController
{
    return UnityGetGLViewController() ?: UnityGetMainWindow().rootViewController ?: [KEY_WINDOW_ADMOB rootViewController];
}





- (BOOL)wasLoadTimeLessThanNHoursAgo:(int)n {
    // Check if ad was loaded more than n hours ago.
    NSDate *now = [NSDate date];
    NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:_loadTime];
    double secondsPerHour = 3600.0;
    double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
    return intervalInHours < n;
}

- (BOOL)isOpenAdsAvailable {
    // Check if ad exists and can be shown.
    return _appOpenAd && [self wasLoadTimeLessThanNHoursAgo:TimeoutInterval];
}

- (void)adDidComplete {
    // The app open ad is considered to be complete when it dismisses or fails to show,
    // call the delegate's adDidComplete method if the delegate is not nil.
    if (!_delegate) {
        return;
    }
    
    [_delegate adDidComplete];
    _delegate = nil;
}

- (void)adDidShow {
    if (!_delegate) {
        return;
    }
    
    [_delegate onAdShow];
}

- (void)loadOpenAds {
    // Do not load ad if there is an unused ad or one is already loading.
    if ([self isOpenAdsAvailable] || _isLoadingAd) {
        return;
    }
    __weak AdmodAdsManager *weakSelf = self;
    
    _isLoadingAd = YES;
    NSLog(@"Start loading app open ad.");
    //AdmodAOAId
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary* infoData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self->adUnitId = [infoData  objectForKey:@"AdmodAOAId"];
    NSLog(@"App open ad self->adUnitId : %@", self->adUnitId);
    
    [GADAppOpenAd loadWithAdUnitID:self->adUnitId
                           request:[GADRequest request]
                       orientation:UIInterfaceOrientationPortrait
                 completionHandler:^(GADAppOpenAd * _Nullable appOpenAd, NSError * _Nullable error) {
        self->_isLoadingAd = NO;
        if (error) {
            self->_appOpenAd = nil;
            self->_loadTime = nil;
            NSLog(@"App open ad failed to load with error: %@", error);
            return;
        }
        self->_appOpenAd = appOpenAd;
        self->_appOpenAd.fullScreenContentDelegate = self;
        self->_appOpenAd.paidEventHandler = ^void(GADAdValue* _Nonnull value){
            
            NSDecimalNumber *reveneValue = value.value;
            
//            NSString *currencyCode = value.currencyCode;
//            GADAdValuePrecision precision = value.precision;
            
            AdmodAdsManager *strongSelf = weakSelf;
            GADAdNetworkResponseInfo *loadedAdNetworkResponseInfo =
            strongSelf->_appOpenAd.responseInfo.loadedAdNetworkResponseInfo;
            
            NSString *adSourceName = loadedAdNetworkResponseInfo.adSourceName;
//            NSString *adSourceID = loadedAdNetworkResponseInfo.adSourceID;
//            NSString *adSourceInstanceName = loadedAdNetworkResponseInfo.adSourceInstanceName;
            
            if (!strongSelf->_delegate) {
                return;
            }
            
            [strongSelf->_delegate adRevenue:adSourceName adFormat:@"app_open" adUnitId:strongSelf->adUnitId adValue:[reveneValue floatValue]];
        };
        
        self->_loadTime = [NSDate date];
        NSLog(@"App open ad loaded successfully.");
    }];
}

- (void)showOpenAdsIfAvailable{
    
    // If the app open ad is already showing, do not show the ad again.
    if (_isShowingAd) {
        NSLog(@"App open ad is already showing.");
        return;
    }
    // If the app open ad is not available yet but it is supposed to show,
    // it is considered to be complete in this example. Call the adDidComplete method
    // and load a new ad.
    if (![self isOpenAdsAvailable]) {
        NSLog(@"App open ad is not ready yet.");
        [self adDidComplete];
        [self loadOpenAds];
        
        //    if ([GoogleMobileAdsConsentManager.sharedInstance canRequestAds]) {
        //      [self loadAd];
        //    }
        
        return;
    }
    
    NSLog(@"App open ad will be displayed.");
    _isShowingAd = YES;
    UIViewController * viewController = [self unityViewController];
    [_appOpenAd presentFromRootViewController:viewController];
}

#pragma mark - GADFullScreenContentDelegate

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"App open ad is will be presented.");
    [self adDidShow];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    _appOpenAd = nil;
    _isShowingAd = NO;
    NSLog(@"App open ad was dismissed.");
    [self adDidComplete];
    [self loadOpenAds];
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    _appOpenAd = nil;
    _isShowingAd = NO;
    NSLog(@"App open ad failed to present with error: %@", error.localizedDescription);
    [self adDidComplete];
    [self loadOpenAds];
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


@end
