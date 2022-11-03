//
//  MyGetVoucherListApi.m
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGetVoucherListApi.h"

@implementation MyGetVoucherListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"receivedVouchers";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.is_expired.length > 0)
    {
        params [@"is_expired"] = self.is_expired;
    }
    if (self.is_used.length > 0)
    {
        params [@"is_used"] = self.is_used;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    
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


@implementation MyReceiveGameVoucherApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"receiveVoucher";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.game_id.length > 0)
    {
        params [@"game_id"] = self.game_id;
    }
    if (self.voucher_id.length > 0)
    {
       params [@"voucher_id"] = self.voucher_id;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    
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

@implementation MyReceiveVouchersListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"vouchers";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.game_id.length > 0)
    {
        params [@"game_id"] = self.game_id;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    
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

