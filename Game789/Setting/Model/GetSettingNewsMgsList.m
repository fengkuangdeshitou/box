//
//  GetSettingNewsMgsList.m
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GetSettingNewsMgsList.h"

@implementation GetSettingNewsMgsList

//初始化请求方式
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}
//请求地址
- (NSString *)requestURL {
    return @"mess_index_data";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.read_tag.length > 0)
    {
        params[@"read_tag"] = self.read_tag;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    return params;
}
//请求回调
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



@implementation ReceivingGoldCoinsAPI

//初始化请求方式
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}
//请求地址
- (NSString *)requestURL {
    return @"base/receiveBalance";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.message_params.length > 0)
    {
        params[@"id"] = self.message_params;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    return params;
}
//请求回调
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


@implementation GetChatMessageAPI

//初始化请求方式
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}
//请求地址
- (NSString *)requestURL {
    return @"getMessages";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.Id > 0)
    {
        params[@"id"] = self.Id;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    return params;
}
//请求回调
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


@implementation SendChatMessageAPI

//初始化请求方式
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}
//请求地址
- (NSString *)requestURL {
    return @"sendMessage";
}
//请求餐素
- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.taskId > 0)
    {
        params[@"taskId"] = self.taskId;
    }
    if (self.toUid > 0)
    {
        params[@"toUid"] = self.toUid;
    }
    if (self.content > 0)
    {
        params[@"content"] = self.content;
    }
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
    return params;
}
//请求回调
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
