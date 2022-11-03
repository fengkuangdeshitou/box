//
//  PwdLoginViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "LoginViewController.h"
#import "MyUserViewController.h"
#import "MySetPasswordController.h"
#import "PwdLoginViewController.h"
#import "AreaViewController.h"
#import "LoginApi.h"
#import "UMModelCreate.h"
#import "MyUmLoginApi.h"
#import "GetMobileCodeApi.h"
#import "MySetPasswordApi.h"
@class VerifyCodeLoginApi;
@class TickLoginApi;
@class GetCountryCodeApi;

@interface LoginViewController ()<AreaViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *userPwd;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginImage_height;
@property (weak, nonatomic) IBOutlet UIButton *sureLogin;
@property (weak, nonatomic) IBOutlet UIButton *umLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImg_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *countryCode;

@property (nonatomic,strong) UIView *coverView;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *codeStr;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self showLoginImage];
    
    [self initUmLoginParma];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入登录页面
    [MyAOPManager relateStatistic:@"LoginViewAppear" Info:@{}];
    
}

- (void)prepareBasic
{
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.lineView.hidden = YES;
    self.navBar.title = @"验证码登录";
    self.bottomView_bottom.constant = kTabbarSafeBottomMargin + 20;
    self.umLogin.hidden = YES;
    self.logoImg_top.constant = kStatusBarAndNavigationBarHeight + 70;
    self.count = 60;
    
    NSString * code = [YYToolModel getUserdefultforKey:AREA_CODE];
    [self.countryCode setTitle:code == NULL ? @"86" : code forState:0];
    [self.countryCode layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    NSDictionary * dic = [DeviceInfo shareInstance].data;
    self.flagButton.selected = [dic[@"agreeChecked"] boolValue];
    
    WEAKSELF
    [self.navBar setOnClickLeftButton:^{
        [weakSelf backAction:YES];
    }];
    [self.navBar wr_setRightButtonWithTitle:@"密码登录" titleColor:FontColor66];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.navBar.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.navBar setOnClickRightButton:^{
        PwdLoginViewController * login = [PwdLoginViewController new];
        [weakSelf.navigationController pushViewController:login animated:YES];
    }];
    
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    coverView.backgroundColor = [UIColor whiteColor];
//    coverView.hidden = YES;
    [self.view addSubview:coverView];
    self.coverView = coverView;
}

- (void)backAction:(BOOL)isBack
{
    if (self.isRelogin)
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MyUserViewController class]]) {
                MyUserViewController * vc = (MyUserViewController *)controller;
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
    else if (isBack)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self getUserInfoApiRequest];
    }
}

