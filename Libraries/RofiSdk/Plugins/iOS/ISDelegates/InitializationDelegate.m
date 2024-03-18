//
//  InitializationDelegate.m
//  IronSourceDemoApp
//
//  Copyright © 2024 ironSource Mobile Ltd. All rights reserved.
//

#import "InitializationDelegate.h"

@implementation InitializationDelegate

- (instancetype)initWithDelegate:(id<IronSourceAdsDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
    }
    
    return self;
}

/**
 Called after the Mediation successfully completes its initialization
 */
- (void)initializationDidComplete {
    [self.delegate initializationDidComplete];
}

@end
