//
//  ForgotPwdViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "registerApi.h"
#import "GetMobileCodeApi.h"
#import "MBProgressHUD+QNExtension.h"
#import "NSString+Phone.h"
#import "ForgotPwdApi.h"
#import "AreaViewController.h"

@interface ForgotPwdViewController ()<AreaViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet GameTextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_top;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *countryCode;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *codeStr;


@end

@implementation ForgotPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = @"忘记密码";
    self.count = 60;
    
    self.userName_top.constant = kStatusBarAndNavigationBarHeight + 30;
    
    NSString * code = [YYToolModel getUserdefultforKey:AREA_CODE];
    [self.countryCode setTitle:code == NULL ? @"86" : code forState:0];
    [self.countryCode layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.count = 60;
}
- (void)codeBtnChange {

    if (self.count == 0) {
        [self stopTimer];

        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"发送验证码".localized forState:UIControlStateNormal];
        return;
    }
    [self.sendBtn setTitle:[NSString stringWithFormat:@"%lis%@",self.count--, @"后重试".localized] forState:UIControlStateNormal];
    self.sendBtn.enabled = NO;
}

#pragma mark - 选择国家或者地址代码
- (IBAction)selectCountryCodeClick:(id)sender
{
    AreaViewController * area = [[AreaViewController alloc] init];
    area.delegate = self;
    [self.navigationController pushViewController:area animated:YES];
}

- (void)onSelectedArea:(NSDictionary *)area{
    [self.countryCode setTitle:area[@"phoneCode"] forState:UIControlStateNormal];
    [self.countryCode layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

- (void)getCodeApiRequest
{
    if (self.userName.text.length == 0) {
        [MBProgressHUD showToast:@"请输入手机号码" toView:self.view];
        return;
    }
    GetMobileCodeApi *api = [[GetMobileCodeApi alloc] init];
    api.type = @"03";
    api.mobile = [NSString stringWithFormat:@"%@-%@",self.countryCode.titleLabel.text,self.userName.text];
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (void)handleNoticeSuccess:(GetMobileCodeApi *)api {
    if (api.success == 1) {
        [self startTimer];
        [MBProgressHUD showToast:@"验证码发送成功" toView:self.view];

    }
    else {
        [self stopTimer];
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (IBAction)sureToRegister:(id)sender {
     [self forGotPwdRequest];
}

- (IBAction)registerPress:(id)sender {
    [self getCodeApiRequest];
}

- (IBAction)showPwdBtnClick:(id)sender {
    UIButton * button = sender;
    button.selected = !button.selected;
    self.passWord.secureTextEntry = !button.selected;
}

#pragma mark -- Login Logic --

- (void)forGotPwdRequest {

    if (self.userName.text.length == 0 || self.passWord.text.length == 0 || self.code.text.length == 0) {
        return;
    }
    if (self.userName.text.length == 0 || self.passWord.text.length == 0) {
        [MBProgressHUD showToast:@"请输入完整的用户信息" toView:self.view];
        return;
    }
    if (self.code.text.length == 0) {
        [MBProgressHUD showToast:@"请输入验证码" toView:self.view];
        return;
    }
//    if (![self.code.text isEqualToString:self.codeStr]) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"验证码错误";
//        hud.mode = MBProgressHUDModeText;
//        [hud hideAnimated:YES afterDelay:1.0];
//        return;
//    }

    ForgotPwdApi *api = [[ForgotPwdApi alloc] init];
    api.mobile = [NSString stringWithFormat:@"%@-%@",self.countryCode.titleLabel.text,self.userName.text];
    api.newpassword = self.passWord.text;
    api.code = self.code.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleRegiterSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)handleRegiterSuccess:(ForgotPwdApi *)api {
    if (api.success == 1) {
        [YJProgressHUD showSuccess:@"修改成功" inview:self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
    }
    else
    {
//        [self startTimer];
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