#pragma mark — 验证一键登录SDK
- (NSString *)getVerifySDKInfo
{
    NSString * info = @"";
    NSInteger channelTag = [DeviceInfo shareInstance].channelTag.integerValue;
    if ([DeviceInfo shareInstance].isGameVip)
    {
        if (channelTag == 0 || channelTag == 1)
        {
            info = @"lwaVSrHAtmLEVGxhcDRzOQDcR/+jkPiOLBsZuTumwm/dr0te1tGuhcOJF3dnP/wWz3w10GX9nGBYDU/dQ7WJ4+h0aiSBpM1i+zH8uC0kBqENVIpDOf2TgCQChME30v0SD05cWv23GP0Js/npOG0XsBh7sfl3CNgmGkWfLdqZMJ6MtewiPhu5G+p0KVU6Z6vqZA0qiZ6pZo4afmDLi+yHiXQA9onzIVG+rWdNpMSA/2HWN88ZeYePMw==";
        }
        else if (channelTag == 2)
        {
            info = @"44usBVU8CtLRL44S+uNQmDUNLl2csOu9JpYKXp4wQLBuv97aLotCue8LVa3sdDEnEcnCbUtrD4C+xwuukNvTGvBLCH+3m6ZbYC3oYjpTs7C4/8XNW/GhVI/n0TeqBtxBHpucC6uIgy21e4tZLGw3rA1xJUtWn6mMKJ3GZ3MxsMVaUhsxCCH1VO29goJXRD55y9Q6uzl8+1uP/mj9gYbDAnkzoSiPp3pkAwChHs1m01C3Lv115z0QG4iEHCCqnXLUUrFYNXi2JMg=";
        }
        else if (channelTag == 3)
        {
            info = @"x3sGLxMzLeuD0qLLavm+VYKTrVTg6rGjR2grYjoUODph3JoLUguyZ10cVdx5pXbJtMOidv4F70ICFRqMdvIZhRLvM1S4XF6a0ySz13BvB6IsiqvcP73csyKmo45axhxYwZNno+09gtTOB28qrM3vzLWSpkD8BDpd4KW9Om+ArQkwnA4kH5r1tR9BneD/s/wcZDYMKYFgS0/GoDuMuIVIhp/QFI1xjMSmpZWcCwHME/ao1mBCuZgtkQ==";
        }
    }
    else
    {
        if (channelTag == 0 || channelTag == 1)
        {
            if ([DeviceInfo shareInstance].isTFSigin)//tf签名
            {
                info = @"dLdJeo5jWpceZ8k4dFDZd7Pxr2c5SUgnZFSLsdn6DVirHD+EpZyvfZDY1hsXf4NcPxy1TJL5ad0LaRgRQ9/IBJLVl2vv9HN269jCwcEbGX7r4aCXnOzCkQ4yCTDYe+IM66nX5jjlLohiedi2ZQGMnv9p9YUPJe5HRWiQtuyKPpwU6AWni6YWfSSqUYm3mZl1Hxi6WZZqGrCTOx7ONMF0dwcFn4UFy1vi0nl857xSB35xlk2Df6/9PNCKx+eGt0rvzHUgOO82cC2J2o9FQzeKCA==";
                if ([DeviceInfo shareInstance].TFSiginVerifyKey)
                {
                    info = [DeviceInfo shareInstance].TFSiginVerifyKey;
                }
            }
            else
            {
                info = @"JZQRMiYA65cdE2q/Jl7W/c0oLaZzYdBgINpAb5tki6+wx5ptyGJBopngJiC99TPF4X3fUstl3V7dNkeKjqcddpmsBVzB6oqT516eqMPZmQCh5lAXJkrHJlGxnBqoCto7sYhwdUqPKRdiIj2FrDnBBKdeXlfGV4Wx2CRKB1H9Bdt+o+V8CGNAEuf8lQUAZg+DDI88LloT1MLNgGf+FD9mDG0RHJR9ebgM/eX5fTTGkqS7gMQArMbaDBhJnrnQscEb3la5g8dzPUg=";
            }
        }
        else if (channelTag == 2)
        {
            info = @"44usBVU8CtLRL44S+uNQmDUNLl2csOu9JpYKXp4wQLBuv97aLotCue8LVa3sdDEnEcnCbUtrD4C+xwuukNvTGvBLCH+3m6ZbYC3oYjpTs7C4/8XNW/GhVI/n0TeqBtxBHpucC6uIgy21e4tZLGw3rA1xJUtWn6mMKJ3GZ3MxsMVaUhsxCCH1VO29goJXRD55y9Q6uzl8+1uP/mj9gYbDAnkzoSiPp3pkAwChHs1m01C3Lv115z0QG4iEHCCqnXLUUrFYNXi2JMg=";
        }
        else if (channelTag == 3)
        {
            info = @"Cm0byk8PmqM47J8O9P/s0M2PX2iLsEkHE19W5RISQezvh9WITHu9jdoLcjprAV3w5ZCngtEOl5w428v2ehhaUKqC/5n/u9GAlYQegDC58hwC9V/ni4Et7rs3KfRcoVCoPkZ/h6Op0+t10DmlgQUPELGLwciKwQiyZZAwNQBRz9xNfb8mUgheFRxxreavR0GAIw1CwnmAOyav7yIgM4sJy1QPCB5fyDqDolI4Jb46px6TOVf0hl7iWA==";
        }
    }
    return info;
}

- (void)initUmLoginParma
{
    //设置秘钥
    [UMCommonHandler setVerifySDKInfo:[self getVerifySDKInfo] complete:^(NSDictionary * _Nonnull resultDic) {
        MYLog(@"resultDic : %@", resultDic);
        if ([resultDic[@"resultCode"] integerValue] == 600000)
        {
            [self oneClickLogin:YES];
            self.umLogin.hidden = NO;
        }
        else
        {
            self.coverView.hidden = YES;
            self.umLogin.hidden = YES;
        }
    }];
}

- (void)showLoginImage
{
    NSString * agent = [[DeviceInfo shareInstance] getFileContent:@"TUUChannel"];
    UIImage * image = [UIImage imageNamed:agent];
    UIImage * defaultImage = [UIImage imageNamed:@"login_milu_logo"];
    self.loginImg.image = image ? : defaultImage;
}

