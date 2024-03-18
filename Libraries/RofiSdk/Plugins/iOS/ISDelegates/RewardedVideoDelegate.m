//
//  RewardedVideoDelegate.m
//  IronSourceDemoApp
//
//  Copyright © 2024 ironSource Mobile Ltd. All rights reserved.
//

#import "RewardedVideoDelegate.h"

@implementation RewardedVideoDelegate

- (instancetype)initWithDelegate:(id<IronSourceAdsDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

/**
 Called after a rewarded video has changed its availability to true.
 @param adInfo The info of the ad.
 */
- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {

}

/**
 Called after a rewarded video has changed its availability to false.
 */
- (void)hasNoAvailableAd {

}

/**
 Called after a rewarded video has been opened.
 @param adInfo The info of the ad.
 */
- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self.delegate onAdOpened:0];
}

/**
 Called after a rewarded video has attempted to show but failed.
 @param error The reason for the error.
 @param adInfo The info of the ad.
 */
- (void)didFailToShowWithError:(NSError *)error
                     andAdInfo:(ISAdInfo *)adInfo {

}

/**
 Called after a rewarded video has been clicked.
 This callback is not supported by all networks, and we recommend using it 
 only if it's supported by all networks you included in your build
 @param placementInfo An object that contains the placement's reward name and amount.
 @param adInfo The info of the ad.
 */ 
- (void)didClick:(ISPlacementInfo *)placementInfo
      withAdInfo:(ISAdInfo *)adInfo {
    [self.delegate onAdClicked];
}

/**
 Called after a rewarded video has been viewed completely and the user is eligible for a reward.
 @param placementInfo An object that contains the placement's reward name and amount.
 @param adInfo The info of the ad.
 */
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo
                          withAdInfo:(ISAdInfo *)adInfo {
    [self.delegate onVideoRewarded];
}

/**
 Called after a rewarded video has been dismissed.
 @param adInfo The info of the ad.
 */
- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self.delegate onAdClosed:0];
}

- (void)didFailToLoadWithError:(NSError *)error { 
    [self.delegate onAdLoadFailed:0];
}

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo { 
    [self.delegate onAdLoaded:0];
}

@end
