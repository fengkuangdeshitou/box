//
//  GoldMallRequestAPI.h
//  Game789
//
//  Created by maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoldMallRequestAPI : BaseRequest

@property (nonatomic, copy) NSString *voucherType;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *voucherId;

@end

@interface GoldMallAPI : BaseRequest

@end

NS_ASSUME_NONNULL_END
