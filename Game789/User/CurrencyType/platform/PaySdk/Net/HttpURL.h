//
//  HttpURL.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/4.
//  Copyright © 2016年 张鸿. All rights reserved.
//


#ifndef HttpURL_h
#define HttpURL_h

#define KWINDOWNSWIDHT [UIScreen mainScreen].bounds.size.width
#define KWINDOWNSHEIGHT [UIScreen mainScreen].bounds.size.height

//充值记录标志
#define RECORDOFPSUCESS @"1" //成功
#define RECORDOFFAIL @"2"    //失败
#define RECORDOFWAIT @"0"    //待处理


#import "ShareVale.h"
#import "ResponseInfo.h"

//获取支付URL
#define  GetPayURL @"sdk/shengpay/shengpay.php"

//获取支付结果
#define  GetPayResult @"sdk/shengpay/query.php"

//qq钱包支付
#define QQWALLETURL @"sdk/qqpay/qqpay.php"

//上传角色信息
#define ChangeRoleinfo @"/account/setRole"

//获取icon等素材
#define IconURL @"/basic/getMaterial"

//注册
#define RegisterURL @"/account/register"

#define RegisterRandURL @"/account/getRandUsername"


//登录
#define LoginURL @"/account/login"

//退出登录
#define LogOutURL @"/account/logout"

//忘记密码
#define PwdBackURL @"/account/findPass"


//获取支付渠道
#define GetPayWayURL @"sdk/getPayWay.php"

//查询余额uu币
#define GetMyUUUrl @"sdk/ttbpay/getTTB.php"

//平台充值接口
#define UUPayInterfaceURL @"sdk/ttbpay/ttbnew.php"

//客服qq和电话
#define ServiceQQAndPhoneUrl @"sdk/searchUserBuImeil.php"

//一键支付地址
#define GetQuickPayHtmlUrl @"sdk/ypay/yeepay.php"

//查询订单记录
#define OrderRecordURL @"sdk/payRecords_page.php"

//游戏详细信息
#define GameDeailUrl @"sdk/getGameDetail.php"

//根据infoid获取礼包码
#define GetGiftCode  @"sdk/getGiftCode.php"

//获取游戏礼包条目地址
#define GetGamePresentUrl @"sdk/getGiftList.php"

//将相关数据带给支付宝时，先将相关数据发送到我方服务端
#define SendSelfSERVER @"sdk/alipay/alipay.php"
//将相关数据带给支付宝时，先将相关数据发送到我方服务端
#define SendALIPAYSERVER @"http://sdk.99maiyou.com/sdk/alipay_rsa2/alipay.php"
//2018-01-13 新的 接口 将相关数据带给支付宝时，先将相关数据发送到我方服务端
#define SendSelfNewSERVER @"sdk/alipay_new/alipay.php"

//支付宝充值回调路径
#define AlipayNotifyURL @"sdk/alipay/notify_url.php"


#pragma html
//用户协议地址
#define HTMLFORUSERAGREE  @"sdk/xieyi.html"

//充值说明
#define HTMLFORPAYEXPLANE @"sdk/pay_des.html"

////用户中心
//#define HTMLFORUSERCENTER @"http://testsdk2.99maiyou.com/user/index"
//// #define HTMLFORUSERCENTER @"http://172.16.100.169:888/user/index"
//
//// 支付中心
//#define HTMLFOPAYCENTER @"http://testsdk2.99maiyou.com/pay/index"

//用户中心
#define HTMLFORUSERCENTER @"/user/index"
// #define HTMLFORUSERCENTER @"http://172.16.100.169:888/user/index"

// 支付中心
#define HTMLFOPAYCENTER @"/pay/index"

//礼包
#define HTMLFORGIFT @"http://sdk.99maiyou.com/cysdkfloat/gift.php"

//客服
#define HTMLFORCUSTOMERSERVICE @"http://testsdk2.99maiyou.com/basic/cs"

//论坛[无需认证，要修改为游戏中心]
#define HTMLFORFORUM @"http://sdk.99maiyou.com/forum.php"

//查询版本更新
#define VERSIONUPDATE @"/basic/getUpdate"

#endif /* HttpURL_h */
