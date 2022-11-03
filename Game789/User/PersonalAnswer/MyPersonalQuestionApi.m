//
//  MyPersonalQuestionAndAnswerApi.m
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyPersonalQuestionApi.h"

@implementation MyPersonalQuestionApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"getQuestionsList";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.user_id forKey:@"uid"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
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



@implementation MyPersonalAnswerApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"getAnswersList";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.user_id forKey:@"uid"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
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
