//
//  registerApi.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "registerApi.h"

@interface registerApi ()


@end

@implementation registerApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/register";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.userName.length>0) {
        params[@"username"] = self.userName;
    }
    if (self.pwd.length>0) {
        params[@"password"] = self.pwd;
    }
    if (self.regtype.length>0) {
        params[@"regtype"] = self.regtype;
    }
    if (self.code.length>0) {
        params[@"code"] = self.code;
    }
    
    NSString * date = [NSDate getCurrentTimes:@"yyyyMMdd"];
    NSString *client_token = [NSString stringWithFormat:@"%@%@%@%@%@", self.pwd, self.regtype, self.userName, date, salt_key];
    params[@"client_token"] = [client_token md5HashToLower32Bit];
    
    //进行加密处理
    params = [NSMutableDictionary dictionaryWithDictionary:[self base64EncodeData:params]];
    return params;
}

- (NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


- (void)requestCompleted {

    if (!self.responseObject) {
        return;
    }

    NSDictionary *jsonDict = self.responseObject;
    NSDictionary *status = [jsonDict objectForKey:@"status"];
    if ([status[@"succeed"] integerValue] == 1) {
        //成功
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
}

@end
