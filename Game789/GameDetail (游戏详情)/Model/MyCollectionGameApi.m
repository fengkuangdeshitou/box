//
//  MyCollectionGameApi.m
//  Game789
//
//  Created by Maiyou on 2019/10/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyCollectionGameApi.h"

@implementation MyCollectionGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    
    return @"collectGame";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    [params setValue:self.maiyou_gameid forKey:@"id"];
    return params;
}

- (NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
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


@implementation MyCancleCollectionGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    
    return @"cancelCollectGame";
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    [params setValue:self.maiyou_gameid forKey:@"id"];
    return params;
}

- (NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
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
