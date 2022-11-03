//
//  MyAOPManager.m
//  Game789
//
//  Created by Maiyou on 2020/8/4.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyAOPManager.h"

@implementation MyAOPManager
//获取游戏相关的数据
+ (void)gameRelateStatistic:(NSString *)methodName GameInfo:(NSDictionary *)dic Add:(nonnull NSDictionary *)addDic
{
    dic = [dic deleteAllNullValue];
    NSMutableDictionary * gameDic = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * data in dic[@"game_classify_name"])
    {
        [array addObject:data[@"tagname"]];
    }
    [gameDic setValue:dic[@"game_name"] forKey:@"gameName"];
    [gameDic setValue:dic[@"game_species_type"] forKey:@"game_species_type"];
    if (array.count > 0) {
        [gameDic setValue:[array componentsJoinedByString:@"_"] forKey:@"game_classify_name"];
    }
    [gameDic addEntriesFromDictionary:[self getUserInfo]];
    if (addDic)
    {
        [gameDic addEntriesFromDictionary:addDic];
    }
    [MobClick event:methodName attributes:gameDic];
}

+ (void)userInfoRelateStatistic:(NSString *)methodName
{
    [MobClick event:methodName attributes:[self getUserInfo]];
}

+ (NSDictionary *)getUserInfo
{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    if ([YYToolModel getUserdefultforKey:USERID])
    {
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        [userInfo setValue:dic[@"member_name"] forKey:@"member_name"];
        [userInfo setValue:dic[@"vip_level"] forKey:@"vip_level"];
        NSString * identity_card = dic[@"identity_card"];
        if (identity_card.length > 0)
        {
            NSString * sexStr = [identity_card substringWithRange:NSMakeRange(identity_card.length - 2, 1)];
            NSString * sex = sexStr.integerValue % 2 == 0 ? @"女" : @"男";
            [userInfo setValue:sex forKey:@"sex"];
            
            if (identity_card.length == 18)
            {
                //获取年龄
                NSString *ageStr = [self calculateAgeStr:identity_card];
                [userInfo setValue:ageStr forKey:@"age"];
            }
        }
    }
    [userInfo setValue:DeviceInfo.shareInstance.channel forKey:@"agent"];
    return userInfo;
}

+ (void)relateStatistic:(NSString *)methodName Info:(NSDictionary *)dic
{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    if (dic)
    {
        [infoDic addEntriesFromDictionary:dic];
    }
    [infoDic addEntriesFromDictionary:[self getUserInfo]];
    //如果有参数则传
    if (infoDic)
    {
        [MobClick event:methodName attributes:infoDic];
    }
    else
    {
        [MobClick event:methodName];
    }
}

+ (NSString *)calculateAgeStr:(NSString *)str{
  //截取身份证的出生日期并转换为日期格式
   NSString *dateStr = [self subsIDStrToDate:str];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-mm-dd";
    NSDate *birthDate =  [formatter dateFromString:dateStr];
    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    
    // 计算年龄
    int age  =  trunc(dateDiff/(60*60*24))/365;
    NSString *ageStr = [NSString stringWithFormat:@"%d", -age];

    return ageStr;
}

//截取身份证的出生日期并转换为日期格式
+ (NSString *)subsIDStrToDate:(NSString *)str{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *dateStr = [str substringWithRange:NSMakeRange(6, 8)];
    NSString  *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString  *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString  *day = [dateStr substringWithRange:NSMakeRange(6,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    
    return result;
}

@end
