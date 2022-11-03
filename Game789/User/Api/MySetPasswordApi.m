//
//  MySetPasswordApi.m
//  Game789
//[
//  Created by Maiyou on 2020/1/15.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySetPasswordApi.h"

@implementation MySetPasswordApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL
{
    return @"finalCellularLogin";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"username"] = self.username;
    params[@"token"]    = self.token;
    if (self.password)
    {
        params[@"password"] = self.password;
    }
    //加密处理
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


@implementation MyPswSetPasswordApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL
{
    return @"setPassword";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"username"] = self.username;
    params[@"token"]    = self.token;
    params[@"member_id"] = self.member_id;
    if (self.password)
    {
        params[@"password"] = self.password;
    }
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
