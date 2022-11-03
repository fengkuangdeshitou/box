//
//  MyTaskViewController.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskViewController : BaseViewController

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, copy) void(^signBlock)(void);

@end

NS_ASSUME_NONNULL_END
