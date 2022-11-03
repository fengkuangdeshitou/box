//
//  NSDictionary+MyDictionary.m
//  Game789
//
//  Created by Maiyou on 2018/12/11.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "NSDictionary+MyDictionary.h"

@implementation NSDictionary (MyDictionary)

- (NSDictionary *)deleteAllNullValue{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]])
        {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else if ([[self objectForKey:keyStr] isKindOfClass:[NSString class]])
        {
            if ([[self objectForKey:keyStr] isEqualToString:@"<null>"])
            {
                [mutableDic setObject:@"" forKey:keyStr];
            }
            else
            {
                [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
            }
        }
        else
        {
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