#pragma mark 获取用户信息
- (void)getUserInfoApiRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0) {
        GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
        
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
        NSDictionary * dic = api.data[@"member_info"] ;
        [YYToolModel saveUserdefultValue:dic[@"member_name"] forKey:@"user_name"];
        [YYToolModel saveUserdefultValue:[dic deleteAllNullValue] forKey:@"member_info"];
        //新人福利
        [DeviceInfo shareInstance].timeout = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_v2101_expire_time = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_v2101_show = [dic[@"novice_fuli_v2101_show"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_eight_time = [dic[@"is_show_reg_between_8day_30day"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_thirty_time = [dic[@"is_show_reg_gt_30day"] integerValue];
        [DeviceInfo shareInstance].reg_gt_30day_url = dic[@"reg_gt_30day_url"];
        [YYToolModel saveUserdefultValue:dic[@"mobile_code"] forKey:AREA_CODE];
        
        [self loginSuccessBack];
    }
    else
    {
        [self loginSuccessBack];
    }
}

- (void)loginSuccessBack
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController * vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[LoginViewController class]])
        {
            [array removeObject:vc];
        }
    }
    self.navigationController.viewControllers = array;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取验证码
- (IBAction)getVerifyCodeClick:(id)sender
{
    [self getCodeApiRequest];
}

- (void)getCodeApiRequest
{
    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入手机号码" toView:self.view];
        return;
    }
    GetMobileCodeApi *api = [[GetMobileCodeApi alloc] init];
    api.type = @"08";
    api.mobile = [NSString stringWithFormat:@"%@-%@",self.countryCode.titleLabel.text,self.userName.text];
    api.isShow = YES;
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

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
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

#pragma mark --点击登录
- (IBAction)loginPress:(id)sender
{
    [self.view endEditing:YES];
    
    [self loginRequest];
}

#pragma mark -- 登录请求
- (void)loginRequest
{
    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入手机号" toView:self.view];
        return;
    }
    
    if (self.userPwd.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入验证码" toView:self.view];
        return;
    }
    
    if (!self.flagButton.selected)
    {
        [MBProgressHUD showToast:@"请阅读并同意用户协议和隐私政策" toView:self.view];
        return;
    }
    
    VerifyCodeLoginApi *api = [[VerifyCodeLoginApi alloc] init];
    api.mobile = [NSString stringWithFormat:@"%@-%@",self.countryCode.titleLabel.text,self.userName.text];
    api.code = self.userPwd.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleLoginInSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleLoginInSuccess:(VerifyCodeLoginApi *)api
{
    if (api.success == 1)
    {
        [MyAOPManager relateStatistic:@"RegisterSuccess" Info:@{@"type":@"手机号验证码"}];
        NSArray * list = api.data[@"users"];
        if (list.count > 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
                [self selectUsername:list Type:YES];
            });
        }
        else
        {
            if ([api.data[@"isSetPassword"] boolValue])
            {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:api.data];
                [dic setValue:api.data[@"user_id"] forKey:@"id"];
                [self saveData:dic username:api.data[@"username"] Password:[self getUmLoginPassword:api.data]];
                //获取当前用户信息
                [self getUserInfoApiRequest];
            }
            else
            {
                [YYToolModel saveUserdefultValue:api.data[@"token"] forKey:TOKEN];
                [self goToSetPassword:api.data Type:YES];
            }
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

