//
//  MyTrumpetRecyclingModel.h
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTrumpetRecyclingModel : BaseModel

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *altUsername;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSDictionary *game;
@property (nonatomic, copy) NSString *rechargedAmount;
@property (nonatomic, copy) NSString *recycledAmount;
@property (nonatomic, copy) NSString *recycledCoin;

@end

NS_ASSUME_NONNULL_END
