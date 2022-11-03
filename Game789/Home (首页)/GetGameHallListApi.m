//
//  GetGameHallListApi.m
//  Game789
//
//  Created by Maiyou on 2018/7/26.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GetGameHallListApi.h"

@implementation GetGameHallListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getGameList";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    
    if (self.search_info.length > 0) {
        params[@"search_info"] = self.search_info;
    }
    if (self.type.length > 0) {
        params[@"type"] = self.type;
    }
    if (self.game_classify_type.length > 0) {
        params[@"game_classify_type"] = self.game_classify_type;
    }
    if (self.game_species_type.length > 0) {
        params[@"game_species_type"] = self.game_species_type;
    }else{
        params[@"game_species_type"] = @"";
    }
    if (self.sortType)
    {
        params[@"tab"] = self.sortType;
    }

    params[@"pagination"]=@{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    
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