#pragma mark - 验证码登录多个账号选择账号登录
- (void)selectUsernameTickLogin:(NSDictionary *)dic
{
    TickLoginApi *api = [[TickLoginApi alloc] init];
    api.username = dic[@"username"];
    api.tick = dic[@"tick"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"登录成功" inview:self.view];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:api.data];
            [dic setValue:api.data[@"user_id"] forKey:@"id"];
            [self saveData:dic username:self.userName.text Password:self.userPwd.text];

            [self backAction:NO];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)saveData:(NSDictionary *)dic username:(NSString *)username Password:(NSString *)password
{
    if ([dic[@"is_unset_del_user"] boolValue]) {
        [MBProgressHUD showToast:@"账号注销流程终止，需申请注销后180天内未登录才可注销成功" toView:UIApplication.sharedApplication.keyWindow];
    }
    [[NSUserDefaults standardUserDefaults] setValue:dic[@"token"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setValue:dic[@"id"] forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"user_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSArray * array = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
//    NSDictionary * loginDic = @{@"myName":username, @"myPwd":password};
//    //存储登录过的账号
//    if (array == NULL)//若之前没有存储,则存当前账号
//    {
//        [YYToolModel saveUserdefultValue:@[loginDic] forKey:@"myOtherAccount"];
//    }
//    else//若之前有存储别的账号,则添加该账号
//    {
//        NSMutableArray * addArray = [NSMutableArray arrayWithArray:array];
//        if (![array containsObject:loginDic])
//        {
//            [addArray insertObject:loginDic atIndex:0];
//        }
//        else//添加登录的该账号
//        {
//            NSInteger index = [array indexOfObject:loginDic];
//            if (index != 0)//如果该账号不在首位,则与0交换
//            {
//                [addArray exchangeObjectAtIndex:index withObjectAtIndex:0];
//            }
//        }
//        [YYToolModel saveUserdefultValue:addArray forKey:@"myOtherAccount"];
//    }
//    
//    //将账号密码分享到制定粘贴板
//    NSString * copyStr = [NSString stringWithFormat:@"'%@','%@'", username, self.password.text];
//    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:SaveUserLoginAccount create:YES];
//    pasteboard.string = copyStr;
//
//    //复制账号适配老版本
//    UIPasteboard *pasteboard1 = [UIPasteboard pasteboardWithName:@"SaveUserLoginAccount" create:YES];
//    pasteboard1.string = copyStr;
    
    //SDK快速登录，盒子没有登录，登录后传参数给SDK
    if (self.quickLoginBlock)
    {
        self.quickLoginBlock();
    }
    
    //在未登录情况下，游戏详情点击领取代金券，从新登陆后刷新当前代金券数据
    if (self.isGameDetail)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGameDetailData" object:nil];
        });
    }
    //切换账号重新刷新赚金页面的数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginReloadUrl" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotice object:nil];
    });
    //统计登录完成
    [MyAOPManager relateStatistic:@"LoginSuccess" Info:@{@"type":@"手机号验证码"}];
    
}

#pragma mark — 一键登录
- (IBAction)oneClickLoginAction:(id)sender
{
    [self oneClickLogin:YES];
}

- (void)oneClickLogin:(BOOL)isHud
{
    WEAKSELF
    if (isHud)
    {
        [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    }
    //1. 调用check接口检查及准备接口调用环境
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO)
        {
            [MBProgressHUD hideHUDForView:self.view];
            self.umLogin.hidden = YES;
            self.coverView.hidden = YES;
            MYLog(@"check 接口检查失败，环境不满足");
            return;
        }
        else
        {
            self.umLogin.hidden = NO;
        }
        
        //2. 调用取号接口，加速授权页的弹起
        [UMCommonHandler accelerateLoginPageWithTimeout:3.0 complete:^(NSDictionary * _Nonnull resultDic)
        {
            if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
                [MBProgressHUD hideHUDForView:self.view];
                self.umLogin.hidden = YES;
                self.coverView.hidden = YES;
                MYLog(@"取号，加速授权页弹起失败");
                return ;
            }
            
            //3. 调用获取登录Token接口，可以立马弹起授权页
            UMCustomModel *model = [UMModelCreate createFullScreen];
            model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
            [UMCommonHandler getLoginTokenWithTimeout:3.0 controller:weakSelf model:model complete:^(NSDictionary * _Nonnull resultDic)
            {
                [MBProgressHUD hideHUDForView:self.view];
                NSString *code = [resultDic objectForKey:@"resultCode"];
                if ([PNSCodeLoginControllerPresentSuccess isEqualToString:code]) {
                    MYLog(@"弹起授权页成功");
                } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
                    MYLog(@"点击了授权页的返回");
                    self.coverView.hidden = YES;
                } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
                    MYLog(@"点击切换其他登录方式按钮");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.coverView.hidden = YES;
                        [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
                    });
                } else if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]) {
                    if ([[resultDic objectForKey:@"isChecked"] boolValue] == YES) {
                        MYLog(@"点击了登录按钮，check box选中，SDK内部接着会去获取登陆Token");
                    } else {
                        MYLog(@"点击了登录按钮，check box选中，SDK内部不会去获取登陆Token");
                        [MBProgressHUD showToast:@"请阅读并同意用户协议和隐私政策" toView:[UIApplication sharedApplication].keyWindow];
                    }
                } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) {
                    MYLog(@"点击check box");
                } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:code]) {
                    MYLog(@"点击了协议富文本");
                } else if ([PNSCodeSuccess isEqualToString:code]) {
                    //点击登录按钮获取登录Token成功回调
                    NSString *token = [resultDic objectForKey:@"token"];
                    //拿Token去服务器换手机号
                    [self umLogin:token];
                }
                else
                {
                    self.umLogin.hidden = YES;
                    self.coverView.hidden = YES;
                    [MBProgressHUD showError:@"获取登录Token失败"];
                }
            }];
        }];
    }];
}

