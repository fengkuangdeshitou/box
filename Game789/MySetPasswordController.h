//
//  MySetPasswordController.h
//  Game789
//
//  Created by Maiyou on 2020/1/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySetPasswordController : BaseViewController

@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, assign) BOOL isPwd;

@property (nonatomic, copy) void(^UmLoginSuccess)();

@end

NS_ASSUME_NONNULL_END
