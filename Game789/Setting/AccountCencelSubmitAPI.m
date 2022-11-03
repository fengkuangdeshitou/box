//
//  AccountCencelSubmitAPI.m
//  Game789
//
//  Created by maiyou on 2021/6/28.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "AccountCencelSubmitAPI.h"

@implementation AccountCencelSubmitAPI

//初始化请求方式
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}
//请求地址
- (NSString *)requestURL {
    return @"accountCancel/submit";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID) {
        params [@"member_id"] = userID;
    }
    return params;
}
//请求回调
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
