//
//  SegmentTypeApi.m
//  Game789
//
//  Created by haierguook on 2018/7/31.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "SegmentTypeApi.h"

static SegmentTypeApi * segTypeApi;

@implementation SegmentTypeApi

+(instancetype)sharedInstance{
    static dispatch_once_t disonece;
    dispatch_once(&disonece, ^{
        segTypeApi = [[SegmentTypeApi alloc]init];
    });
    return segTypeApi;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/common/getConfig";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID == NULL)
    {
        params [@"member_id"] = @"";
    }
    else
    {
        params [@"member_id"] = userID;
    }
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


@implementation GetActivityApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/activity/getActivity";
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



@implementation GetMiluVipCionsApi

+ (instancetype)sharedInstance{
    static dispatch_once_t disonece;
    static GetMiluVipCionsApi * vipCoinsApi;
    dispatch_once(&disonece, ^{
        vipCoinsApi = [[GetMiluVipCionsApi alloc]init];
    });
    return vipCoinsApi;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/common/getVipBalance";
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


@implementation ReceiveMiluVipCionsApi

+ (instancetype)sharedInstance{
    static dispatch_once_t disonece;
    static ReceiveMiluVipCionsApi * receiveApi;
    dispatch_once(&disonece, ^{
        receiveApi = [[ReceiveMiluVipCionsApi alloc]init];
    });
    return receiveApi;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/common/receiveVipBalance";
}

- (id)requestParameters
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [YYToolModel getUserdefultforKey:USERID];
    params [@"member_id"] = userID;
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
