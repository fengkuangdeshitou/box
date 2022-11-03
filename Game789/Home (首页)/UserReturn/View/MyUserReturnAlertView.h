//
//  MyUserReturnAlertView.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnAlertView : BaseView

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *bgImageView;
@property (nonatomic, assign) NSInteger day;

// 点击领取
@property (nonatomic, copy) void(^receiveAction)();

@end

NS_ASSUME_NONNULL_END
