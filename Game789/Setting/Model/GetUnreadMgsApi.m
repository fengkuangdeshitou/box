//
//  GetUnreadMgsApi.m
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GetUnreadMgsApi.h"

@implementation GetUnreadMgsApi

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
    return @"mess_unread_count";
}
//请求餐素
- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
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
