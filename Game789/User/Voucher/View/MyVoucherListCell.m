//
//  MyVoucherListCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyVoucherListCell.h"
#import "MyVoucherUseIntroView.h"

@implementation MyVoucherListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (!IsiPhone11ProMax)
    {
        self.voucherMoney_left.constant = 30;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVoucherModel:(MyVoucherListModel *)voucherModel
{
    _voucherModel = voucherModel;
    
    self.gameName.text = voucherModel.name;
    
    NSString * amount = [NSString stringWithFormat:@"%@", @([voucherModel.amount floatValue])];
    self.voucherMoney.text = amount;
    
    self.usedGameName.text = ![YYToolModel isBlankString:voucherModel.game_id] ? [NSString stringWithFormat:@"%@《%@》%@", @"仅限".localized, voucherModel.game_name, @"充值使用".localized] : voucherModel.game_name;
    
    if ([self.voucherModel.use_type isEqualToString:@"direct"])
    {
        self.exceedLabel.text = [NSString stringWithFormat:@"%@%@%@", @"仅限".localized, @([voucherModel.meet_amount floatValue]), @"元档可用".localized];
    }
    else
    {
        NSString * amount = [voucherModel.meet_amount floatValue] == 0 ? @"任意金额" : [NSString stringWithFormat:@"%@%@%@", @"满".localized, @([voucherModel.meet_amount floatValue]), @"元可用".localized];
        self.exceedLabel.text = amount;
    }
    
    for (int i = 1; i < 4; i ++)
    {
        UILabel * label = (UILabel *)[self.contentView viewWithTag:i];
        label.textColor = [UIColor colorWithHexString:voucherModel.type.integerValue != 2  ? @"#FFFFFF" : @"#111111"];
    }
    
    NSString * startTime = [NSDate dateTimeStringWithTS:[voucherModel.start_time doubleValue]];
    NSString * endTime = [NSDate dateTimeStringWithTS:[voucherModel.end_time doubleValue]];
    if ([voucherModel.start_time doubleValue] == 0 && [voucherModel.end_time doubleValue] > 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@%@", @"使用截止时间".localized, endTime];
    }
    else if ([voucherModel.start_time doubleValue] > 0 && [voucherModel.end_time doubleValue] == 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@%@", @"使用起始时间".localized, startTime];
    }
    else if ([voucherModel.start_time doubleValue] > 0 && [voucherModel.end_time doubleValue] > 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    else
    {
        self.timeLabel.text = @"不限制使用时间".localized;
    }
    
    //显示vip
    if (voucherModel.type.integerValue != 2)
    {
        self.showVipLevel.hidden = YES;
        self.vipImageView.hidden = YES;
    }
    else
    {
        self.showVipLevel.hidden = NO;
        self.vipImageView.hidden = NO;
        self.showVipLevel.text = voucherModel.vip_level_desc;
    }
    
    if (self.isDetail)
    {
        self.useLabel.text = ![voucherModel.is_received boolValue] ? @"立\n即\n领\n取" : @"已\n领\n取";
        self.useLabel.textColor = ![voucherModel.is_received boolValue] ? [UIColor colorWithHexString:voucherModel.type.intValue != 2 ? @"#FF5E00" : @"#8F5B0C"] : [UIColor colorWithHexString:@"#999999"];
        [self.userButton setTitleColor:[UIColor colorWithHexString:voucherModel.type.intValue != 2 ? @"#FF5E00" : @"#8F5B0C"] forState:0];
        self.cellBgimageView.image = MYGetImage(voucherModel.type.intValue != 2 ? @"user_voucher_unused" : @"user_voucher_vip_unused");
        return;
    }
    
    NSInteger isUsed = [voucherModel.is_used integerValue];
    NSInteger is_expired   = [voucherModel.is_expired integerValue];
    NSInteger is_available = [voucherModel.is_available integerValue];
    
    if (isUsed == 1 || is_expired == 1)
    {
        self.cellBgimageView.image = MYGetImage(@"user_voucher_used");
//        self.cornerImageView.image = MYGetImage(@"user_voucher_used_corner");
        [self.userButton setTitleColor:[UIColor colorWithHexString:@"#DCDCDC"] forState:0];
        self.circleView1.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        self.circleView2.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
//        self.voucherStatus.hidden = NO;
        if (isUsed)
        {
            self.useLabel.text = @"已\n使\n用";
        }
        else if (is_expired)
        {
            self.useLabel.text = @"已\n过\n期";
        }
        self.useLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.userButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0];
        for (int i = 3; i < 6; i ++)
        {
            UILabel * label = (UILabel *)[self.contentView viewWithTag:i + 1];
            label.textColor = [UIColor colorWithHexString:@"#999999"];
        }
    }
    else if (is_available == 1)
    {
        self.cellBgimageView.image = MYGetImage(voucherModel.type.intValue != 2 ? @"user_voucher_unused" : @"user_voucher_vip_unused");
//        self.cornerImageView.image = MYGetImage(@"user_voucher_normal_corner");
        [self.userButton setTitleColor:[UIColor colorWithHexString:@"#36BBF1"] forState:0];
        self.circleView1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.circleView2.backgroundColor = [UIColor colorWithHexString:@"#999999"];
//        self.voucherStatus.hidden = YES;

        self.useLabel.text = @"去\n使\n用";
        self.useLabel.textColor =  [UIColor colorWithHexString:voucherModel.type.intValue != 2 ? @"#FF5E00" : @"#8F5B0C"];
        [self.userButton setTitleColor:[UIColor colorWithHexString:voucherModel.type.intValue != 2 ? @"#FF5E00" : @"#8F5B0C"] forState:0];
        for (int i = 3; i < 6; i ++)
        {
            UILabel * label = (UILabel *)[self.contentView viewWithTag:i + 1];
            if (i + 1 == 4)
            {
                label.textColor = [UIColor colorWithHexString:@"#282828"];
            }
            else
            {
                label.textColor = [UIColor colorWithHexString:@"#999999"];
            }
        }
    }
}

//- (void)setDataDic:(NSDictionary *)voucherModel
//{
//    _voucherModel = voucherModel;
//
//    self.userButton.hidden = YES;
//
//    self.gameName.text = [voucherModel objectForKey:@"name"];
//
//    self.voucherMoney.text = [NSString stringWithFormat:@"%@", @([[voucherModel objectForKey:@"amount"] floatValue])];
//
//    self.usedGameName.text = ![YYToolModel isBlankString:[voucherModel objectForKey:@"game_id"]] ? [NSString stringWithFormat:@"%@《%@》%@", @"仅限", [voucherModel objectForKey:@"game_name"], @"充值使用"] : [voucherModel objectForKey:@"game_name"];
//
//    NSString * meetAmount = [voucherModel objectForKey:@"meet_amount"];
//    NSString * amount = [voucherModel objectForKey:@"amount"];
//    if ([[voucherModel objectForKey:@"use_type"] isEqualToString:@"direct"])
//    {
//        self.exceedLabel.text = [NSString stringWithFormat:@"仅限%@元档可用", @([amount floatValue])];
//    }
//    else
//    {
//        NSString * amount = [meetAmount floatValue] == 0 ? @"任意金额" : [NSString stringWithFormat:@"%@%@%@", @"满", @([meetAmount floatValue]), @"元可用"];
//        self.exceedLabel.text = amount;
//    }
//
//    NSString * startTime = [NSDate dateTimeStringWithTS:[[voucherModel objectForKey:@"start_time"] doubleValue]];
//    NSString * endTime = [NSDate dateTimeStringWithTS:[[voucherModel objectForKey:@"end_time"] doubleValue]];
//    if ([[voucherModel objectForKey:@"start_time"] doubleValue] == 0 && [[voucherModel objectForKey:@"end_time"] doubleValue] > 0)
//    {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@%@", @"使用截止时间".localized, endTime];
//    }
//    else if ([[voucherModel objectForKey:@"start_time"] doubleValue] > 0 && [[voucherModel objectForKey:@"end_time"] doubleValue] == 0)
//    {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@%@", @"使用起始时间".localized, startTime];
//    }
//    else if ([[voucherModel objectForKey:@"start_time"] doubleValue] > 0 && [[voucherModel objectForKey:@"end_time"] doubleValue] > 0)
//    {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
//    }
//    else
//    {
//        self.timeLabel.text = @"不限制使用时间".localized;
//    }
//
//    BOOL isUsed    = [[voucherModel objectForKey:@"is_used"] boolValue];
//    BOOL isExpired = [[voucherModel objectForKey:@"is_expired"] boolValue];
//    BOOL isAvailable = [[voucherModel objectForKey:@"is_available"] boolValue];
//    if (isUsed == true)
//    {
//        [self.userButton setTitle:@"已使用" forState:0];
//    }
//    else if (isExpired == true)
//    {
//        [self.userButton setTitle:@"已过期" forState:0];
//    }
//
//    if (isUsed == true)
//    {
//        [self.cellBgimageView setBackgroundImage:[UIImage imageNamed:@"user_voucher_used"] forState:0];
//
//        self.userButton.backgroundColor = [UIColor colorWithRed:173/255 green:173/255 blue:173/255 alpha:0];
//
//        for (int i = 0; i < 6; i ++)
//        {
//            UILabel * label = (UILabel *)[self.contentView viewWithTag:i + 1];
//            label.textColor = [UIColor whiteColor];
//        }
//    }
//    else if (isExpired == true)
//    {
//        [self.cellBgimageView setBackgroundImage:[UIImage imageNamed:@"user_voucher_used"] forState:0];
//
//        self.userButton.backgroundColor = [UIColor colorWithRed:173/255 green:173/255 blue:173/255 alpha:0];
//
//        for (int i = 0; i < 6; i ++)
//        {
//            UILabel * label = (UILabel *)[self.contentView viewWithTag:i + 1];
//            label.textColor = [UIColor whiteColor];
//        }
//    }
//    else if (isAvailable == true)
//    {
//        [self.userButton setTitle:@"可使用".localized forState:0];
//        [self.cellBgimageView setBackgroundImage:[UIImage imageNamed:@"user_voucher_unused"] forState:0];
//
//        self.userButton.backgroundColor = [UIColor colorWithRed:176/255 green:97/255 blue:50/255 alpha:0];
//
//        for (int i = 0; i < 6; i ++)
//        {
//            UILabel * label = (UILabel *)[self.contentView viewWithTag:i + 1];
//            if (i == 0 || i == 1 || i == 2)
//            {
//                label.textColor = [UIColor colorWithHexString:@"#695016"];
//            }
//            else if (i == 3)
//            {
//                label.textColor = [UIColor colorWithHexString:@"#94701E"];
//            }
//            else if (i == 4)
//            {
//                label.textColor = [UIColor colorWithHexString:@"#916E1C"];
//            }
//            else if (i == 5)
//            {
//                label.textColor = [UIColor colorWithHexString:@"#8B8276"];
//            }
//        }
//    }
//}

- (IBAction)userButtonClick:(id)sender
{
//    GameDetailInfoController * info = [GameDetailInfoController new];
//    info.maiyou_gameid = self.voucherModel[@"game_id"];
//    [self.currentVC.navigationController pushViewController:info animated:YES];
    
    MyVoucherUseIntroView * useView = [[MyVoucherUseIntroView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    useView.dataDic   = [_voucherModel mj_keyValues];
    useView.currentVC = self.currentVC;
    [[UIApplication sharedApplication].keyWindow addSubview:useView];
    
//    NSString * useType = [_voucherModel objectForKey:@"use_type"];
//    NSString * amount  = [_voucherModel objectForKey:@"amount"];
//    if ([useType isEqualToString:@"direct"])
//    {
//        NSString * str = [NSString stringWithFormat:@"仅限%@元档可用", @([amount floatValue])];
//        [MBProgressHUD showToast:str toView:[UIApplication sharedApplication].keyWindow];
//    }
//    else
//    {
//        NSString * gameid = [_voucherModel objectForKey:@"game_id"];
//        if (gameid)
//        {
//            GameDetailInfoController * info = [GameDetailInfoController new];
//            info.maiyou_gameid = gameid;
//            [self.currentVC.navigationController pushViewController:info animated:YES];
//        }
//        else
//        {
//            NSString * str = [NSString stringWithFormat:@"仅限%@使用", [self.voucherModel objectForKey:@"game_name"]];
//            [MBProgressHUD showToast:str toView:[UIApplication sharedApplication].keyWindow];
//        }
//    }
}

@end
