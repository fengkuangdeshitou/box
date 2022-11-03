//
//  MySetPasswordController.m
//  Game789
//
//  Created by Maiyou on 2020/1/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySetPasswordController.h"
#import "PwdLoginViewController.h"

#import "MySetPasswordApi.h"
@class MyPswSetPasswordApi;

@interface MySetPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * password_top;

@end

@implementation MySetPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"设置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.password_top.constant = kStatusBarAndNavigationBarHeight + 30;
}

- (IBAction)sureButtonClick:(id)sender
{
    if (self.password.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入密码" toView:self.view];
        return;
    }
    self.isPwd ? [self codeSetPassword] : [self umSetPassword];
}

- (void)codeSetPassword
{
    MyPswSetPasswordApi * api = [[MyPswSetPasswordApi alloc] init];
    api.password = self.password.text;
    api.token    = self.dataDic[@"token"];
    api.username = self.dataDic[@"username"];
    api.member_id = self.dataDic[@"user_id"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:request.data];
            [dic setValue:request.data[@"user_id"] forKey:@"id"];
            [self saveData:dic];
            
            [YJProgressHUD showSuccess:@"密码设置成功" inview:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //登录成功回调
    //            if (self.UmLoginSuccess)
    //            {
    //                self.UmLoginSuccess();
    //            }
                //返回
                [self loginSuccessBack];
            });
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)umSetPassword
{
    MySetPasswordApi * api = [[MySetPasswordApi alloc] init];
    api.password = self.password.text;
    api.token    = self.dataDic[@"token"];
    api.username = self.dataDic[@"username"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YYToolModel deleteUserdefultforKey:TOKEN];
            
            [self saveData:request.data];
            
            [YJProgressHUD showSuccess:@"密码设置成功" inview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //登录成功回调
    //            if (self.UmLoginSuccess)
    //            {
    //                self.UmLoginSuccess();
    //            }
                //返回
                [self loginSuccessBack];
            });
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)loginSuccessBack
{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController * vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[LoginViewController class]] || [vc isKindOfClass:[PwdLoginViewController class]])
        {
            [array removeObject:vc];
        }
    }
    self.navigationController.viewControllers = array;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveData:(NSDictionary *)dic
{
    NSString * username = dic[@"username"];
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    [userDefults setValue:dic[@"token"] forKey:TOKEN];
    [userDefults setValue:dic[@"id"] forKey:@"user_id"];
    [userDefults setValue:username forKey:@"user_name"];
    [userDefults setValue:@"1" forKey:MY_BAIDU_OCPC];
    [userDefults synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotice object:nil];
    });
    
//    //只在985手游记录事件
//    NSInteger channelTag = [DeviceInfo shareInstance].channelTag.integerValue;
//    if (channelTag == 1 || channelTag == 3)
//    {
//        //诸葛io
//        NSDictionary * properties = @{@"user_name":username};
//        [[Zhuge sharedInstance] identify:self.dataDic[@"user_id"] properties:properties];
//        //记录事件
//        [[Zhuge sharedInstance] track:@"login" properties:properties];
//    }
    
    //将账号密码分享到制定粘贴板
    NSString * copyStr = [NSString stringWithFormat:@"'%@','%@'", username, self.password.text];
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:SaveUserLoginAccount create:YES];
    pasteboard.string = copyStr;
    
    //复制账号适配老版本
    UIPasteboard *pasteboard1 = [UIPasteboard pasteboardWithName:@"SaveUserLoginAccount" create:YES];
    pasteboard1.string = copyStr;
    
    //统计登录完成
    [MyAOPManager relateStatistic:@"LoginSuccess" Info:@{}];
}


@end
