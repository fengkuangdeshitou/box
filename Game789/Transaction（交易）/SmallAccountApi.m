//
//  SmallAccountApi.m
//  Game789
//
//  Created by Maiyou on 2018/8/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "SmallAccountApi.h"

@implementation SmallAccountApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getSelfXhUserNameList";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    
    if (self.game_id.length > 0)
    {
        params[@"game_id"] = self.game_id;
    }
    
    if (self.maiyou_gameid.length > 0)
    {
        params[@"maiyou_gameid"] = self.maiyou_gameid;
    }
    
    params[@"member_id"] = userID;
    
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",(long)self.pageNumber],
                              @"count":[NSString stringWithFormat:@"%li",(long)self.count]};
    
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
