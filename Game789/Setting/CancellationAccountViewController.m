//
//  CancellationAccountViewController.m
//  Game789
//
//  Created by maiyou on 2021/5/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CancellationAccountViewController.h"
#import "ConfirmAccountViewController.h"
#import "AccountCancelAPI.h"
#import "LoginApi.h"

@interface CancellationAccountViewController ()<UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * top;
@property(nonatomic,weak)IBOutlet UIView * coverView;
@property(nonatomic,weak)IBOutlet UILabel * accountLabel;
@property(nonatomic,weak)IBOutlet UITextField * password;
@property (weak, nonatomic) IBOutlet UIButton *selectNoticeBtn;
@property(nonatomic,copy) NSString * url;
@property(nonatomic,strong) NSDictionary * assetsList;

@end

@implementation CancellationAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.top.constant = kStatusBarAndNavigationBarHeight + 19;
    self.navBar.title = @"注销账号";
    
    self.accountLabel.text = [NSString stringWithFormat:@"账号:%@",[YYToolModel getUserdefultforKey:@"user_name"]];
    AccountCancelAPI * request = [[AccountCancelAPI alloc] init];
    [request startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.url = request.data[@"noticeUrl"];
        self.assetsList = request.data[@"assets"];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (IBAction)nextAction:(id)sender
{
    if (!self.selectNoticeBtn.selected)
    {
        [MBProgressHUD showToast:@"请阅读并同意账号注销须知" toView:self.view];
        return;
    }
    
    [self.view bringSubviewToFront:self.coverView];
    [UIView animateWithDuration:0.1 animations:^{
        self.coverView.alpha = 1;
    }completion:^(BOOL finished) {
        [self.password becomeFirstResponder];
    }];
}
- (IBAction)selectNoticeAction:(id)sender
{
    self.selectNoticeBtn.selected = !self.selectNoticeBtn.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self verifyPassword];
    
    return YES;
}

- (IBAction)sureBtnClick:(id)sender
{
    [self verifyPassword];
}

- (void)verifyPassword
{
    if ([self.password.text isBlankString])
    {
        [MBProgressHUD showToast:@"请输入密码" toView:self.view];
        return;
    }
    LoginApi * api = [[LoginApi alloc] init];
    api.phoneNO = @"";
    api.userName = [YYToolModel getUserdefultforKey:@"user_name"];
    api.logintype = @"2";
    api.pwd = self.password.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            self.password.text = @"";
            [self dismiss];
            ConfirmAccountViewController * confirm = [[ConfirmAccountViewController alloc] init];
            confirm.assetsList = self.assetsList;
            [self.navigationController pushViewController:confirm animated:YES];
        }else{
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (IBAction)cancellationNoticeAction:(id)sender{
    WebViewController * web = [[WebViewController alloc] init];
    web.urlString = [NSString stringWithFormat:@"%@?channel=%@", self.url, [DeviceInfo shareInstance].channel];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)dismiss{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
