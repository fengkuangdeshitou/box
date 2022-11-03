//
//  MyGetAllGamesApi.m
//  Game789
//
//  Created by yangyongMac on 2020/2/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGetAllGamesApi.h"

@implementation MyGetAllGamesApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"getAllGameList";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.gameName) {
        params [@"game_name"] = self.gameName;
    }
    
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",(long)self.pageNumber],@"count":[NSString stringWithFormat:@"%li",(long)self.count]};
    
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
