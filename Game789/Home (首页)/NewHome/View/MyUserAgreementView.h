//
//  MyUserAgreementView.h
//  Game789
//
//  Created by Maiyou on 2020/10/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "WebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserAgreementView : BaseView

//@property (weak, nonatomic) IBOutlet MLLinkLabel *showContent;
// 同意隐私政策和用户协议
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) WebView * web;
@property (nonatomic, copy) void(^agreeBtnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
