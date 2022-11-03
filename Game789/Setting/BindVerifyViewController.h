//
//  ForgotPwdViewController.h
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

@interface BindVerifyViewController : BaseViewController

@property (assign, nonatomic) BOOL isRegisterVC;

@property (nonatomic, copy) NSString * bandMobile;
/**  是否为换绑  */
@property (nonatomic, assign) BOOL isRebind;

@end
