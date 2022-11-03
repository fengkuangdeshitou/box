//
//  MyHomeGameListApi.m
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeGameListApi.h"
#import <WebKit/WebKit.h>

@implementation MyHomeGameListApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/newindex/getHomeGameList";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
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


@implementation MyGetAllVouchersApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/voucher/list";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.text)
    {
        [params setValue:self.text forKey:@"search_content"];
    }
    [params setValue:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.pageNumber], @"count":[NSString stringWithFormat:@"%ld",(long)self.count]} forKey:@"pagination"];
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


@implementation MyGetRecentGameVouchersApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/voucher/getLatePlayGames";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    [params setValue:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.pageNumber], @"count":[NSString stringWithFormat:@"%ld",(long)self.count]} forKey:@"pagination"];
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


@implementation MyGetSelectLikeTypeApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/selectCate/getData";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID)
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

@implementation MySaveLikeTypeApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/selectCate/save";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID)
    {
        params [@"member_id"] = userID;
    }
    if (self.tags)
    {
        params [@"tags"] = self.tags;
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

@implementation MyGetProjectGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/special/getData";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID)
    {
        params [@"member_id"] = userID;
    }
    if (self.project_id)
    {
        params [@"id"] = self.project_id;
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

@interface MyPromotionActivationApi ()

@property(nonatomic,strong)WKWebView * webview;

@end

@implementation MyPromotionActivationApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/Index/getToDayNews";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"os"] = @"1";
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    params[@"idfa"] = [DeviceInfo shareInstance].deviceIdfa ?: idfa;
    params[@"timestamp"] = [NSDate getNowTimeTimestamp];
    
    self.webview = [[WKWebView alloc]initWithFrame:CGRectZero];
    [self.webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable userAgentString, NSError * _Nullable error) {
        params[@"ua"] = userAgentString;
    }];
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

@implementation TKApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/tool/adddata";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
