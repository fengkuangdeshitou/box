//
//  MyNewGameRankApi.m
//  Game789
//
//  Created by Maiyou on 2019/10/31.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewGameRankApi.h"

@implementation MyNewGameRankApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/index/getRecommendGameList";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString * user_id = [YYToolModel getUserdefultforKey:USERID];
    if (user_id != NULL)
    {
        params[@"member_id"] = user_id;
    }
    params[@"type"] = @"new";
    
    
    return params;
}

- (void)requestCompleted
{
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
