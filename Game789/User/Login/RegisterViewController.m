//
//  RegisterViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "RegisterViewController.h"
#import "BindMobileViewController.h"
#import "registerApi.h"
#import "NSString+Phone.h"
#import "GetMobileCodeApi.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayoutconstraint;
@property (weak, nonatomic) IBOutlet UIButton *sureRegister;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *username_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_bottom;

@property (assign, nonatomic) BOOL isMobile;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *codeStr;


@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入注册页面
    [MyAOPManager relateStatistic:@"RegisterViewAppear" Info:@{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.hiddenNavBar = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = @"账号注册";
    self.navBar.lineView.hidden = YES;
    self.bottomView_bottom.constant = kTabbarSafeBottomMargin + 20;
    self.username_top.constant = kStatusBarAndNavigationBarHeight + 20;
    
    NSDictionary * dic = [DeviceInfo shareInstance].data;
    self.flagButton.selected = [dic[@"agreeChecked"] boolValue];
    
//    WEAKSELF
//    [self.navBar wr_setRightButtonWithTitle:@"登录" titleColor:MAIN_COLOR];
//    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    self.navBar.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    [self.navBar setOnClickRightButton:^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
    
}


- (IBAction)registerPress:(id)sender
{
    [self.view endEditing:YES];
    
    [self loginRequest];
}

#pragma mark -- Login Logic --
////////////

- (void)loginRequest
{
    registerApi *api = [[registerApi alloc] init];

    if (self.userName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入账号" toView:self.view];
        return;
    }
    
    if (self.passWord.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入密码" toView:self.view];
        return;
    }
    
    if (!self.flagButton.selected)
    {
        [MBProgressHUD showToast:@"请阅读并同意用户协议和隐私政策" toView:self.view];
        return;
    }
    api.userName = self.userName.text;
    api.regtype = @"1";
    api.pwd = self.passWord.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"请稍后...";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [hud hideAnimated:YES];
        [self handleRegiterSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [hud hideAnimated:YES];
    }];
}

- (void)handleRegiterSuccess:(registerApi *)api
{
    if (api.success == 1)
    {
        [YJProgressHUD showSuccess:@"注册成功" inview:self.view];
        [[NSUserDefaults standardUserDefaults] setValue:api.data[@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setValue:api.data[@"user_id"] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setValue:self.userName.text forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:MY_BAIDU_OCPC];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MyAOPManager relateStatistic:@"RegisterSuccess" Info:@{@"type":@"账号密码"}];
        NSArray * array = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
        NSDictionary * loginDic = @{@"myName":self.userName.text, @"myPwd":self.passWord.text};
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

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotice object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });

        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginReloadUrl" object:nil];
        //统计注册成功
        [MyAOPManager relateStatistic:@"RegisteredSuccess" Info:@{}];
        
//        if (!self.isMobile) {
            //绑定手机号码 可跳过
//            BindMobileViewController *bindMobileVC = [[BindMobileViewController alloc] init];
//            bindMobileVC.hidesBottomBarWhenPushed = YES;
//            bindMobileVC.isRegisterVC = YES;
//            [self.navigationController pushViewController:bindMobileVC animated:YES];
//            return;
//        }
        
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (IBAction)textValueChange:(UITextField *)textField
{
    
}

#pragma mark — 显示隐藏密码
- (IBAction)showPwdBtnClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !button.selected;
    self.passWord.secureTextEntry = !button.selected;
 
}

- (IBAction)flagButtonAction:(UIButton *)sender
{
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

@end
