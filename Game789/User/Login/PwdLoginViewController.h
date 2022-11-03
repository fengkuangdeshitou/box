//
//  LoginViewController.h
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

@interface PwdLoginViewController : BaseViewController

/**  是否需要重新登录  */
@property (nonatomic, assign) BOOL isRelogin;

@property (nonatomic, assign) BOOL isGameDetail;

// sdk快速登录的回传
@property (nonatomic, copy) void(^quickLoginBlock)(void);

@end
