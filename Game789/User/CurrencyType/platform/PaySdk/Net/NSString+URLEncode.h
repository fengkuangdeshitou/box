//
//  NSString+URLEncode.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TUConfig.h"

/**
 *  加密接口使用的工具扩展
 */
@interface NSString (URLEncode)
@property (readonly) NSString *md5String;
// URL转义
- (NSString *)URLEncodedString;

// 字符串是否为空
- (BOOL)isEmptyOrWhitespace;

// 去除空格
- (NSString *)trimmedWhitespaceString;

// 取出回车
- (NSString *)trimmedWhitespaceAndNewlineString;

// 判断是是否为手机号
- (BOOL)isTelephone;

// 邮箱判断
- (BOOL)isEmail;

// 弱密码判断
- (BOOL)isWeakPswd;

////验签
//- (BOOL)isSignWithUserName:(NSString *)userName appkey:(NSString *)appkey sinceTime:(NSString *)time;

+ (NSString *)getWebViewURLArgument;

//图片路径 budle名称: TUUSDK.bundle
- (NSString *)getImagePath;
//获取TUUSDK.bundle的路径
+ (NSString *)getBundlePath;
@end
