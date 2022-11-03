//
//  SegmentTypeApi.h
//  Game789
//
//  Created by haierguook on 2018/7/31.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface SegmentTypeApi : BaseRequest

+(instancetype)sharedInstance;

@end


@interface GetActivityApi : BaseRequest


@end


//查询VIP有没有领取金币
@interface GetMiluVipCionsApi : BaseRequest

+ (instancetype)sharedInstance;

@end

//VIP领取金币
@interface ReceiveMiluVipCionsApi : BaseRequest

+ (instancetype)sharedInstance;

@end
