//
//  MySubmitRebateSuccessController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySubmitRebateSuccessController.h"
#import "MyRebateCenterController.h"
#import "MyReplyRebateDetailController.h"

#import "ReturnDetailApi.h"

@interface MySubmitRebateSuccessController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UILabel *showGameName;
@property (weak, nonatomic) IBOutlet UILabel *showAccount;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;

@end

@implementation MySubmitRebateSuccessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"提交成功";
    self.topView_top.constant = kStatusBarAndNavigationBarHeight + 42;
    
    self.showGameName.text = self.detailDic[@"game_name"];
    
    
    self.showMoney.text = [NSString stringWithFormat:@"%@元", self.detailDic[[self.detailDic[@"status"] integerValue] == -1 ? @"recharge_amount" : @"can_rebate_amount"]];
    
    NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
    self.showAccount.text = userName;
}

#pragma mark — 回到首页
- (IBAction)backHomeClick:(id)sender
{
    BOOL isLoad = NO;
    for(UIViewController *temp in self.navigationController.viewControllers)
    {
        if([temp isKindOfClass:[MyRebateCenterController class]])
        {
            [self.navigationController popToViewController:temp animated:YES];
            isLoad = YES;
            break;
        }
    }
    if (!isLoad)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark — 订单详情
- (IBAction)orderDetailBtnClick:(id)sender
{
    MyReplyRebateDetailController * detail = [MyReplyRebateDetailController new];
    detail.rebate_id = self.rebate_id;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
