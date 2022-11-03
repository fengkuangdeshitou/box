//
//  PayConfig.h
//  PayDemo
//
//  Created by sam on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
// 支付宝集成注意 : 如果在appdelegate里创建window 应该去掉main.storyboard中的箭头
#import <Foundation/Foundation.h>


#define AlipayScheme @"MYAliPayScheme001"
#define QQWalletScheme  [NSString stringWithFormat:@"BTQQPayScheme%@",[ShareVale sharedInstance].gameID]

#pragma mark -----支付类型-----


typedef NS_ENUM (NSUInteger, TpayWay) {
    WeChatPay,
    AliPay,
    WftPay,
};
