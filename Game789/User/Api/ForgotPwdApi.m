//
//  ForgotPwdApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/29.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "ForgotPwdApi.h"

@implementation ForgotPwdApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/forgetPwd";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"mobile"] = self.mobile;
    if (self.code.length > 0) {
        params[@"code"] = self.code;
    }
    if (self.newpassword.length > 0) {
        params[@"newpassword"] = self.newpassword;
    }
//    if (self.code.length > 0) {
//        params[@"code"] = self.code;
//    }
    
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
        self.data = jsonDict[@"data"];
        self.success = 1;
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
    
}
@end
