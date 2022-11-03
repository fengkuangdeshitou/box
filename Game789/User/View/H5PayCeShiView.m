//
//  H5PayCeShiView.m
//  Game789
//
//  Created by Maiyou on 2018/10/10.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "H5PayCeShiView.h"

@implementation H5PayCeShiView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"H5PayCeShiView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.enterText.zw_placeHolder = @"请输入内容".localized;
    }
    return self;
}

#pragma mark - 取消
- (IBAction)cancleButtonAction:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - 确定
- (IBAction)sureButtonAction:(id)sender
{
    if (self.enterText.text.length == 0)
    {
        [MBProgressHUD showToast:@"内容不能为空"];
        return;
    }
    [self removeFromSuperview];
    
    //没有登陆
    if (![YYToolModel islogin])
    {
        [self.currentVC.navigationController pushViewController:[LoginViewController new] animated:YES];
        return;
    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    LoadGameViewController * game = [[LoadGameViewController alloc] init];
    game.load_url = [NSString stringWithFormat:@"%@&username=%@", self.enterText.text, userName];
    game.hidesBottomBarWhenPushed = YES;
    game.hiddenNavBar = YES;
    [self.currentVC.navigationController pushViewController:game animated:YES];
}


@end
