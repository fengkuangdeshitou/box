//
//  LoginApi.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "LoginApi.h"
#import "NSString+MD5.h"

@interface LoginApi ()

//@property (strong, nonatomic) NSDictionary *data;

@end

@implementation LoginApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/login";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"username"] = self.userName;
    params[@"password"] = self.pwd;
    params[@"logintype"] = self.logintype;
    
    NSString *code = [NSString stringWithFormat:@"%@%@", self.userName, salt_key];
    params[@"code"] = [code md5HashToLower32Bit];
    
    NSString * date = [NSDate getCurrentTimes:@"yyyyMMdd"];
    NSString *client_token = [NSString stringWithFormat:@"%@%@%@%@%@", self.logintype, self.pwd, self.userName, date, salt_key];
    params[@"client_token"] = [client_token md5HashToLower32Bit];
    
    //进行加密处理
    params = [NSMutableDictionary dictionaryWithDictionary:[self base64EncodeData:params]];
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
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }

}
@end


@implementation VerifyCodeLoginApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"smsLogin";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"mobile"] = self.mobile;
    params[@"code"] = self.code;
    
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
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }

}
@end

@implementation TickLoginApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"tickLogin";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"username"] = self.username;
    params[@"tick"] = self.tick;
    
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
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }

}

@end


@implementation GetCountryCodeApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"getAreaList";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }

}

@end
