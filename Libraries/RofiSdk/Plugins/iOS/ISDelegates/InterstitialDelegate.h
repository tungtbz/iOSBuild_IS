//
//  InterstitialDelegate.h
//  IronSourceDemoApp
//
//  Copyright © 2024 ironSource Mobile Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import "IronsourceAdsHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface InterstitialDelegate : NSObject<LevelPlayInterstitialDelegate>

@property (weak, nonatomic) id<IronSourceAdsDelegate> delegate;

- (instancetype)initWithDelegate:(id<IronSourceAdsDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

