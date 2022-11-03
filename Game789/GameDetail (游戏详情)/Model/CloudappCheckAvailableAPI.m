//
//  CloudappCheckAvailableAPI.m
//  Game789
//
//  Created by maiyou on 2021/7/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CloudappCheckAvailableAPI.h"

@implementation CloudappCheckAvailableAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    return [DeviceInfo shareInstance].cloudappCheckAvailableUrl;
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    params [@"gameid"] = self.gameid;
    params [@"username"] = self.username;    
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
