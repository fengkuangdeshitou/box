//
//  HomeListApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/5.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "HomeListApi.h"
@interface HomeListApi()

@end
@implementation HomeListApi
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
    //新游榜、排行榜、
    if (self.stautsNav == YES) {
        if (self.type.length > 0) {
            params[@"type"] =  self.type;
        }
        if (self.mainType.length > 0) {
            
            params [@"game_species_type"] = self.mainType;
        }
    }
    else
    {
        if (self.type.length > 0)
        {
            params[@"type"] =  self.mainType;
        }
        if (self.mainType.length > 0)
        {
            params [@"game_species_type"] = self.type;
        }
    }
    if (self.search_info.length > 0) {
        params[@"search_info"] = self.search_info;
    }
    
    if (self.game_classify_type.length > 0) {
        params[@"game_classify_type"] = self.game_classify_type;
    }
    params[@"is_search"] = [NSNumber numberWithBool:self.isSearch];
    params [@"member_id"] = userID;
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

@implementation SearchApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/searchGame/search";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (self.search_info.length > 0) {
        params[@"search_info"] = self.search_info;
    }
    
    params[@"game_species_type"] = @"0";
    params[@"is_search"] = [NSNumber numberWithBool:self.isSearch];
    params [@"member_id"] = userID;
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
