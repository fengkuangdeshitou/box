//
//  KaiFuApiList.m
//  Game789
//
//  Created by xinpenghui on 2017/9/6.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "KaiFuApiList.h"

@implementation KaiFuApiList
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = RequestMethodPOST;
    }
    return self;
}

- (NSString *)requestURL {
    return @"base/game/getKaiFuList";
}

- (id)requestParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    params [@"member_id"] = userID;
    if (self.mainType.length > 0) {
        params[@"kf_type"] = self.mainType;
    }
    if (self.type.length>0) {
        params[@"game_species_type"] = self.type;
    }
    if (self.kf_start_time.length > 0)
    {
        params[@"kf_start_time"] = self.kf_start_time;
    }
    if (self.kaifu_date.length > 0)
    {
        params[@"kaifu_date"] = self.kaifu_date;
    }
    params[@"game_classify_id"] = self.game_classify_id;
    params[@"search_info"] = self.search_info;
    NSLog(@"类型A:%@ B:%@",self.type,self.mainType);
    params[@"pagination"] = @{@"page":[NSString stringWithFormat:@"%li",self.pageNumber],@"count":[NSString stringWithFormat:@"%li",self.count]};
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
