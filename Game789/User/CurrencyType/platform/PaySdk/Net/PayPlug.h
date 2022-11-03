//
//  PayPlug.h
//  PayDemo
//
//  Created by sam on 15/11/2.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "PayConfig.h"
#import "TUConfig.h"
//#import "ResponseInfo.h"

typedef void (^PayResult)(TpayWay way, id obj, NSError *error);

@interface PayPlug : NSObject<WXApiDelegate>
@property (nonatomic, strong) NSDictionary *zfbDic;
@property (nonatomic, copy)  NSString *sn;//订单号
@property (nonatomic, copy)  NSString *productTitle;//标题
@property (nonatomic, copy)  NSString *productDesc;//产品详情
@property (nonatomic, copy)  NSString *productPrice;//产品价格 单位分
@property (nonatomic, copy)  NSString *notiUrl;//通知地址
@property (nonatomic, assign)  TpayWay payWay;//支付方式
@property (copy, nonatomic) NSString *cpEX;

/***微信配置***/
//@property (copy, nonatomic) WeiXinInfo *wxinfo; //微信配置
@property (copy, nonatomic) NSString  *appid;
@property (copy, nonatomic) NSString *noncestr;
@property (copy, nonatomic) NSString *package;
@property (copy, nonatomic) NSString *partnerid;
@property (copy, nonatomic) NSString *prepayid;
@property (copy, nonatomic) NSString *sign;
@property (copy, nonatomic) NSString *timestamp;

/***威富通配置***/
@property (copy, nonatomic) NSString  *token;
@property (copy, nonatomic) NSString *services;
@property (copy, nonatomic) NSString *orderid;
@property (strong, nonatomic) UIViewController *VC;


+ (instancetype)sharedInstance;

- (void)doPay:(PayResult)blcok;
- (void)newAlipay:(PayResult)block;

- (void)h5ToNativePay:(NSString *)orderString;
@end
