//
//  tradingViewCell.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "tradingViewCell.h"

@implementation tradingViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.game_icon.clipsToBounds = YES;
    
    UIImageView *typeNameLabelImageView = [UIImageView new];
    typeNameLabelImageView.backgroundColor = [UIColor clearColor];
    [self.game_icon addSubview:typeNameLabelImageView];
    
    self.typeNameLabelImageView = typeNameLabelImageView;
    [typeNameLabelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.game_icon.mas_centerX).offset(20);
        make.centerY.mas_equalTo(self.game_icon.mas_centerY).offset(-20);
        make.height.equalTo(@15);
        make.width.equalTo(self.game_icon.mas_width);
    }];
    
    UILabel *typeNameLabel = [UILabel new];
    typeNameLabel.backgroundColor = MYColor(245, 84, 64);
    typeNameLabel.textColor = [UIColor whiteColor];
    typeNameLabel.textAlignment = NSTextAlignmentCenter;
    typeNameLabel.font = [UIFont boldSystemFontOfSize:11];
    typeNameLabel.text = @"";
    [self.typeNameLabelImageView addSubview:typeNameLabel];
    [typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    self.typeNameLabelImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.typeNameLabel = typeNameLabel;
    self.typeNameLabelImageView.transform = CGAffineTransformMakeRotation(M_PI/4.5);
}

- (void)setListModel:(TradingListModel *)listModel
{
    _listModel = listModel;
    
    NSString * type = @"";
    NSString * time = @"";
    if (listModel.trade_type.integerValue == 1)
    {
        type = @"成交时间: ".localized;
        time = [NSDate detailTimeStringWithTs:listModel.trade_time.floatValue];
    }
    else
    {
        type = @"上架时间: ".localized;
        time = [NSDate detailTimeStringWithTs:listModel.sell_time.floatValue];;
    }
    self.showTime.text = [NSString stringWithFormat:@"%@%@", type, time];
    
    self.game_icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.game_icon sd_setImageWithURL:[NSURL URLWithString:listModel.account_icon] placeholderImage:MYGetImage(@"game_icon")];
    
    self.game_name.text = self.isShowServerName ? [NSString stringWithFormat:@"%@: %@", @"区服", listModel.server_name] : listModel.game_name;
    
    self.trading_des.text = listModel.title;
    
//    CGSize priceSize = [YYToolModel sizeWithText:[NSString stringWithFormat:@"¥%@", listModel.trade_price] size:CGSizeMake(MAXFLOAT, 20) font:self.trading_price.font];
//    self.price_width.constant = priceSize.width + 5;
    self.trading_price.text = [NSString stringWithFormat:@"¥%@", listModel.trade_price];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", listModel.total_amount] attributes:attribtDic];
    self.totalAmount.attributedText = attribtStr;
    
    if (!self.isHiddenTag)
    {
        NSString * game_type = @"";
        if (listModel.game_species_type.integerValue == 1)
        {
            game_type = @"BT版 ";
        }
        else if (listModel.game_species_type.integerValue == 2)
        {
            game_type = @"折扣 ";
        }
        else if (listModel.game_species_type.integerValue == 3)
        {
            game_type = @"H5 ";
        }
        else if (listModel.game_species_type.integerValue == 4)
        {
            game_type = @"GM ";
        }
        self.game_type.text = game_type.localized;
    }
    else
    {
        self.gameType_width.constant = 0;
        self.gameName_y.constant = 0;
        self.game_type.text = @"";
    }
    
    self.typeNameLabelImageView.hidden = !self.isShow;
    if (listModel.trade_type.integerValue == 1)
    {
        self.typeNameLabel.text = @"      已完成".localized;
    }
    else if (listModel.trade_type.integerValue == 3)
    {
        self.typeNameLabel.text = @"      出售中".localized;
    }
    else if (listModel.trade_type.integerValue == 0)
    {
        self.typeNameLabel.text = @"      待审核".localized;
    }
    else if (listModel.trade_type.integerValue == 2)
    {
        self.typeNameLabel.text = @"      审核失败".localized;
    }
    else if (listModel.trade_type.integerValue == -1)
    {
        self.typeNameLabel.text = @"      已失效".localized;
    }
    
    //游戏使用端判断
    if ([listModel.game_device_type integerValue] == 0)
    {
        self.deviceIosIcon_width.constant = 15;
        self.deviceAndroidIcon_width.constant = 15;
        self.deviceIosIcon.hidden = NO;
        self.deviceAndroidIcon.hidden = NO;
    }
    else if ([listModel.game_device_type integerValue] == 1)
    {//安卓
        self.deviceIosIcon_width.constant = 0;
        self.deviceAndroidIcon_width.constant = 15;
        self.deviceIosIcon.hidden = YES;
        self.deviceAndroidIcon.hidden = NO;
    }
    else if ([listModel.game_device_type integerValue] == 2)
    {//ios
        self.deviceIosIcon_width.constant = 15;
        self.deviceAndroidIcon_width.constant = 0;
        self.deviceIosIcon.hidden = NO;
        self.deviceAndroidIcon.hidden = YES;
    }
    
    //游戏名称后缀
    if (!self.isShowServerName)
    {
        BOOL isNameRemark = [listModel.nameRemark isBlankString];
        self.nameRemark.text = !isNameRemark ? [NSString stringWithFormat:@"%@  ", listModel.nameRemark] : @"";
        self.nameRemark.hidden = isNameRemark;
    }
    else
    {
        self.nameRemark.text = @"";
        self.nameRemark.hidden = YES;
    }
    
}

@end
