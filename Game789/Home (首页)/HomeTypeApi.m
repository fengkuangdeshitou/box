//
//  HomeTypeApi.m
//  Game789
//
//  Created by Maiyou on 2018/7/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HomeTypeApi.h"

@implementation HomeTypeApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/common/getConfig";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID == NULL)
    {
        params [@"member_id"] = @"";
    }
    else
    {
        params [@"member_id"] = userID;
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

@implementation StageABTestApi

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"uploadStatData";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID)
    {
        params [@"member_id"] = userID;
    }
    params[@"ab_test_stage"] = self.ab_test_stage;
    params[@"name"]  = self.name;
    params[@"value"] = self.value;
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
