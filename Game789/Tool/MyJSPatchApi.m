//
//  MyJSPatchApi.m
//  Game789
//
//  Created by Maiyou on 2019/1/19.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyJSPatchApi.h"

@implementation MyJSPatchApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/patch/getPatch";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:[DeviceInfo shareInstance].appDisplayVersion forKey:@"version"];
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
        self.success = 1;
        self.data = jsonDict[@"data"];
    }
    else {
        self.success = 0;
        self.error_desc = status[@"error_desc"];
    }
}

@end
