#import <Foundation/Foundation.h>

//#import "ApplovinAdsHelper.h"
#import "AnalyticHelper.h"
#import "FirebaseRemoteConfigHelper.h"
#import "GoogleMobileAdsConsentManager.h"

//admod aoa
#import "AdmodAdsManager.h"
#import "IronsourceAdsHelper.h"

@interface rofisdk : NSObject<AppOpenAdManagerDelegate>{
    bool isAATFlowFinished;
    bool isRunConsentFlow;
    int consentCode;
    
    int currentTick;
    NSTimer * delayStartTimer;
}

@property (nonatomic) BOOL isWarmUped;

- (void)warmUp;
- (void)InitAdsService;
- (BOOL)IsConsentFlowDone;
- (int)consentCode;

-(NSString *_Nonnull)getJsonFromObj:(id _Nonnull)obj;

+(rofisdk *_Nonnull) sharedObject;

@end
