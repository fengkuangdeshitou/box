//
//  EditUserInfoApi.m
//  Game789
//
//  Created by xinpenghui on 2017/9/17.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "EditUserInfoApi.h"

@implementation EditUserInfoApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/user/editMemberInfo";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;

    if (self.real_name.length > 0) {
        params[@"real_name"] = self.real_name;
    }else{
        self.real_name = @"";
    }
    
    if (self.mobile.length > 0) {
        params[@"mobile"] = self.mobile;
    }else{
        self.mobile = @"";
    }
    
    if (self.icon_link.length > 0) {
        params[@"icon_link"] = self.icon_link;
    }else{
        self.icon_link = @"";
    }
    
    if (self.identity_card.length > 0) {
        params[@"identity_card"] = self.identity_card;
    }else{
        self.identity_card = @"";
    }
    
    if (self.nick_name.length > 0) {
        params[@"nick_name"] = self.nick_name;
    }else{
        self.nick_name = @"";
    }
    
    if (self.qq.length > 0) {
        params[@"qq"] = self.qq;
    }
    
    if (self.ios_down_style)
    {
        params[@"ios_down_style"] = self.ios_down_style;
    }
    
    NSString * date = [NSDate getCurrentTimes:@"yyyyMMdd"];
    NSString *client_token = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.identity_card, userID, self.nick_name, self.real_name, date, salt_key];
    params[@"client_token"] = [client_token md5HashToLower32Bit];

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
