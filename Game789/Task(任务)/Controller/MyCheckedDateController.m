//
//  MyCheckedDateController.m
//  Game789
//
//  Created by Maiyou on 2020/10/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCheckedDateController.h"
#import "UserPayGoldViewController.h"

#import "BPPCalendar.h"
#import "MySignedRuleView.h"
#import "MyTaskSignedView.h"

@interface MyCheckedDateController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageView_top;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *showKeepDays;

@end

@implementation MyCheckedDateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    BPPCalendar *calendarView = [[BPPCalendar alloc] initWithFrame:self.backView.bounds];
    calendarView.signedDateArray = self.signedDateArray;
    [self.backView addSubview:calendarView];
}

- (void)prepareBasic
{
    self.navBar.title = @"每日签到";
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    self.navBar.lineView.hidden = YES;
    [self.navBar.leftButton setImage:MYGetImage(@"back-1") forState:0];
    
    self.titleImageView_top.constant = 86 + kStatusBarHeight;
    self.showKeepDays.text = [NSString stringWithFormat:@"本月已经签到%lu天  本月最长连续签到%@天", (unsigned long)self.signedDateArray.count, self.dataDic[@"month_max_keep_day"]];
    
    if (self.isSigned)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyTaskSignedView * signedView = [[MyTaskSignedView alloc] initWithFrame:self.view.bounds];
            signedView.showCoinCount.text = [NSString stringWithFormat:@"获得%@金币", self.getCoin];
            signedView.showKeepDays.text = [NSString stringWithFormat:@"您已连续签到%@天", self.dataDic[@"month_keep_day"]];
            [[UIApplication sharedApplication].delegate.window addSubview:signedView];
        });
    }
}

#pragma mark ——— 加入会员
- (IBAction)joinMembershipClick:(id)sender
{
    SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
    payVC.selectedIndex = 1;
    payVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
}

#pragma mark ——— 查看签到规则
- (IBAction)viewCheckedRuleClick:(id)sender
{
    MySignedRuleView * ruleView = [[MySignedRuleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:ruleView];
}

@end
