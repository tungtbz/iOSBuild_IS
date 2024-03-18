//
//  FirebaseRemoteConfigHelper.h
//  UnityFramework
//
//  Created by Admin on 03/08/2023.
//

#import <Foundation/Foundation.h>
#import <FirebaseRemoteConfig/FirebaseRemoteConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirebaseRemoteConfigHelper : NSObject{
    BOOL _isPluginInitialized;
}
- (void) setFinishInitCallback:(void(^_Nullable)(void)) callback;

-(BOOL) getBoolValue : (NSString*) key;
-(float) getFloatValue : (NSString*) key;
-(int) getIntValue : (NSString*) key;
-(NSString*) getStringValue : (NSString*) key;

+(FirebaseRemoteConfigHelper *_Nonnull) sharedObject;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
