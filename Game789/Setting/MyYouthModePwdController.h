//
//  MyYouthModePwdController.h
//  Game789
//
//  Created by Maiyou on 2021/3/20.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyYouthModePwdController : BaseViewController

@property (nonatomic, assign) BOOL isVerify;

@property (nonatomic, copy) void(^sureBtnBlock)(BOOL isVerify);

@end

NS_ASSUME_NONNULL_END
