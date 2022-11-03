//
//  LoginViewController.m
//  Game789
//
//  Created by yangyong on 2021/09/14.
//  Copyright © 2021年 yangyong. All rights reserved.
//

#import "PwdLoginViewController.h"

#import "MyUserViewController.h"
#import "RegisterViewController.h"
#import "ForgotPwdViewController.h"
#import "MySetPasswordController.h"
#import "LoginViewController.h"
#import "KDGOtherAccountCell.h"

#import "LoginApi.h"
#import "UMModelCreate.h"
#import "MyUmLoginApi.h"
#import "MySetPasswordApi.h"

static CGFloat rowHeight = 44;

@interface PwdLoginViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *userPwd;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginImage_height;
@property (weak, nonatomic) IBOutlet UIButton *sureLogin;
@property (weak, nonatomic) IBOutlet UIButton *umLogin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImg_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *dropDown;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * valueArray;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) UIView * coverView;

@end

@implementation PwdLoginViewController

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
    //显示当前存储的账号
    NSArray * array = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
    if (array != NULL && array.count > 0)
    {
        NSDictionary * dic = array[0];
        self.userName.text = dic[@"myName"];
        self.userPwd.text  = dic[@"myPwd"];
    }
}

- (void)prepareBasic
{
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.lineView.hidden = YES;
    self.navBar.title = @"账号密码登录";
    self.bottomView_bottom.constant = kTabbarSafeBottomMargin + 20;
    self.umLogin.hidden = YES;
    self.logoImg_top.constant = kStatusBarAndNavigationBarHeight + 70;
    
    NSDictionary * dic = [DeviceInfo shareInstance].data;
    self.flagButton.selected = [dic[@"agreeChecked"] boolValue];
    
//    WEAKSELF
//    [self.navBar setOnClickLeftButton:^{
//        [weakSelf backAction:YES];
//    }];
//    [self.navBar wr_setRightButtonWithTitle:@"验证码登录" titleColor:FontColor66];
//    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    self.navBar.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    [self.navBar setOnClickRightButton:^{
//        [weakSelf.navigationController pushViewController:[PwdLoginViewController new] animated:YES];
//    }];
    
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.hidden = YES;
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


#pragma mark lazy loading...
- (UITableView *)tableView
{
    if (!_tableView)
    {
        self.valueArray = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lineView.frame) + 0.5, kScreenW - 30, self.valueArray.count * rowHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = rowHeight;
        _tableView.hidden = YES;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (self.valueArray.count > 4)
            _tableView.height = 4 * rowHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark ------ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.valueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"KDGOtherAccountCell";
    KDGOtherAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"KDGOtherAccountCell" owner:self options:nil].lastObject;
    }
    cell.showUserName.text = self.valueArray[indexPath.row][@"myName"];
    [cell.deleteUserName addTarget:self action:@selector(deleteUserNameAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteUserName.tag = indexPath.row;
    return cell;
}

#pragma mark ------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self rotateImage:self.dropDown];
    
    NSDictionary * dic = self.valueArray[indexPath.row];
    self.userName.text = dic[@"myName"];
    self.userPwd.text = dic[@"myPwd"];
}

#pragma mark ---- 删除存储的账号
- (void)deleteUserNameAction:(UIButton *)sender
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.valueArray];
    [array removeObjectAtIndex:sender.tag];
    self.valueArray = array;
    
    (self.valueArray.count > 4) ? (self.tableView.height = 4 * rowHeight) : (self.tableView.height = self.valueArray.count * rowHeight);
    [self.tableView reloadData];
    
    [YYToolModel saveUserdefultValue:self.valueArray forKey:@"myOtherAccount"];
}

#pragma mark — 下拉显示历史账号密码
- (IBAction)dropDownSelectAccountLoginClick:(id)sender
{
    [self rotateImage:sender];
}

#pragma mark — 显示隐藏密码
- (IBAction)showPwdBtnClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !button.selected;
    self.userPwd.secureTextEntry = !button.selected;
}

/**  旋转下拉  */
- (void)rotateImage:(UIButton *)dropDown
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.hidden = self.isOpen;
    }];
    
    if (!self.isOpen)
    {
        [UIView animateWithDuration:0.3 animations:^{
            dropDown.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        self.isOpen = YES;
        
        [self.view endEditing:YES];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            dropDown.imageView.transform = CGAffineTransformIdentity;
        }];
        self.isOpen = NO;
        
        [self.userName becomeFirstResponder];
    }
    self.valueArray = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
    [self.tableView reloadData];
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
//            [self oneClickLogin:YES];
            self.umLogin.hidden = NO;
        }
        else
        {
            self.umLogin.hidden = YES;
            self.coverView.hidden = YES;
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

#pragma mark 请求数据
- (void)getUserInfoApiRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0)
    {
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
        
        [self dismissLoginVC];
    }
    else
    {
        [self dismissLoginVC];
    }
}

#pragma mark --uibutton--delegate--
- (IBAction)loginPress:(id)sender
{
    [self.view endEditing:YES];
    
    [self loginRequest];
}

