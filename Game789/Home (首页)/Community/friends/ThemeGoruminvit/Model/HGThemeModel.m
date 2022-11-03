//
//  HGThemeModel.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGThemeModel.h"

@implementation HGThemeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"comments":[Comment class]
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"dynamicId":@"id",
    };
}

@end
