//
//  HomeRecentlyGameListApi.m
//  Game789
//
//  Created by Maiyou on 2018/8/10.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HomeRecentlyGameListApi.h"

@implementation HomeRecentlyGameListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getRecentlyGameList";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.mainType.length > 0) {
        params [@"game_species_type"] = self.mainType;
    }
    return params;
}

- (void)requestCompleted
{
    if (!self.responseObject)
    {
        return;
    }
    NSDictionary *jsonDict = self.responseObject;
    NSDictionary *status = [jsonDict objectForKey:@"status"];
    if ([status[@"succeed"] integerValue] == 1) {
        //成功
        self.data = jsonDict[@"data"];
        self.success = 1;
    }
    else
    {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
    
}
@end
