//
//  MyGameVoucherListTopView.m
//  Game789
//
//  Created by Maiyou on 2020/11/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameVoucherListTopView.h"
#import "UserPayGoldViewController.h"

@implementation MyGameVoucherListTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameVoucherListTopView" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

- (IBAction)pushToMonthCard:(id)sender
{
    if ([YYToolModel islogin])
    {
        [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            if (self.monthCardClick) {
                self.monthCardClick();
            }
            SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
            payVC.selectedIndex = 0;
            payVC.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
        }];
    }
    else
    {
        [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:VC animated:YES];
        }];
    }
}

@end
