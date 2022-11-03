//
//  MySendVerifyCodeView.h
//  Game789
//
//  Created by Maiyou on 2020/4/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "JHVerificationCodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySendVerifyCodeView : BaseView
{
    NSTimer * _timer;
}

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *sendCode;
@property (weak, nonatomic) IBOutlet UILabel *showCodeTip;
@property (weak, nonatomic) IBOutlet UILabel *showSendMobile;

// 验证码验证成功返回
@property (nonatomic, copy) void(^CodeVerifySuccessBlock)(void);
@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) NSString * codeStr;
@property (copy, nonatomic) NSString * getMobile;
// 05 小号回收 06 小号交易
@property (copy, nonatomic) NSString * codeType;

@end

NS_ASSUME_NONNULL_END
