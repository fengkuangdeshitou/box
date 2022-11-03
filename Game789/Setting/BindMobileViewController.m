//
//  ForgotPwdViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BindMobileViewController.h"
#import "registerApi.h"
#import "GetMobileCodeApi.h"
#import "BindMobileApi.h"
#import "GetUserInfoApi.h"
#import "MBProgressHUD+QNExtension.h"
#import "NSString+Phone.h"
#import "AreaViewController.h"

@interface BindMobileViewController ()<AreaViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet GameTextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) NSDictionary *memberDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entermobile_top;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *countryCode;

@property (strong, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;

@end

@implementation BindMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = self.isChange ? @"更换手机号" : @"绑定手机号";

    if (self.isRegisterVC) {
        //带右侧跳过按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(kScreen_width-60, kStatusBarHeight, 50, 44);
        [rightBtn setTitle:@"跳过".localized forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [rightBtn setTitleColor:FontColor66 forState:0];
        [rightBtn addTarget:self action:@selector(skipBind) forControlEvents:UIControlEventTouchUpInside];
        [self.navBar addSubview:rightBtn];
    }
    self.count = 60;
    self.entermobile_top.constant = kStatusBarAndNavigationBarHeight + 30;
    
    NSString * code = [YYToolModel getUserdefultforKey:AREA_CODE];
    [self.countryCode setTitle:code == NULL ? @"86" : code forState:0];
    [self.countryCode layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

#pragma mark - 跳过
- (void)skipBind
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 绑定手机
- (void)getBindApiRequest
{
    if (self.userName.text.length == 0||self.code.text.length == 0) {
        return;
    }
    BindMobileApi *api = [[BindMobileApi alloc] init];
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    api.moblie = [NSString stringWithFormat:@"%@-%@",self.countryCode.titleLabel.text,self.userName.text];
    api.code = self.code.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleBindSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleBindSuccess:(BindMobileApi *)api
{
    if (api.success == 1)
    {
        [MBProgressHUD showToast:self.isChange ? @"手机号更换成功" : @"手机号绑定成功" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
//        [self getUserInfoApiRequest];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

#pragma mark - 选择国家或者地址代码
- (IBAction)selectCountryCodeClick:(id)sender
{
    AreaViewController * area = [[AreaViewController alloc] init];
    area.delegate = self;
    [self.navigationController pushViewController:area animated:YES];
}

- (void)onSelectedArea:(NSDictionary *)area
{
    [self.countryCode setTitle:area[@"phoneCode"] forState:UIControlStateNormal];
    [self.countryCode layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

#pragma mark - 点击绑定
- (IBAction)bindMobilePress:(id)sender {

    if (self.code.text.length > 0) {
        [self getBindApiRequest];
    }
}

#pragma mark - 发送验证码
- (IBAction)sendCodePress:(id)sender
{
    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入手机号码" toView:self.view];
        return;
    }
    [self getCodeApiRequest];
}

- (void)getCodeApiRequest
{
    GetMobileCodeApi *api = [[GetMobileCodeApi alloc] init];
    api.mobile = self.userName.text;
    api.type = @"02";
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleNoticeSuccess:(GetMobileCodeApi *)api
{
    if (api.success == 1)
    {
        [self startTimer];
        [MBProgressHUD showToast:@"验证码发送成功" toView:self.view];
    }
    else
    {
        [self stopTimer];
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}
- (void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }

    self.count = 60;
}

- (void)codeBtnChange
{
    if (self.count == 0)
    {
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
