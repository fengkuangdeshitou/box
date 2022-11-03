//
//  MyAOPManager.h
//  Game789
//
//  Created by Maiyou on 2020/8/4.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAOPManager : NSObject

//游戏相关
+ (void)gameRelateStatistic:(NSString *)methodName GameInfo:(NSDictionary *)dic Add:(NSDictionary *)addDic;
//用户相关
+ (void)userInfoRelateStatistic:(NSString *)methodName;
//自定义的相关统计
+ (void)relateStatistic:(NSString *)methodName Info:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
