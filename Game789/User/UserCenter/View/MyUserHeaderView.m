//
//  MyUserHeaderView.m
//  Game789
//
//  Created by Maiyou on 2019/10/18.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyUserHeaderView.h"
#import "UserPayGoldViewController.h"
#import "SecureViewController.h"
#import "MyGoldMallViewController.h"
#import "MyVoucherListViewController.h"
#import "MyGoldUseAlertView.h"

@implementation MyUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyUserHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        //1 关闭 2 打开 月卡
//        self.monthCardBtn.hidden = [[DeviceInfo shareInstance].data[@"monthcard"] integerValue] == 2 ? NO : YES;
        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMemeberClick)];
//        [self.memberView addGestureRecognizer:tap];
        
        CGRect frame = CGRectMake(0, 0, kScreenW - 30, self.memberView.height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = frame;
        maskLayer.path = maskPath.CGPath;
        self.memberView.layer.mask = maskLayer;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString * time = [DeviceInfo shareInstance].vipsignLifeTimeDesc;
    if ([dataDic allKeys].count == 0)
    {
        self.userName_top.constant = -2.5;
        self.userName_height.constant = 20;
        self.memberIcon.hidden = YES;
//        self.memberLevelIcon.image = [UIImage imageNamed:@"member_level0"];
//        self.memberLevelIcon.hidden = YES;
        self.nickName.text = @"";
        self.userName.text = @"未登录".localized;
        self.userName.font = [UIFont boldSystemFontOfSize:19];
        self.showMobile.text = @"";
        self.platCoinsLabel.text = @"0";
        self.goldCoinsLabel.text = @"0";
        self.voucherNumLabel.text = @"0";
        [self.iconImageButton setImage:MYGetImage(@"avatar_default") forState:0];
//        [self.signBtn setTitle:@"签到" forState:0];
        [self.openMemberBtn setTitle:@"立即开通" forState:0];
        
        //没有登录隐藏显示至尊版到期时间
        self.showExpireTime.hidden = YES;
        if (![YYToolModel isBlankString:time])
        {
            self.showMobile.text = time;
        }
    }
    else
    {
        self.userName_top.constant = 3;
        self.userName_height.constant = 15;
        self.nickName.text = [NSString stringWithFormat:@"%@：%@", @"账号".localized, dataDic[@"member_name"]];
        self.userName.text = [NSString stringWithFormat:@"%@：%@", @"手机号".localized, [YYToolModel isBlankString:dataDic[@"mobile"]] ? @"暂未绑定".localized : dataDic[@"mobile"]];
        self.userName.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        self.showMobile.text = [NSString stringWithFormat:@"%@：%@", @"实名认证".localized, [dataDic[@"isRealNameAuth"] boolValue] ? @"已实名".localized : @"未实名".localized];
//        [self.signBtn setTitle:[dataDic[@"is_sign"] boolValue] ? @"已签到" : @"签到" forState:0];
        self.platCoinsLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:[dataDic[@"platform_coins"] floatValue]]];
        self.goldCoinsLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:[dataDic[@"gold_coins"] floatValue]]];
        self.voucherNumLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"available_voucher"]];
        
        NSString * name = dataDic[@"nick_name"];
        if (name.length == 0)
        {
            name = @"";
            self.memberIcon.hidden = YES;
//            self.memberLevelIcon.hidden = YES;
        }
        else
        {
            self.memberIcon.image = [UIImage imageNamed:@"hg_icon"];
            if (![YYToolModel isBlankString:dataDic[@"vip_level"]])
            {
                self.memberIcon.hidden = NO;
//                self.memberLevelIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", [dataDic[@"vip_level"] intValue]]];
                
                if ([dataDic[@"vip_level"] integerValue] == 0)
                {
//                    self.memberLevelIcon.hidden = YES;
                    [self.openMemberBtn setTitle:@"立即开通" forState:0];
                }
                else
                {
//                    self.memberLevelIcon.hidden = NO;
                    [self.openMemberBtn setTitle:@"立即续费" forState:0];
                }
            }
            else
            {
//                self.memberLevelIcon.hidden = YES;
                self.memberIcon.hidden = YES;
                [self.openMemberBtn setTitle:@"立即开通" forState:0];
            }
        }
        
        [self.iconImageButton sd_setImageWithURL:[NSURL URLWithString:dataDic[@"icon_link"]] forState:0 placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
        //显示至尊版有效期
        if ([YYToolModel isBlankString:time])
        {
            self.showExpireTime.hidden = YES;
            self.expireTimeCenterY.constant = 0;
        }
        else
        {
            self.showExpireTime.text = time;
            self.showExpireTime.hidden = NO;
            self.expireTimeCenterY.constant = -9;
        }
    }
    
    if ([DeviceInfo shareInstance].monthCardDesc)
    {
        self.showMonthcardDesc.text = [DeviceInfo shareInstance].monthCardDesc;
    }
    self.vip_desc.text = [DeviceInfo shareInstance].vip_desc;
    self.month_card_desc.text = [DeviceInfo shareInstance].month_card_desc;
    //统计月卡的展示次数
    [MyAOPManager relateStatistic:@"ShowMyPageActivityBanner" Info:@{}];
}

#pragma mark — 查看个人中心
- (IBAction)viewPersonalCenterClick:(id)sender
{
    if ([YYToolModel isAlreadyLogin])
    {
        SecureViewController * secure = [SecureViewController new];
        secure.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:secure animated:YES];
    }
}

#pragma mark - 查看个人中心
//- (IBAction)openMemberBtnClick:(id)sender
//{
//    [self viewMemeberClick];
//}

//- (void)viewMemeberClick
//{
//    if ([YYToolModel isAlreadyLogin])
//    {
//        [MyAOPManager userInfoRelateStatistic:@"ClickJoinMembership"];
//
//        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
//        payVC.selectedIndex = 1;
//        payVC.hidesBottomBarWhenPushed = YES;
//        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
//    }
//}

- (IBAction)viewMemeberClick:(UIButton *)sender{
    
    if ([YYToolModel isAlreadyLogin])
    {
        [MyAOPManager userInfoRelateStatistic:@"ClickJoinMembership"];
        
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = sender.tag-10;
        payVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
}

- (IBAction)platformCoinClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    [MyAOPManager userInfoRelateStatistic:@"ClickToRechargePlatformCoins"];
    
    UserPayGoldViewController * payVC = [[UserPayGoldViewController alloc]init];
    payVC.isRecharge = YES;
    [self.currentVC.navigationController pushViewController:payVC animated:YES];
}

- (IBAction)goldenCoinClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    [MyGoldUseAlertView showMyGoldUseAlertView];
//    [self.currentVC.navigationController pushViewController:[MyGoldMallViewController new] animated:YES];
}

- (IBAction)voucherCoinClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    [self.currentVC.navigationController pushViewController:[MyVoucherListViewController new] animated:YES];
}

@end
