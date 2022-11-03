//
//  ForgotPwdViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "ModifyPwdViewController.h"

#import "MBProgressHUD+QNExtension.h"
#import "NSString+Phone.h"

#import "ModifyPwdApi.h"

@interface ModifyPwdViewController ()

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet GameTextField *passWordEnter;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_top;


@end

@implementation ModifyPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = @"修改登录密码";
    
//    [self.sureButton setGradientBackgroundWithColors:@[(id)MYColor(255, 138, 28), (id)MYColor(255, 205, 90)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    self.userName_top.constant = kStatusBarAndNavigationBarHeight + 30;
}

- (void)modifyPwdApiRequest {
    if (self.userName.text.length == 0 || self.passWord.text.length == 0 || self.passWordEnter.text.length == 0)
    {
        [MBProgressHUD showToast:@"请完善输入框信息" toView:self.view];
        return;
    }
    else if (![self.passWordEnter.text isEqualToString:self.passWord.text])
    {
        [MBProgressHUD showToast:@"新密码两次输入不一致" toView:self.view];
        return;
    }
    else if ([self.userName.text isEqualToString:self.passWord.text])
    {
        [MBProgressHUD showToast:@"新密码和原密码一样" toView:self.view];
        return;
    }
    ModifyPwdApi *api = [[ModifyPwdApi alloc] init];

    api.oldPwd = self.userName.text;
    api.newsPwd = self.passWord.text;
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (void)handleNoticeSuccess:(ModifyPwdApi *)api {
    if (api.success == 1) {
        
        //修改当前存储的账号密码
        NSArray * array = [YYToolModel getUserdefultforKey:@"myOtherAccount"];
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary * dic = array[i];
            if ([dic[@"myName"] isEqualToString:[YYToolModel getUserdefultforKey:@"user_name"]])
            {
                NSMutableDictionary * tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [tmpDic setValue:self.passWord.text forKey:@"myPwd"];
                [array1 replaceObjectAtIndex:i withObject:tmpDic];
                [YYToolModel saveUserdefultValue:array1 forKey:@"myOtherAccount"];
                break;
            }
        }
        
        LoginViewController * login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        login.isRelogin = YES;
        [self.navigationController pushViewController:login animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromParentViewController];
        });
    }
    else {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (IBAction)registerPress:(id)sender {
    if (self.userName.text.length == 0) {
        [MBProgressHUD showToast:@"请输入旧密码" toView:self.view];
        return;
    }
    if (self.passWord.text.length == 0) {
        [MBProgressHUD showToast:@"请设置新密码" toView:self.view];
        return;
    }
    if (self.passWordEnter.text.length == 0) {
        [MBProgressHUD showToast:@"请确认新密码" toView:self.view];
        return;
    }

    if (![self.passWordEnter.text isEqualToString:self.passWord.text]) {
        [MBProgressHUD showToast:@"两次输入的新密码不一致，请重新输入" toView:self.view];
        return;
    }

    [self modifyPwdApiRequest];
}

- (IBAction)showPwdBtnClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !button.selected;
    if (button.tag == 10)
    {
        self.userName.secureTextEntry = !button.selected;
    }
    else if (button.tag == 11)
    {
        self.passWord.secureTextEntry = !button.selected;
    }
    else if (button.tag == 12)
    {
        self.passWordEnter.secureTextEntry = !button.selected;
    }
}

@end
