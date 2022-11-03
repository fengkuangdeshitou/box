//
//  GameSubmitCommitApi.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GameSubmitCommitApi.h"
#import "DeviceInfo.h"

@implementation GameSubmitCommitApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/comment/add";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    params[@"content"] = self.content;
    params[@"device_id"] = [DeviceInfo shareInstance].deviceType;
//    params[@"reply_id"] = @"";
    params[@"topic_id"] = self.topic_id;
//    params[@"pagination"]=@[@{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]}];
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
