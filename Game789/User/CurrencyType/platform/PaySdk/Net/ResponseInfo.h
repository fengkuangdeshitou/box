//
//  LoginResult.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/15.
//  Copyright © 2016年 张鸿. All rights reserved.
//  ..........响应发回信息

#import "TUBASEResponse.h"

/**
 *  登录结果
 */
@interface LoginResult : TUBASEResponse

@property (copy, nonatomic) NSString *userName;//用户名


@property (copy, nonatomic) NSString *urserPwd;//用户密码

@property (copy, nonatomic) NSString *token;//用户token

@property (copy, nonatomic) NSString *sign;//验签用


@property (copy, nonatomic) NSString *sinceTime;//时间轴

@end

/**
 *  注册结果
 */
@interface RegisterResult : TUBASEResponse


@property (copy, nonatomic) NSString *userName;//用户名


@property (copy, nonatomic) NSString *urserPwd;//用户密码


@property (copy, nonatomic) NSString *sign;//验签用


@property (copy, nonatomic) NSString *sinceTime;//时间轴

@end

/**
 *  获取uu币
 */
@interface GetMyUUResult : TUBASEResponse
@property (copy, nonatomic) NSString *UB; //uu币


@end

/**
 *  退出登录
 */
@interface LoginOut : TUBASEResponse

@end

/**
 *  uuB支付
 */
@interface TTbPay : TUBASEResponse
@property (copy, nonatomic) NSString *orderID; //订单id

@end
/**
 *  微富通支付
 */
@interface WFTInfo : TUBASEResponse
@property (copy, nonatomic) NSString *token;    //token id
@property (copy, nonatomic) NSString *services; //服务 id
@property (copy, nonatomic) NSString *orderID;  //订单id
@end
/**
 *  SDKAPI获取支付渠道
 */
@interface PayWay : TUBASEResponse
@property (strong, nonatomic) NSArray *data;
@end

/**
 *  客服qq与客户电话
 */
@interface  HelpQQAndTel: TUBASEResponse
@property (copy, nonatomic) NSString *QQ; //qq
@property (copy, nonatomic) NSString *TEL; //☎️
@property (copy, nonatomic) NSString *ttbRate; //ttb和人民币的比例
@property (copy, nonatomic) NSString *libaoShow; //控制礼拜按钮的出现 1为出现 2为隐藏
@end

/**
 *  一键支付
 */
@interface QuickPay : TUBASEResponse
@property (copy, nonatomic) NSString *url; //支付网站URL
@property (copy, nonatomic) NSString *orderID; //订单id
@end

/**
 *  订单记录
 */
@interface OrderRecords : TUBASEResponse
@property (strong, nonatomic) NSArray *dataArray; //记录的信息

@property (copy, nonatomic) NSString *orderID; //订单id
@property (copy, nonatomic) NSString *amount; //金额
@property (copy, nonatomic) NSString *Paytype; //支付类型 (yibao , ttb ,zfb)
@property (copy, nonatomic) NSString *creatTime; //订单创建时间
@property (copy, nonatomic) NSString *creatSinceTime; //订单创建时间轴
@end


/**
 *  游戏详细信息
 */
@interface GameDetail : TUBASEResponse
@property (copy, nonatomic) NSString *iconURL; //图标URL
@property (copy, nonatomic) NSString *desc; //描述
@property (copy, nonatomic) NSString *downLoadURL; //下载地址
@property (copy, nonatomic) NSString *gameName; //游戏名字

@end


/**
 *  将相关数据带给支付宝时，先将相关数据发送到我方服务端
 */
@interface NotifyServer : TUBASEResponse
@property (copy, nonatomic) NSString *messge;
@end

/**
 *  将相关数据带给支付宝时，先将相关数据发送到我方服务端
 */
@interface NotifyNativeServer : TUBASEResponse
@property (copy, nonatomic) NSDictionary *dataDic;
@end

/**
 微信支付配置
 */
@interface WeiXinInfo : TUBASEResponse
@property (copy, nonatomic) NSString  *appid;
@property (copy, nonatomic) NSString *noncestr;
@property (copy, nonatomic) NSString *package;
@property (copy, nonatomic) NSString *partnerid;
@property (copy, nonatomic) NSString *prepayid;
@property (copy, nonatomic) NSString *sign;
@property (copy, nonatomic) NSString *timestamp;
@end



/**
 获取游戏版本
 */
@interface VersionInfo : TUBASEResponse
@property (nonatomic) BOOL  isNeedUpdate;
//是否强制
@property (nonatomic) BOOL isForce;
@property (copy, nonatomic) NSString *upUrl;
@property (copy, nonatomic) NSString *gameVersion;
@end
























