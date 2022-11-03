//
//  TestingAPI.m
//  Game789
//
//  Created by maiyou on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "TestingAPI.h"

@implementation TestingAPI


- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/Special/getData";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    params [@"id"] = self.Id;
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

@implementation JoinTestingAPI


- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/BateSpecial/receive";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.type) {
        params[@"type"] = self.type;
    }
    if (self.packid) {
        params[@"packid"] = self.packid;
    }
    if (self.maiyou_gameid) {
        params[@"maiyou_gameid"] = self.maiyou_gameid;
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


