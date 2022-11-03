//
//  MyRecycleRecordsModel.h
//  Game789
//
//  Created by yangyongMac on 2020/2/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecycleRecordsModel : BaseModel

@property (nonatomic, copy) NSString *isRedeemed;
@property (nonatomic, copy) NSString *recycledAmount;
//将原来的金额改成金币添加的字段
@property (nonatomic, copy) NSString *recycledCoin;
@property (nonatomic, copy) NSString *recycledTime;
@property (nonatomic, copy) NSString *redeemEndTime;
@property (nonatomic, copy) NSString *redeemUrl;
@property (nonatomic, copy) NSString *redeemdAmount;
//将原来的金额改成金币添加的字段
@property (nonatomic, copy) NSString *redeemdCoin;
@property (nonatomic, copy) NSString *redeemedTime;
@property (nonatomic, strong) NSDictionary *game;
@property (nonatomic, strong) NSDictionary *alt;
@property (nonatomic, copy) NSString *nameRemark;


@end

NS_ASSUME_NONNULL_END
