//
//  AppOpenAdManager.h
//  UnityFramework
//
//  Created by Admin on 06/11/2023.
//

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

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>

@protocol AppOpenAdManagerDelegate <NSObject>
/// Method to be invoked when an app open ad life cycle is complete (i.e. dismissed or fails to
/// show).
- (void) adDidComplete;
- (void) adRevenue:(NSString * _Nonnull)adSourceName
          adFormat:(NSString * _Nonnull)adFormat
          adUnitId:(NSString * _Nonnull)adUnitId
           adValue:(float) adValue;
- (void) onAdShow;

@end

@interface AdmodAdsManager : NSObject <GADFullScreenContentDelegate,GADBannerViewDelegate>

@property (nonatomic, weak) id <AppOpenAdManagerDelegate> _Nullable delegate;

+ (nonnull AdmodAdsManager *)sharedInstance;

- (void)customInit;

- (void)loadOpenAds;
- (void)showOpenAdsIfAvailable;
- (BOOL)isOpenAdsAvailable;

- (void)createBanner:(GADAdSize) size;
- (void)showBanner;
- (void)hideBanner;

@end
