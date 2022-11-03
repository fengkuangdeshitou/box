//
//  NSMutableDictionary+HTTP.h
//  eather
//
//  Created by 青秀斌 on 14-6-12.
//  Copyright (c) 2014年 com.cdzlxt.iw. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HTTP)

//当对象为空时，自动设置为空字符串（用于字符串设置）
- (void)setObject:(id)anObject forField:(id <NSCopying>)aKey;

//当对象为空时，自动设置为NULL对象（用于外键设置）
- (void)setObject:(id)anObject forFKField:(id <NSCopying>)aKey;

//当对象为空时，自动设置为0(用户时间设置)
- (void)setObject:(id)anObject forTMField:(id <NSCopying>)aKey;

//当对象为空时，不设置值（用于可选项设置）
- (void)setObject:(id)anObject forOPField:(id <NSCopying>)aKey;

@end
