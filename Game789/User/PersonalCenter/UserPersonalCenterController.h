//
//  UserPersonalCenterController.h
//  Game789
//
//  Created by Maiyou on 2018/10/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"


@interface UserPersonalCenterController : BaseViewController

@property (nonatomic, copy) NSString * user_id;
/**  是否隐藏设置按钮  */
@property (nonatomic, assign) BOOL  isHiddenBtn;

@end

