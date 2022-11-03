//
//  MyGameVoucherListTopView.h
//  Game789
//
//  Created by Maiyou on 2020/11/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

//#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameVoucherListTopView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) void(^monthCardClick)(void);

@end

NS_ASSUME_NONNULL_END
