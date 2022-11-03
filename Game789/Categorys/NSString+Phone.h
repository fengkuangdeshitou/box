//
//  NSString+Phone.h
//  Game789
//
//  Created by xinpenghui on 2017/9/7.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Phone)

- (BOOL)valiMobile;

/**
 判断该字符串是不是一个有效的URL
 
 @return YES：是一个有效的URL or NO
 */
- (BOOL)isValidUrl;

/** 根据图片名 判断是否是gif图 */
- (BOOL)isGifImage;

/** 根据图片data 判断是否是gif图 */
- (BOOL)isGifWithImageData: (NSData *)data;

/**
 根据image的data 判断图片类型
 
 @param data 图片data
 @return 图片类型(png、jpg...)
 */
- (NSString *)contentTypeWithImageData: (NSData *)data;

/**  url后面拼接参数  */
-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key;

/// 文字设置行间距
/// @param lineSpace 行间距
/// @param kern 字体间距
- (NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;

@end
