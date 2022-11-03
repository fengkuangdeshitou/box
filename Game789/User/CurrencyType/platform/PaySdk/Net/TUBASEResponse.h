//
//  TUBASEResponse.h
//  TuuDemo
//
//  Created by 许杨 on 16/3/17.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUBASEResponse : NSObject
@property (copy, nonatomic) NSString *code;//状态码

@property (copy, nonatomic) NSString *mesage;//描述信息


@property (copy, nonatomic) NSString *error_code;//状态码


@property (copy, nonatomic) NSString *error_description;//描述信息

+ (instancetype)responseWithDic:(NSDictionary *)dic;
@end
