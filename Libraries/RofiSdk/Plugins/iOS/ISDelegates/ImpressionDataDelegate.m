//
//  ImpressionDataDelegate.m
//  IronSourceDemoApp
//
//  Copyright © 2024 ironSource Mobile Ltd. All rights reserved.
//

#import "ImpressionDataDelegate.h"

@implementation ImpressionDataDelegate


- (instancetype)initWithDelegate:(id<IronSourceAdsDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

/**
 Called when the ad was displayed successfully and the impression data was recorded
 @param impressionData The recorded impression data 
 */
- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    [self.delegate onAdImpressionRecorded:impressionData];
}

@end
