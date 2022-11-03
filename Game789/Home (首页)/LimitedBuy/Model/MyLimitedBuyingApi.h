//
//  MyLimitedBuyingApi.h
//  Game789
//
//  Created by Maiyou on 2021/1/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLimitedBuyingApi : BaseRequest

@end

@interface MyLimitedBuyReceivedApi : BaseRequest

@property (nonatomic, copy) NSString *receiveId;

@end

NS_ASSUME_NONNULL_END
