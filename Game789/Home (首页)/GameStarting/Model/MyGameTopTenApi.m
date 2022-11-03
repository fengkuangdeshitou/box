//
//  MyGameTopTenApi.m
//  Game789
//
//  Created by Maiyou on 2020/8/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameTopTenApi.h"

@implementation MyGameTopTenApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/oneWeekGameTop";
}

- (id)requestParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li", (long)self.pageNumber],
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
