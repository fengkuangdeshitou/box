//
//  MyProjectGameApi.m
//  Game789
//
//  Created by Maiyou on 2018/12/6.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "MyProjectGameApi.h"

@implementation MyProjectGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getProjectGames";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    
    if (self.game_species_type)
    {
        params [@"game_species_type"] = self.game_species_type;
    }
    
//    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li", self.pageNumber],@"count":[NSString stringWithFormat:@"%li", self.count]};
    
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
