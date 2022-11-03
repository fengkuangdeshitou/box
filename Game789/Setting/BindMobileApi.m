//
//  BindMobileApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/28.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BindMobileApi.h"

@implementation BindMobileApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/bindPhone";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;

    if (self.code.length > 0) {
        params[@"code"] = self.code;
    }
    if (self.moblie.length > 0) {
        params[@"mobile"] = self.moblie;
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
        self.data = jsonDict[@"data"];
        self.success = 1;
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
    
}
@end
