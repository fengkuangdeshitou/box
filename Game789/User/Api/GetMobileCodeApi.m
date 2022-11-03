//
//  GetMobileCodeApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "GetMobileCodeApi.h"

@implementation GetMobileCodeApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/tool/getVerifyCode";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.mobile.length > 0)
    {
//        params[@"mobile"] = self.mobile;
        
        if ([self.mobile isEqualToString:@"1"])
        {
            params[@"mobile"] = self.mobile;
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
            params[@"member_id"] = userID;
        }
        else
        {
            if (![self.mobile containsString:@"-"]) {
                NSString * code = [YYToolModel getUserdefultforKey:@"member_info"][@"mobile_code"];
                self.mobile = [NSString stringWithFormat:@"%@-%@",code,self.mobile];
            }
            NSData *jsonData = [self.mobile dataUsingEncoding:NSUTF8StringEncoding];
            NSData *base64Json = [jsonData base64EncodedDataWithOptions:1];
            //2.函数加密
            NSString *str = [[NSString alloc] initWithData:base64Json encoding:NSUTF8StringEncoding];
            //去掉字符串中的空格
            str = [str stringByReplacingOccurrencesOfString:@"" withString:@""];
            //去掉字符串中的换行符
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            params[@"mobile"] = [NSString stringWithFormat:@"%@%@", [self getRandomStringWithNum:5], str];
        }
    }
    NSString *string = [NSString stringWithFormat:@"%@%@", self.mobile, Base_Key];
    params[@"code"] = [string md5HashToLower32Bit];
    params[@"type"] = self.type;

    return params;
}

- (void)requestCompleted {

    if (!self.responseObject) {
        return;
    }
    NSDictionary *jsonDict = self.responseObject;
    NSDictionary *status = [jsonDict objectForKey:@"status"];
    if ([status[@"succeed"] integerValue] == 1) {
        //成功
        NSDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:jsonDict[@"data"]];
        
        NSString * mobile = [jsonDict[@"data"][@"mobile"] substringFromIndex:5];
        NSData *data = [[NSData alloc]initWithBase64EncodedString:mobile options:0];
        mobile = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [dic setValue:mobile forKey:@"mobile"];
        self.data = dic;
        self.success = 1;
    }
    else
    {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
}
@end
