//
//  PersonalCenterApi.m
//  Game789
//
//  Created by Maiyou on 2018/11/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "PersonalCenterApi.h"

@implementation PersonalCenterApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/comment/getMyCommentInfo";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.user_id)
    {
        params [@"member_id"] = self.user_id;
    }
    else
    {
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
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



@implementation GetMyCommentApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"get_comment_list";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.user_id forKey:@"uid"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [params setValue:userID forKey:@"member_id"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.pageNumber] forKey:@"page"];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.count] forKey:@"count"];
    [params setValue:dic forKey:@"pagination"];
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

@implementation GetMyReplyApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"getReplyList";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.user_id forKey:@"uid"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [params setValue:userID forKey:@"member_id"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.pageNumber] forKey:@"page"];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.count] forKey:@"count"];
    [params setValue:dic forKey:@"pagination"];
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


@implementation GetPlayedGamesApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getRecentlyGameList";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.user_id)
    {
        params [@"member_id"] = self.user_id;
    }
    else
    {
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
        params [@"member_id"] = userID;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.pageNumber] forKey:@"page"];
    [dic setValue:[NSString stringWithFormat:@"%li",(long)self.count] forKey:@"count"];
    [params setValue:dic forKey:@"pagination"];
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
