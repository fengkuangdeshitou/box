//
//  TradingObtainedApi.m
//  Game789
//
//  Created by Maiyou on 2018/8/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingObtainedApi.h"

@implementation TradingObtainedApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/trade/opetateTrade";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    
    if (self.trade_id.length > 0)
    {
        params[@"trade_id"] = self.trade_id;
    }
    
    if (self.trade_status.length > 0)
    {
        params[@"trade_status"] = self.trade_status;
    }
    
    params[@"member_id"] = userID;
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],
                              @"count":[NSString stringWithFormat:@"%li",self.count]};
    
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
