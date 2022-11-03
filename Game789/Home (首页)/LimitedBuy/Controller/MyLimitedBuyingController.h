//
//  MyLimitedBuyingController.h
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLimitedBuyingController : BaseViewController

@property (nonatomic, copy) void(^receivedActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