- (IBAction)forgotPress:(id)sender
{
    ForgotPwdViewController *registerVC = [[ForgotPwdViewController alloc] initWithNibName:@"ForgotPwdViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)registerPress:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark -- Login Logic --
- (void)loginRequest
{
    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入账号" toView:self.view];
        return;
    }
    
    if (self.userPwd.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入密码" toView:self.view];
        return;
    }
    
    if (!self.flagButton.selected)
    {
        [MBProgressHUD showToast:@"请阅读并同意用户协议和隐私政策" toView:self.view];
        return;
    }
    
    LoginApi *api = [[LoginApi alloc] init];
    api.userName = self.userName.text;
    api.phoneNO = @"";
    api.logintype = @"1";
    api.pwd = self.userPwd.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleLoginInSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleLoginInSuccess:(LoginApi *)api
{
    if (api.success == 1)
    {
//        [MBProgressHUD showToast:@"登录成功" toView:self.view];
        [YJProgressHUD showSuccess:@"登录成功" inview:self.view];
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:api.data];
        [dic setValue:api.data[@"user_id"] forKey:@"id"];
        [self saveData:dic username:self.userName.text Password:self.userPwd.text];
        
        [self backAction:NO];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:[UIApplication sharedApplication].keyWindow];
    }
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
    
    NSArray * array = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
    NSDictionary * loginDic = @{@"myName":username, @"myPwd":password};
    //存储登录过的账号
    if (array == NULL)//若之前没有存储,则存当前账号
    {
        [YYToolModel saveUserdefultValue:@[loginDic] forKey:@"myOtherAccount"];
    }
    else//若之前有存储别的账号,则添加该账号
    {
        NSMutableArray * addArray = [NSMutableArray arrayWithArray:array];
        if (![array containsObject:loginDic])
        {
            [addArray insertObject:loginDic atIndex:0];
        }
        else//添加登录的该账号
        {
            NSInteger index = [array indexOfObject:loginDic];
            if (index != 0)//如果该账号不在首位,则与0交换
            {
                [addArray exchangeObjectAtIndex:index withObjectAtIndex:0];
            }
        }
        [YYToolModel saveUserdefultValue:addArray forKey:@"myOtherAccount"];
    }
    
    //将账号密码分享到制定粘贴板
    NSString * copyStr = [NSString stringWithFormat:@"'%@','%@'", username, password];
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:SaveUserLoginAccount create:YES];
    pasteboard.string = copyStr;
    
    //复制账号适配老版本
    UIPasteboard *pasteboard1 = [UIPasteboard pasteboardWithName:@"SaveUserLoginAccount" create:YES];
    pasteboard1.string = copyStr;
    
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
    
//    //只在985手游记录事件
//    NSInteger channelTag = [DeviceInfo shareInstance].channelTag.integerValue;
//    if (channelTag == 1 || channelTag == 3)
//    {
//        //诸葛io
//        NSDictionary * properties = @{@"user_name":username};
//        [[Zhuge sharedInstance] identify:dic[@"user_id"] properties:properties];
//        //记录事件
//        [[Zhuge sharedInstance] track:@"login" properties:properties];
//    }
    //统计登录完成
    [MyAOPManager relateStatistic:@"LoginSuccess" Info:@{@"type":@"账号密码"}];
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
//    if ([DeviceInfo shareInstance].deviceUDID.length > 0)
//    {
//        if ([DeviceInfo shareInstance].channelTag.integerValue == 0)
//        {
//            appKey = @"5d3ac7de570df31370000aad";
//        }
//        else if ([DeviceInfo shareInstance].channelTag.integerValue == 1)
//        {
//            appKey = @"59e81144677baa73640008ea";
//        }
//        else if ([DeviceInfo shareInstance].channelTag.integerValue == 3)
//        {
//            appKey = @"5d3ac834570df3135b000982";
//        }
//    }
//    else
//    {
        appKey = [DeviceInfo shareInstance].umAppkey;
//    }
    
    MyUmLoginApi * api = [[MyUmLoginApi alloc] init];
    api.token = token;
    api.appkey = appKey;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSArray * list = request.data[@"users"];
            if (list.count > 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
                    [self selectUsername:list];
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

                        [self goToSetPassword:dic];
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
        
        NSMutableArray *ControllersmArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (int i = 0; i < self.navigationController.viewControllers.count; i ++)
        {
            UIViewController * vc = self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:[PwdLoginViewController class]] || [vc isKindOfClass:[LoginViewController class]])
            {
                [ControllersmArr removeObject:vc];
            }
        }
        self.navigationController.viewControllers = ControllersmArr;
    });
    
    [UMCommonHandler cancelLoginVCAnimated:YES complete:nil];
}

#pragma mark — 设置密码
- (void)goToSetPassword:(NSDictionary *)dic
{
    MySetPasswordController * pwd = [MySetPasswordController new];
    pwd.dataDic = dic;
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
- (void)selectUsername:(NSArray *)array
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
            if ([dic[@"isSetPassword"] boolValue])
            {
                [self umSelectUsernameLogin:dic];
            }
            else
            {
                [self goToSetPassword:dic];
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
            [self dismissLoginVC];
            [self getUserInfoApiRequest];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc  toView:[UIApplication sharedApplication].delegate.window];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (IBAction)flagButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (IBAction)userProtocolClick:(id)sender
{
    WebViewController * web = [WebViewController new];
    web.urlString = LoginUserAgreementUrl;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)pricacyAgreementClick:(id)sender
{
    WebViewController * web = [WebViewController new];
    web.urlString = LoginPrivacyPolicyUrl;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 触摸结束编辑退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isOpen)
        [self rotateImage:self.dropDown];
}

@end
