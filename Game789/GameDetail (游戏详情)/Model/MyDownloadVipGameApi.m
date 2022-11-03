//
//  MyDownloadVipGameApi.m
//  Game789
//
//  Created by Maiyou on 2019/7/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyDownloadVipGameApi.h"

@implementation MyDownloadVipGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodGET;
    }
    return self;
}

- (NSString *)requestURL {
    NSString * udid = [DeviceInfo shareInstance].deviceUDID;
//    NSString * udid = @"3824cabe7f99af9d36ad1e2955628b3cc3eaaca8";
    NSString * agent = [DeviceInfo shareInstance].channel;
    NSString * url = [NSString stringWithFormat:@"http://iosd.milu.com/install/vip?agent=%@&gameid=%@&udid=%@", agent, self.gameid, udid];
    return url;
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
    self.data = jsonDict;
    
}

@end



@implementation MyNewDownloadVipGameApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
//    NSString * udid = [DeviceInfo shareInstance].deviceUDID;
//    NSString * udid = @"3824cabe7f99af9d36ad1e2955628b3cc3eaaca8";
//    NSString * agent = [DeviceInfo shareInstance].channel;
//    NSString * url = [NSString stringWithFormat:@"http://iosd.milu.com/install/vip?agent=%@&gameid=%@&udid=%@", agent, self.gameid, udid];
    return @"https://cert.udid.kaifumao.com/ios/single/sign";
}

- (id)requestParameters
{
    NSString * udid = [DeviceInfo shareInstance].deviceUDID;
    NSString * agent = [DeviceInfo shareInstance].channel;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    params[@"agent"] = agent;
    params[@"udid"]  = udid;
    params[@"game_id"]  = self.gameid;
    params[@"device_type"]  = [YYToolModel getIsIpad] ? [NSNumber numberWithInt:2] : [NSNumber numberWithInt:1];
    return params;
}

- (void)requestCompleted {
    
    if (!self.responseObject) {
        return;
    }
    NSDictionary *jsonDict = self.responseObject;
    self.data = jsonDict;
}

@end
