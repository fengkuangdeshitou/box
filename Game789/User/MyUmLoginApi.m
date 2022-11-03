//
//  MyUmLoginApi.m
//  Game789
//
//  Created by Maiyou on 2020/1/15.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyUmLoginApi.h"

@implementation MyUmLoginApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL
{
    return @"cellularLogin";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"token"] = self.token;
    params[@"appkey"] = self.appkey;

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
