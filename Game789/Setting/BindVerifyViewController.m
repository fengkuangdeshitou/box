//
//  ForgotPwdViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BindVerifyViewController.h"
#import "registerApi.h"
#import "GetMobileCodeApi.h"
#import "BindMobileApi.h"
#import "GetUserInfoApi.h"
#import "MBProgressHUD+QNExtension.h"
#import "NSString+Phone.h"

@interface BindVerifyViewController ()

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet GameTextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) NSDictionary *memberDic;

@property (strong, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *showTips;

@end

@implementation BindVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = !self.isRebind ? @"解绑手机号" : @"验证原手机号";
    if (self.bandMobile) {
        self.userName.placeholder = [NSString stringWithFormat:@"请输入%@的手机号", self.bandMobile];
    }
    self.showTips.text = !self.isRebind ?  @"输入绑定的手机号码和验证码，点击确定解绑手机号" : @"输入绑定的手机号码和验证码，点击下一步进行绑定新的号码";
    [self.saveButton setTitle:!self.isRebind ?  @"确认解绑" : @"下一步" forState:0];
    
    [self.userName addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.isRegisterVC) {
        //带右侧跳过按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(kScreen_width-60, kStatusBarHeight, 50, 44);
        [rightBtn setTitle:@"跳过".localized forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [rightBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [rightBtn addTarget:self action:@selector(skipBind) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:rightBtn];
    }
    self.count = 60;
}

- (void)skipBind
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 绑定接口
// 绑定手机===保存
- (void)getBindApiRequest
{
    if (self.userName.text.length == 0 || self.code.text.length == 0) {
        return;
    }
    BindMobileApi *api = [[BindMobileApi alloc] init];
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    api.moblie = [NSString stringWithFormat:@"%@-%@",[YYToolModel getUserdefultforKey:@"member_info"][@"mobile_code"],self.userName.text];
    api.code   = self.code.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleBindSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleBindSuccess:(BindMobileApi *)api
{
    if (api.success == 1)
    {
        if (self.isRebind)
        {
            //跳转绑定新手机
            BindMobileViewController *changeVC = [[BindMobileViewController alloc]init];
            changeVC.isChange = YES;
            [self.navigationController pushViewController:changeVC animated:YES];
        }
        else
        {
            [MBProgressHUD showToast:@"解绑成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}


- (IBAction)bindMobilePress:(id)sender
{
     if (self.code.text.length > 0) {
        [self getBindApiRequest];
    }
}

- (IBAction)sendCodePress:(id)sender
{
    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入手机号码" toView:self.view];
        return;
    }
    [self getCodeApiRequest];
}

// 发送验证码
- (void)getCodeApiRequest
{
    GetMobileCodeApi *api = [[GetMobileCodeApi alloc] init];
    api.mobile = self.userName.text;
    api.type = @"07";
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

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

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

- (void)getUserInfoApiRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0) {
        GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
        api.isShow = YES;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            [self handleUserSuccess:api];
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

- (void)handleUserSuccess:(GetUserInfoApi *)api
{
    if (api.success == 1)
    {
        self.memberDic = api.data[@"member_info"];
        [[NSUserDefaults standardUserDefaults] setObject:self.memberDic forKey:@"member_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSetMemberInfoSuccess" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];  //绑定成功返回
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)textFieldValueChanged:(UITextField *)textField
{
    if (textField.text.length == 11)
    {
        [self.code becomeFirstResponder];
    }
}

@end
