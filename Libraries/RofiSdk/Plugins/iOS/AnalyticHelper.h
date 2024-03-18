//
//  AnalyticHelper.h
//  UnityFramework
//
//  Created by Admin on 02/08/2023.
//

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AppsFlyerAdRevenue/AppsFlyerAdRevenue.h>

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalyticHelper : NSObject{
    BOOL _isInit;
}
- (void) start;

- (void) logEvent: (NSString* _Nonnull) eventName parameters:(nullable NSDictionary<NSString *, id> *)parameters;
- (void) logRevenue : (NSDictionary<NSString *, id> *) adData;

- (void) logRevenueAdmodAds : (NSString * _Nonnull) adSourceName adFormat:(NSString*)format adUnitId:(NSString * _Nonnull) adUnitId adValue:(float) adValue;

+(AnalyticHelper *_Nonnull) sharedObject;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
