//
//  TradingListApi.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingListApi.h"

@implementation TradingListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/trade/getTradeList";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    
    if (self.trade_type.length > 0)
    {
        params[@"trade_type"] = self.trade_type;
    }
    
    if (self.game_device_type.length > 0)
    {
        params[@"game_device_type"] = self.game_device_type;
    }
    
    if (self.game_name.length > 0)
    {
        params[@"game_name"] = self.game_name;
    }
    if (self.search_type.length > 0)
    {
        params[@"search_type"] = self.search_type;
    }
    if (self.sort_type.length > 0)
    {
        params[@"sort_type"] = self.sort_type;
    }
    if (self.buy_member_id.length > 0)
    {
        params[@"buy_member_id"] = userID;
    }
    if (self.game_id.length > 0)
    {
        params[@"game_id"] = self.game_id;
    }
    if (self.member_id.length > 0)
    {
        params[@"member_id"] = userID;
    }
    if (self.game_species_type.length > 0)
    {
        params[@"game_species_type"] = self.game_species_type;
    }
    if (self.game_classify_id.length > 0)
    {
        params[@"game_classify_id"] = self.game_classify_id;
    }
    if (self.trade_price_range.length > 0)
    {
        params[@"trade_price_range"] = self.trade_price_range;
    }
    if (self.trade_featured.length > 0)
    {
        params[@"trade_featured"] = self.trade_featured;
    }
    
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