- (void)umLogin:(NSString *)token
{
    NSString * appKey = @"";
    appKey = [DeviceInfo shareInstance].umAppkey;
    MyUmLoginApi * api = [[MyUmLoginApi alloc] init];
    api.token = token;
    api.appkey = appKey;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [MyAOPManager relateStatistic:@"LoginSuccess" Info:@{@"type":@"一键登录"}];
            NSArray * list = request.data[@"users"];
            if (list.count > 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
                    [self selectUsername:list Type:NO];
                });
            }
            else if (list.count == 1)
            {
                NSDictionary * dic = list[0];
                if ([dic[@"isSetPassword"] boolValue])
                {
                    [self saveData:dic username:dic[@"username"] Password:[self getUmLoginPassword:dic]];
                    //获取当前用户信息
                    [self getUserInfoApiRequest];
                    [self dismissLoginVC];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];

                        [self goToSetPassword:dic Type:NO];
                    });
                }
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:[UIApplication sharedApplication].delegate.window];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark ——— 一键登录获取密码
- (NSString *)getUmLoginPassword:(NSDictionary *)dic
{
    if (dic && dic[@"tick"])
    {
        NSString * pwd = [dic[@"tick"] aci_decryptWithAES];
        return pwd;
    }
    return @"";
}

#pragma mark — 退出一键登录页面和登录页面
- (void)dismissLoginVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
        
        [self loginSuccessBack];
    });
}

#pragma mark — 设置密码
- (void)goToSetPassword:(NSDictionary *)dic Type:(BOOL)isCode
{
    MySetPasswordController * pwd = [MySetPasswordController new];
    pwd.dataDic = dic;
    pwd.isPwd = isCode;
    pwd.hidesBottomBarWhenPushed = YES;
    pwd.UmLoginSuccess = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        //SDK快速登录，盒子没有登录，登录后传参数给SDK
        if (self.quickLoginBlock)
        {
            self.quickLoginBlock();
        }
    };
    [self.navigationController pushViewController:pwd animated:YES];
    
    //删除登录页面
    NSMutableArray *ControllersmArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in ControllersmArr)
    {
        if ([vc isKindOfClass:[self class]])
        {
            [ControllersmArr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = ControllersmArr;
}

#pragma mark — 多个小号选择
- (void)selectUsername:(NSArray *)array Type:(BOOL)isCode
{
    NSMutableArray * titleArray = [NSMutableArray array];
    for (NSDictionary * dic in array)
    {
        [titleArray addObject:dic[@"username"]];
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择要登录的账户" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < array.count; i ++)
    {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MYLog(@"===============%@", action.title);
            NSInteger index = [titleArray indexOfObject:action.title];
            NSDictionary * dic = array[index];
            if (isCode)
            {
                [self selectUsernameTickLogin:dic];
            }
            else
            {
                [dic[@"isSetPassword"] boolValue] ? [self umSelectUsernameLogin:dic] : [self goToSetPassword:dic Type:isCode];
            }
        }];
        [actionSheet addAction:action1];
    }
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [actionSheet addAction:action3];
    
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark — 选择了小号登录
- (void)umSelectUsernameLogin:(NSDictionary *)dic
{
    MySetPasswordApi * api = [[MySetPasswordApi alloc] init];
    api.username = dic[@"username"];
    api.token = dic[@"token"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self saveData:request.data username:dic[@"username"] Password:[self getUmLoginPassword:dic]];
            [self.navigationController popViewControllerAnimated:YES];
            [self getUserInfoApiRequest];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc  toView:[UIApplication sharedApplication].delegate.window];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:api.error_desc  toView:[UIApplication sharedApplication].delegate.window];
    }];
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

#pragma mark - 同意
- (IBAction)flagButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - 用户协议
- (IBAction)userProtocolClick:(id)sender
{
    WebViewController * web = [WebViewController new];
    web.urlString = LoginUserAgreementUrl;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 隐私政策
- (IBAction)pricacyAgreementClick:(id)sender
{
    WebViewController * web = [WebViewController new];
    web.urlString = LoginPrivacyPolicyUrl;
    [self.navigationController pushViewController:web animated:YES];
}

@end
