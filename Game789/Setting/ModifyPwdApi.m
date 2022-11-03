//
//  ModifyPwdApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/17.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "ModifyPwdApi.h"

@implementation ModifyPwdApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/modifyPwd";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;

    if (self.oldPwd.length > 0) {
        params[@"password"] = self.oldPwd;
    }
    if (self.newsPwd.length > 0) {
        params[@"newpassword"] = self.newsPwd;
    }
    
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
