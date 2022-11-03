//
//  RequestOBJ.m
//  TuuDemo
//
//  Created by 张鸿 on 16/3/14.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#define USRNAME @"MaiYouUserName"
#define PWD @"MaiYoupwd"
#define USERID @"MaiYouUserID"

//#define USRNAME @"username"
//#define PWD @"pwd"
//#define USERID @"userID"
#define SERVICEID @"ServiceID"
#define LOGINSTYLE @"LoginStyle"




#import "TUConfig.h"
#import "DeveicePlatform.h"
#import "ShareVale.h"
#import <UIKit/UIKit.h>

@implementation ShareVale
DEF_SINGLETON(ShareVale)

- (LoginStyle)loginStyle
{
   return [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINSTYLE] intValue];
}

- (void)setLoginStyle:(LoginStyle)loginStyle
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(loginStyle) forKey:LOGINSTYLE];
    [defaults synchronize];
}

- (NSString *)appKey
{
//    if (_appKey == nil) {
//        //加载plist文件
//        NSDictionary *dic = [self getTUUPlist];
//        _appKey = [dic objectForKey:@"MAIY_APPKEY"];
//    }

    if (_appKey == nil) {
        _appKey = @"maiyou_game_sdk_24knskdhf8w!";
    }
    return _appKey;
}

- (NSString *)sdkVersion {
    if (_sdkVersion == nil) {
        _sdkVersion = @"1.0.8";
    }
    return _sdkVersion;
}
- (NSString *)gameID
{
    if (_gameID == nil) {
        //加载plist文件
        NSDictionary *dic = [self getTUUPlist];
        _gameID = [dic objectForKey:@"MAIY_GAMEID"];
    }
    
    return  _gameID;
}

- (NSString *)appID
{
    if (_appID == nil) {
        //加载plist文件
        NSDictionary *dic = [self getTUUPlist];
       _appID = [dic objectForKey:@"MAIY_APPID"];
    }
    return _appID;
}

- (NSString *)chenelid
{
    if (_chenelid == nil) {
        //渠道号
       NSDictionary *dic = [self getTUUPlist];
       NSString *agent = [dic objectForKey:@"MAIY_AGENT"];

        NSString *chanPath =[[NSBundle mainBundle] pathForResource:TUUChannel ofType:nil];
        NSError *error =nil;
        NSString *chanel = [[NSString alloc] initWithContentsOfFile:chanPath encoding:NSUTF8StringEncoding error:&error];
        if (chanel.length != 0 && chanel) {
            agent = chanel;
        }
        
        _chenelid = agent;
        if (error) {
            NSLog(@"%@",error.description);
        }
    }
    return _chenelid;
    
}

- (NSString *)phoneType
{
    if (_phoneType == nil) {
        _phoneType = @"3";
    }
    return _phoneType;
}

- (NSString *)version
{
    if (_version == nil) {
        _version = [UIDevice currentDevice].systemVersion;
    }
    return _version;
}

- (void)setUserName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:USRNAME];
    [defaults synchronize];
}

- (NSString *)userName
{
  return  [[NSUserDefaults standardUserDefaults] objectForKey:USRNAME];
}


- (void)setServiceQQ:(NSString *)serviceQQ
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:serviceQQ forKey:@"serviceQQ"];
    [defaults synchronize];
}

- (NSString *)serviceQQ
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceQQ"];
}

- (void)setServiceWeb:(NSString *)serviceWeb
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:serviceWeb forKey:@"serviceWeb"];
    [defaults synchronize];
}

- (NSString *)serviceWeb
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"serviceWeb"];
}

- (void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
}

- (NSString *)token
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (NSString *)passWord
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PWD];
}

- (void)setPassWord:(NSString *)passWord
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:passWord forKey:PWD];
    [defaults synchronize];
}

#pragma mark -**************privateMethod
- (NSDictionary *)getTUUPlist
{
    //加载plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MY.plist" ofType:nil];
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}
- (NSString *)GameVersion{
    NSString *version =  [[NSUserDefaults standardUserDefaults] objectForKey:@"BTSDKGameVesion"];
    return version;
}
- (NSString*)RefreshGameUrl{
    NSString *url =  [[NSUserDefaults standardUserDefaults] objectForKey:@"BTSDKNewGameUrl"];
    return url;
}
- (NSString*)IDFA{
    NSString *IDFAstring = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return IDFAstring;
}
@end
