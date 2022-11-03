//
//  MySendVerifyCodeView.m
//  Game789
//
//  Created by Maiyou on 2020/4/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySendVerifyCodeView.h"
#import "GetMobileCodeApi.h"
#import "MyRecycleGameListApi.h"

@class MyTrumpetRedemptionApi;

@implementation MySendVerifyCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySendVerifyCodeView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.count = 60;
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        NSString * mobile = [dic objectForKey:@"mobile"];
        if (mobile.length == 11)
        {
            self.showSendMobile.text = [NSString stringWithFormat:@"已向您尾号%@的手机发送验证码", [mobile substringWithRange:NSMakeRange(7, 4)]];
        }
        else
        {
            self.showSendMobile.text = @"已向您手机发送验证码";
        }
        
        [self creatVerifyCodeView];
    }
    return self;
}

- (void)setCodeType:(NSString *)codeType
{
    _codeType = codeType;
    
    [self getCodeApiRequest];
}

- (void)creatVerifyCodeView
{
    JHVCConfig *config     = [[JHVCConfig alloc] init];
    config.inputBoxNumber  = 6;
//    config.leftMargin      = 0;
    config.inputBoxSpacing = 8.5;
    config.inputBoxWidth   = 28;
    config.inputBoxHeight  = 28;
    config.tintColor       = [UIColor blueColor];
    config.secureTextEntry = NO;
    config.inputBoxColor   = [UIColor clearColor];
    config.font            = [UIFont boldSystemFontOfSize:28];
    config.textColor       = [UIColor blackColor];
    config.inputType       = JHVCConfigInputType_Number;
    config.keyboardType    = UIKeyboardTypeNumberPad;
    
    config.inputBoxBorderWidth  = 1;
    config.showUnderLine = YES;
    config.underLineSize = CGSizeMake(33, 2);
    config.underLineColor = [UIColor colorWithHexString:@"#A7A7A7"];
    config.underLineHighlightedColor = [UIColor colorWithHexString:@"#A7A7A7"];

    config.underLineFinishColors = @[[UIColor colorWithHexString:@"#A7A7A7"],[UIColor colorWithHexString:@"#A7A7A7"]];
    config.finishFonts = @[[UIFont boldSystemFontOfSize:28], [UIFont systemFontOfSize:28]];
    config.finishTextColors = @[[UIColor blackColor], [UIColor blackColor]];
    
    JHVerificationCodeView *codeView1 =
    [[JHVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, self.codeView.width, self.codeView.height)
                                           config:config];
    if (!IS_IPHONE_Xs_Max)
    {
        codeView1.x = -20;
    }
    codeView1.finishBlock = ^(JHVerificationCodeView *codeView, NSString *code) {
        MYLog(@"最终输入结果：%@", code);
        self.codeStr = code;
    };
    codeView1.inputBlock = ^(NSString *code) {
        NSLog(@"当前输入code:%@", code);
    };
    [self.codeView addSubview:codeView1];
}

- (void)getCodeApiRequest
{
    GetMobileCodeApi *api = [[GetMobileCodeApi alloc] init];
    api.type = self.codeType;
    api.mobile = @"1";
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [self stopTimer];
    }];
}

- (void)handleNoticeSuccess:(GetMobileCodeApi *)api {
    if (api.success == 1) {
        [self startTimer];
        self.getMobile = api.data[@"mobile"];
//        [MBProgressHUD showToast:@"验证码发送成功" toView:self];
    }
    else {
        [self stopTimer];
        [MBProgressHUD showToast:api.error_desc toView:self];
    }
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    self.count = 60;
}

- (void)codeBtnChange
{
    if (self.count == 0)
    {
        [self stopTimer];

        self.sendCode.enabled = YES;
        [self.sendCode setTitle:@"收不到验证码".localized forState:UIControlStateNormal];
        self.showCodeTip.text = @"";
    }
    else
    {
        [self.sendCode setTitle:[NSString stringWithFormat:@"%lis", self.count--] forState:UIControlStateNormal];
        self.showCodeTip.text = @"后重新发送".localized;
        self.sendCode.enabled = NO;
    }
}

- (IBAction)sureAction:(id)sender
{
    [self checkVerifyCode];
}

- (IBAction)closeButtonClick:(id)sender
{
    [self removeFromSuperview];
}

- (void)checkVerifyCode
{
    if (!self.getMobile)  return;
    MyTrumpetRedemptionApi * api = [[MyTrumpetRedemptionApi alloc] init];
    api.code = self.codeStr;
    api.mobile = self.getMobile;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self removeFromSuperview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //验证码验证成功回掉
                if (self.CodeVerifySuccessBlock)
                {
                    self.CodeVerifySuccessBlock();
                }
            });
        }
        else
        {
            [MBProgressHUD showToast:@"验证码输入有误".localized toView:self];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self];
    }];
}

#pragma mark — 收不到验证码
- (IBAction)sendCodeButtonClick:(id)sender
{
    [self getCodeApiRequest];
}

@end
