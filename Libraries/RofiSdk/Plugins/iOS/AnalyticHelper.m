//
//  AnalyticHelper.m
//  UnityFramework
//
//  Created by Admin on 02/08/2023.
//

#import "AnalyticHelper.h"
@interface AnalyticHelper()
//plist data
@property (nonatomic, strong) NSDictionary *plistData;
@property (nonatomic, strong) NSString *mainNetworkName;
@end

@implementation AnalyticHelper

+ (AnalyticHelper * _Nonnull)sharedObject {
    static AnalyticHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    
    return sharedClass;
}

- (instancetype)init{
    self = [super init];
    if ( self ){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        self.plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //init Firebase
        [FIRApp configure];
        
        [self InitAF];
    }
    return self;
}

- (void)InitAF {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    self.plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSString* sdkKey = [self.plistData  objectForKey:@"AFDevKey"];
    NSString* appId = [self.plistData  objectForKey:@"AFAppleId"];
    
    self.mainNetworkName =[self.plistData  objectForKey:@"MainAdsNetwork"];
    
    [[AppsFlyerLib shared] setAppsFlyerDevKey:sdkKey];
    [[AppsFlyerLib shared] setAppleAppID:appId];
    
    //set debug
//     [AppsFlyerLib shared].isDebug = true;
    
    //start ad revenue
    [AppsFlyerAdRevenue start];
    _isInit = true;
}

-(void)start{
    if(_isInit)
        [[AppsFlyerLib shared] start];
}

-(void) logEvent:(NSString *)eventName parameters:(NSDictionary<NSString *,id> *)parameters{
    [FIRAnalytics logEventWithName:eventName parameters:parameters];
    [[AppsFlyerLib shared] logEvent:eventName withValues:parameters];
}

-(void) logRevenue:(NSDictionary<NSString *,id> *)adData{
    
//    NSString * adPlatform = @"Applovin";
    NSString * networkName = adData[@"networkName"];
    NSString * revenueValue = adData[@"revenue"];
    NSString * adUnitId = adData[@"adUnitId"];
    NSString * adFormat = adData[@"adFormat"];
    NSString * currency = @"USD";
    
    if(networkName != nil)
        NSLog(@"logRevenueAdmodOpenAds %@" ,networkName);
    if(networkName != nil)
        NSLog(@"logRevenueAdmodOpenAds %@" ,adUnitId);
    if(adFormat != nil)
        NSLog(@"logRevenueAdmodOpenAds %@" ,adFormat);
    
    //Firebase X Applovin
    [FIRAnalytics logEventWithName:kFIREventAdImpression
                    parameters: @{
                        kFIRParameterAdPlatform: self.mainNetworkName,
                        kFIRParameterAdSource: networkName,
                        kFIRParameterAdFormat: adFormat,
                        kFIRParameterAdUnitName: adUnitId,
                        kFIRParameterCurrency: currency, // All Applovin revenue is sent in USD
                        kFIRParameterValue: @([revenueValue floatValue])
                    }];
    
    //appflyer
    
    [[AppsFlyerAdRevenue shared] logAdRevenueWithMonetizationNetwork:networkName
                                                    mediationNetwork:[self getAppflyerAdRevenueMediationNetworkType:self.mainNetworkName]
                                                        eventRevenue:@([revenueValue floatValue])
                                                     revenueCurrency:currency
                                                additionalParameters:@{kAppsFlyerAdRevenueAdUnit : adUnitId,
                                                                       kAppsFlyerAdRevenueAdType : adFormat }];
}

-(AppsFlyerAdRevenueMediationNetworkType) getAppflyerAdRevenueMediationNetworkType : (NSString * ) networkName{
    NSLog(@"network name %@",networkName);
    if([networkName isEqual: @"Applovin"] ) return AppsFlyerAdRevenueMediationNetworkTypeApplovinMax;
    else if([networkName isEqual: @"Ironsource"]) return AppsFlyerAdRevenueMediationNetworkTypeIronSource;
    
    return AppsFlyerAdRevenueMediationNetworkTypeDirectMonetization;
}

- (void)logRevenueAdmodAds:(NSString * _Nonnull)adSourceName adFormat:(nonnull NSString *)format adUnitId:(NSString * _Nonnull)adUnitId adValue:(float)adValue{
    NSString* currency = @"USD";
    
    
    [FIRAnalytics logEventWithName:kFIREventAdImpression
                    parameters: @{
                        kFIRParameterAdPlatform:@"ADMOB",
                        kFIRParameterAdSource: adSourceName,
                        kFIRParameterAdFormat: format,
                        kFIRParameterAdUnitName: adUnitId,
                        kFIRParameterCurrency: currency, // All Applovin revenue is sent in USD
                        kFIRParameterValue: @(adValue)
                    }];
    
    NSLog(@"logRevenueAdmodOpenAds %@" ,adSourceName);
    NSLog(@"logRevenueAdmodOpenAds %@" ,adUnitId);
    NSLog(@"logRevenueAdmodOpenAds %f" ,adValue);
    [[AppsFlyerAdRevenue shared] logAdRevenueWithMonetizationNetwork:adSourceName
                                                    mediationNetwork:AppsFlyerAdRevenueMediationNetworkTypeGoogleAdMob
                                                        eventRevenue:@(adValue)
                                                     revenueCurrency:@"USD"
                                                additionalParameters:@{kAppsFlyerAdRevenueAdUnit : adUnitId,
                                                                       kAppsFlyerAdRevenueAdType : format }];
}

@end
