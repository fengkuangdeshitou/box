//
//  MyYouthModePwdController.m
//  Game789
//
//  Created by Maiyou on 2021/3/20.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyYouthModePwdController.h"

@interface MyYouthModePwdController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;

@end

@implementation MyYouthModePwdController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView_top.constant = kStatusBarAndNavigationBarHeight + 10;
    self.view.backgroundColor = FontColorF6;
    self.navBar.title = self.isVerify ? @"验证密码" : @"设置密码";
    if (self.isVerify)
    {
        self.bottomView.hidden = YES;
        self.showTitle.text = @"验证密码";
    }
}

- (IBAction)sureBtnClick:(id)sender
{
    if (self.password.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入密码" toView:self.view];
        return;
    }
    if (!self.isVerify)
    {
        if (self.surePassword.text.length == 0)
        {
            [MBProgressHUD showToast:@"请输入确认密码" toView:self.view];
            return;
        }
        else if (![self.surePassword.text isEqualToString:self.password.text])
        {
            [MBProgressHUD showToast:@"两次密码设置不一致" toView:self.view];
            return;
        }
        
        [YYToolModel saveUserdefultValue:self.password.text forKey:@"MyYouthModePwd"];
        [MBProgressHUD showToast:@"设置成功" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString * pwd = [YYToolModel getUserdefultforKey:@"MyYouthModePwd"];
        if (![self.password.text isEqualToString:pwd])
        {
            [MBProgressHUD showToast:@"密码输入错误" toView:self.view];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.sureBtnBlock) {
        self.sureBtnBlock(self.isVerify);
    }
}

@end
