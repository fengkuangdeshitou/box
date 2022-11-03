//
//  YYPersonalCollectionSectionView.m
//  52Talk
//
//  Created by Maiyou on 2019/3/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "YYPersonalCollectionSectionView.h"
#import "UserPayGoldViewController.h"

@implementation YYPersonalCollectionSectionView

- (IBAction)monthCardClick:(id)sender
{
    //统计点击次数
    [MyAOPManager relateStatistic:@"ClickMyPageActivityBanner" Info:@{}];

    if ([YYToolModel isAlreadyLogin])
    {
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = 0;
        payVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
}

@end
