//
//  SendFirstChargeCoverView.h
//  Game789
//
//  Created by Maiyou on 2018/11/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendFirstChargeCoverView : BaseView

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_top;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) UIViewController * currentVC;

@property (nonatomic, strong) NSDictionary * dataDic;
/** 是否为新人福利的弹窗   */
@property (nonatomic, assign) BOOL isNoviceFuli;
/** 是否为活动的弹窗  */
@property (nonatomic, assign) BOOL isActivity;
/** 是否为8-30  */
@property (nonatomic, assign) BOOL novice_fuli_eight_time;
/** 是否为30  */
@property (nonatomic, assign) BOOL novice_fuli_thirty_time;

// 点击回调
@property (nonatomic, copy) void(^ClickActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
