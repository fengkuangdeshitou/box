//
//  ReturnReSubmitApi.m
//  Game789
//
//  Created by xinpenghui on 2018/3/18.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ReturnReSubmitApi.h"

@implementation ReturnReSubmitApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"user/rebate/modifyRebate";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSLog(@"info data = %@",self.valueDic);
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    params[@"member_id"] = userID;
    params[@"server_id"] = [self.valueDic objectForKey:@"server_id"];
    params[@"rebate_id"] = [self.valueDic objectForKey:@"rebate_id"];
    params[@"role_name"] = [self.valueDic objectForKey:@"role_name"];
    params[@"role_id"] = [self.valueDic objectForKey:@"role_id"];
    params[@"remark"] = [self.valueDic objectForKey:@"remark"];
    return params;
}

-(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
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
