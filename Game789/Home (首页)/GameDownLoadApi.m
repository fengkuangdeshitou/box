//
//  GameDownLoadApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/23.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "GameDownLoadApi.h"

@implementation GameDownLoadApi
- (instancetype)init {
    self = [super init];
    if (self) {
//        self.requestMethod = RequestMethodPOST;
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

//http://api.app.99maiyou.com/base/game/download/id/72/ag/tNhKXTz3/type/ios
- (NSString *)requestURL {
//    NSString *urlStr = [NSString stringWithFormat:@"base/game/download/id/%@/ag/tNhKXTz3/type/ios",self.gameId];
    NSString *urlStr = self.urls;
    return urlStr;
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    return params;
}

- (void)requestCompleted {

    if (!self.responseObject) {
        return;
    }
    NSDictionary *jsonDict = self.responseObject;
    NSDictionary *status = [jsonDict objectForKey:@"status"];
    NSInteger success = [[status objectForKey:@"succeed"] integerValue];
    if (success == 1) {
        //成功
        self.data = [jsonDict objectForKey:@"data"];
        self.success = 1;
    }
    else {
        self.success = 0;
        NSString * errorDesc = [status objectForKey:@"error_desc"];
        self.error_desc = errorDesc;
        [MBProgressHUD showToast:errorDesc toView:[UIApplication sharedApplication].delegate.window];
    }
}
@end
