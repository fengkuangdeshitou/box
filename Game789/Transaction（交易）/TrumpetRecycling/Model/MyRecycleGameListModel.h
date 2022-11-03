//
//  MyRecycleGameListModel.h
//  Game789
//
//  Created by yangyongMac on 2020/2/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecycleGameListModel : BaseModel

@property (nonatomic, strong) NSDictionary *img;
@property (nonatomic, copy) NSString *rechargedAmount;
@property (nonatomic, copy) NSString *recyclable;
@property (nonatomic, copy) NSString *recyclableAmount;
@property (nonatomic, copy) NSString *recyclableCoin;
@property (nonatomic, copy) NSString *type;
@property (nonatomic,copy) NSString * nameRemark;

@end

NS_ASSUME_NONNULL_END
