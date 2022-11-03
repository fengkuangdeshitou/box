//
//  MySellAccountApi.m
//  Game789
//
//  Created by Maiyou on 2020/4/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySellAccountApi.h"

@implementation MySellAccountApi

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
    return @"user/trade/uploadImagePublicOss";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID) {
        params [@"member_id"] = userID;
    }
    if (self.imageData) {
        params[@"imageData"] = self.imageData;
    }
    if (self.uploadType) {
        params[@"type"] = self.uploadType;
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
