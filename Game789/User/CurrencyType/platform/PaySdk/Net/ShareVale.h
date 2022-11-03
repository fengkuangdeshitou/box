//
//  RequestOBJ.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/14.
//  Copyright © 2016年 张鸿. All rights reserved.
/*****获取配置信息****/

#import <Foundation/Foundation.h>
#import "XTSingleton.h"
#import <AdSupport/AdSupport.h>
typedef enum : NSUInteger {
    Log_Normo = 0,
    Log_Loging = 1,
    Log_Out = 2,
    
} LoginStyle;

@interface ShareVale : NSObject
AS_SINGLETON(ShareVale)

@property (assign, nonatomic) LoginStyle loginStyle;
/**
 *  appid
 */
@property (copy, nonatomic) NSString *appID;
/**
 *  游戏id
 */
@property (copy, nonatomic) NSString *gameID;

/**
 *  渠道key
 */
@property (copy, nonatomic) NSString *appKey;


/**
 *  渠道id
 */
@property (copy, nonatomic) NSString *chenelid;
/**
 *  手机类型
 */
@property (copy, nonatomic) NSString *phoneType;
/**
 *  系统版本
 */
@property (copy, nonatomic) NSString *version;

/**
 * 游戏版本 -1首次 －2需要强制更新  －3非强制更新
 */
@property (copy, nonatomic) NSString *GameVersion;
/**
 *  更新地址
 */
@property (copy, nonatomic) NSString *RefreshGameUrl;
//用户账户
@property (copy, nonatomic) NSString *userName;

//用户密码
@property (copy, nonatomic) NSString *passWord;

//角色id
@property (copy, nonatomic) NSString *userID;

//服务器id
@property (copy, nonatomic) NSString *ServiceID;

//支付商品名字
@property (copy, nonatomic) NSString *productName;

//支付商品描述
@property (copy, nonatomic) NSString *productDesc;

//SDK Version
@property (copy, nonatomic) NSString *sdkVersion;

@property (copy, nonatomic) NSString *wxappID;

@property (copy, nonatomic) NSString *IDFA;

@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *serviceQQ;   // 服务qq

@property (copy, nonatomic) NSString *serviceWeb;  //服务官网
@end
