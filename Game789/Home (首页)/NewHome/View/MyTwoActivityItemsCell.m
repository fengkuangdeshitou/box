//
//  MyTwoActivityItemsCell.m
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTwoActivityItemsCell.h"
#import "BindMobileViewController.h"
#import "ActiveListViewController.h"
#import "MyRebateCenterController.h"
#import "MyVoucherListViewController.h"
#import "MyLimitedBuyingController.h"
#import "TransactionViewController.h"
#import "MyProjectGameController.h"
#import "YHTimeLineListController.h"

@implementation MyTwoActivityItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.showBtn1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showBtn2.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i ++)
    {
        NSDictionary * dic = dataArray[i];
        UIButton * sender = [self.contentView viewWithTag:i + 10];
        [sender yy_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"top_image"]] forState:0 placeholder:MYGetImage(@"banner_photo")];
    }
}

- (IBAction)btnClick:(id)sender
{
    UIButton * button = sender;
    [MyAOPManager userInfoRelateStatistic:button.tag == 10 ? @"ClickTheHomePageRecommendationModule_1" : @"ClickTheHomePageRecommendationModule_2"];
    
    NSDictionary * dic = self.dataArray[button.tag - 10];
    NSString * type = dic[@"jump_type"];
    BOOL is_check_login  = [dic[@"is_check_login"] boolValue];
    BOOL is_check_mobile = [dic[@"is_check_mobile"] boolValue];
    if (is_check_login)
    {
        if (![YYToolModel isAlreadyLogin]) return;
    }
    if (is_check_mobile)
    {
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
        {
            BindMobileViewController * band = [BindMobileViewController new];
            band.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:band animated:YES];
            return;
        }
    }
    if ([type isEqualToString:@"invite"])
    {
        [self pushInviteFriends];
    }
    else if ([type isEqualToString:@"activity"])
    {
        ActiveListViewController * active = [ActiveListViewController new];
        active.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:active animated:YES];
    }
    else if ([type isEqualToString:@"rebate"])
    {
        MyRebateCenterController * rebate = [MyRebateCenterController new];
        rebate.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:rebate animated:YES];
    }
    else if ([type isEqualToString:@"voucher"])
    {
        MyVoucherListViewController * rebate = [MyVoucherListViewController new];
        rebate.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:rebate animated:YES];
    }
    else if ([type isEqualToString:@"limitbuy"])
    {
        MyLimitedBuyingController * rebate = [MyLimitedBuyingController new];
        rebate.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:rebate animated:YES];
    }
    else if ([type isEqualToString:@"trade"])
    {
        TransactionViewController * trade = [TransactionViewController new];
        trade.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:trade animated:YES];
    }
    else if ([type isEqualToString:@"circleGame"])
    {
        YHTimeLineListController * line = [YHTimeLineListController new];
        line.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:line animated:YES];
    }
    else
    {
        [[YYToolModel shareInstance] showUIFortype:type Parmas:dic[@"jump_value"]];
    }
}

- (void)pushInviteFriends
{
    [[YYToolModel getCurrentVC].navigationController pushViewController:[MyInviteFriendsController new] animated:YES];
}

@end
