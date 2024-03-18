//
//  FirebaseRemoteConfigHelper.m
//  UnityFramework
//
//  Created by Admin on 03/08/2023.
//
#define REFRESH_INVERVAL 86400

#import "FirebaseRemoteConfigHelper.h"

@interface FirebaseRemoteConfigHelper()
@property (nonatomic, strong) FIRRemoteConfig * remoteConfig;

@property (nonatomic, strong) void (^blockCallbackWhenFinishInit)(void);
@end

@implementation FirebaseRemoteConfigHelper

+ (FirebaseRemoteConfigHelper * _Nonnull)sharedObject {
    static FirebaseRemoteConfigHelper *sharedClass = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    
    return sharedClass;
}

- (instancetype)init{
    self = [super init];
    if ( self ){
        [self warmUp];
    }
    return self;
}

-(void) warmUp{
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] init];
    
    //debug = 0 seconds
    remoteConfigSettings.minimumFetchInterval = REFRESH_INVERVAL;
    
    self.remoteConfig.configSettings = remoteConfigSettings;
    
    //set default value
    [self.remoteConfig setDefaultsFromPlistFileName:@"remote_config_defaults"];
    
    //Fetch values
    [self.remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"Config fetched!");
          [self.remoteConfig activateWithCompletion:^(BOOL changed, NSError * _Nullable error) {
            if (error != nil) {
              NSLog(@"Activate error: %@", error.localizedDescription);
            } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                  //and activate values
                  //test value
                  int ads_interval = [self getIntValue:@"ads_interval"];
                  BOOL resume_ads = [self getBoolValue:@"messagetoselectmessage"];
                  
                  NSLog(@"FirebaseRemoteConfigHelper messagetoselectmessage %d", resume_ads);

                  self.blockCallbackWhenFinishInit();
              });
            }
          }];
        } else {
            NSLog(@"Config not fetched");
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
    
    _isPluginInitialized = true;
}

- (BOOL)getBoolValue:(nonnull NSString *)key {
    if(!_isPluginInitialized) return false;
    return [[self.remoteConfig configValueForKey:key] boolValue];
}

- (float)getFloatValue:(nonnull NSString *)key {
    if(!_isPluginInitialized) return 0.0f;
    return [[[self.remoteConfig configValueForKey:key] numberValue] floatValue];
}

- (int)getIntValue:(nonnull NSString *)key {
    if(!_isPluginInitialized) return 0;
    return [[[self.remoteConfig configValueForKey:key] numberValue] intValue];
}

- (nonnull NSString *)getStringValue:(nonnull NSString *)key {
    if(!_isPluginInitialized) return nil;
    return [[self.remoteConfig configValueForKey:key] stringValue];
}

- (void)setFinishInitCallback:(void (^ _Nullable __strong)(void))callback {
    self.blockCallbackWhenFinishInit = callback;
}

@end
