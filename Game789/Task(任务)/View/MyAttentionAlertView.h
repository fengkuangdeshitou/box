//
//  MyAttentionAlertView.h
//  Game789
//
//  Created by Maiyou on 2020/10/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAttentionAlertView : BaseView

@property (weak, nonatomic) IBOutlet UIImageView *showTitleImage;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UITextField *enterCode;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxBtn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxBtn_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterCodeView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showBgImage_height;

@property (nonatomic, assign) BOOL isWx;
/** 是否是ua8x渠道或者子渠道   */
@property (nonatomic, assign) BOOL is_ua8x;
@property (nonatomic,copy) NSString * tips;

@property (nonatomic, copy) void(^exchangeCodeBlock)(BOOL isWx);

@end

NS_ASSUME_NONNULL_END
