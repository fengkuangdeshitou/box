//
//  tradingViewCell.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingMoreViewCell.h"
#import "ProductDetailsViewController.h"

@implementation TradingMoreViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewProductDetail)];
    [self.backView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewProductDetail)];
    [self.more_backView addGestureRecognizer:tap1];
}

- (void)setLeftListModel:(TradingListModel *)leftListModel
{
    _leftListModel = leftListModel;
    
    self.game_icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.game_icon sd_setImageWithURL:[NSURL URLWithString:leftListModel.account_icon] placeholderImage:MYGetImage(@"game_icon")];
    
    self.game_name.text = self.isShowServerName ? [NSString stringWithFormat:@"%@: %@", @"区服", leftListModel.server_name] : leftListModel.game_name;
    
    self.trading_des.text = leftListModel.title;
    
//    CGSize priceSize = [YYToolModel sizeWithText:[NSString stringWithFormat:@"¥%@", listModel.trade_price] size:CGSizeMake(MAXFLOAT, 20) font:self.trading_price.font];
//    self.price_width.constant = priceSize.width + 5;
    self.trading_price.text = [NSString stringWithFormat:@"¥%@", leftListModel.trade_price];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", leftListModel.total_amount] attributes:attribtDic];
    self.totalAmount.attributedText = attribtStr;
    
    if (!self.isHiddenTag)
    {
        NSString * game_type = @"";
        if (leftListModel.game_species_type.integerValue == 1)
        {
            game_type = @"BT版 ";
        }
        else if (leftListModel.game_species_type.integerValue == 2)
        {
            game_type = @"折扣 ";
        }
        else if (leftListModel.game_species_type.integerValue == 3)
        {
            game_type = @"H5 ";
        }
        else if (leftListModel.game_species_type.integerValue == 4)
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
    
    //游戏使用端判断
    if ([leftListModel.game_device_type integerValue] == 0)
    {
        self.deviceIosIcon_width.constant = 15;
        self.deviceAndroidIcon_width.constant = 15;
        self.deviceIosIcon.hidden = NO;
        self.deviceAndroidIcon.hidden = NO;
    }
    else if ([leftListModel.game_device_type integerValue] == 1)
    {//安卓
        self.deviceIosIcon_width.constant = 0;
        self.deviceAndroidIcon_width.constant = 15;
        self.deviceIosIcon.hidden = YES;
        self.deviceAndroidIcon.hidden = NO;
    }
    else if ([leftListModel.game_device_type integerValue] == 2)
    {//ios
        self.deviceIosIcon_width.constant = 15;
        self.deviceAndroidIcon_width.constant = 0;
        self.deviceIosIcon.hidden = NO;
        self.deviceAndroidIcon.hidden = YES;
    }
    
    //游戏名称后缀
    BOOL isNameRemark = [leftListModel.nameRemark isBlankString];
    self.nameRemark.text = !isNameRemark ? [NSString stringWithFormat:@"%@  ", leftListModel.nameRemark] : @"";
    self.nameRemark.hidden = isNameRemark;
    self.nameRemark_height.constant = !isNameRemark ? 17 : 0;
}

- (void)setRightListModel:(TradingListModel *)rightListModel
{
    _rightListModel = rightListModel;
    
    if (rightListModel == nil)
    {
        self.more_backView.hidden = YES;
        return;
    }
    self.more_backView.hidden = NO;
    
    self.more_game_icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.more_game_icon sd_setImageWithURL:[NSURL URLWithString:rightListModel.account_icon] placeholderImage:MYGetImage(@"game_icon")];
    
    self.more_game_name.text = self.isShowServerName ? [NSString stringWithFormat:@"%@: %@", @"区服", rightListModel.server_name] : rightListModel.game_name;
    
    self.more_trading_des.text = rightListModel.title;
    
//    CGSize priceSize = [YYToolModel sizeWithText:[NSString stringWithFormat:@"¥%@", listModel.trade_price] size:CGSizeMake(MAXFLOAT, 20) font:self.trading_price.font];
//    self.price_width.constant = priceSize.width + 5;
    self.more_trading_price.text = [NSString stringWithFormat:@"¥%@", rightListModel.trade_price];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", rightListModel.total_amount] attributes:attribtDic];
    self.more_totalAmount.attributedText = attribtStr;
    
    if (!self.isHiddenTag)
    {
        NSString * game_type = @"";
        if (rightListModel.game_species_type.integerValue == 1)
        {
            game_type = @"BT版 ";
        }
        else if (rightListModel.game_species_type.integerValue == 2)
        {
            game_type = @"折扣 ";
        }
        else if (rightListModel.game_species_type.integerValue == 3)
        {
            game_type = @"H5 ";
        }
        else if (rightListModel.game_species_type.integerValue == 4)
        {
            game_type = @"GM ";
        }
        self.more_game_type.text = game_type.localized;
    }
    else
    {
        self.more_gameType_width.constant = 0;
        self.more_gameName_y.constant = 0;
        self.more_game_type.text = @"";
    }
    
    //游戏使用端判断
    if ([rightListModel.game_device_type integerValue] == 0)
    {
        self.more_deviceIosIcon_width.constant = 15;
        self.more_deviceAndroidIcon_width.constant = 15;
        self.more_deviceIosIcon.hidden = NO;
        self.more_deviceAndroidIcon.hidden = NO;
    }
    else if ([rightListModel.game_device_type integerValue] == 1)
    {//安卓
        self.more_deviceIosIcon_width.constant = 0;
        self.more_deviceAndroidIcon_width.constant = 15;
        self.more_deviceIosIcon.hidden = YES;
        self.more_deviceAndroidIcon.hidden = NO;
    }
    else if ([rightListModel.game_device_type integerValue] == 2)
    {//ios
        self.more_deviceIosIcon_width.constant = 15;
        self.more_deviceAndroidIcon_width.constant = 0;
        self.more_deviceIosIcon.hidden = NO;
        self.more_deviceAndroidIcon.hidden = YES;
    }
    
    //游戏名称后缀
    BOOL isNameRemark = [rightListModel.nameRemark isBlankString];
    self.more_nameRemark.text = !isNameRemark ? [NSString stringWithFormat:@"%@  ", rightListModel.nameRemark] : @"";
    self.more_nameRemark.hidden = isNameRemark;
    self.more_nameRemark_height.constant = !isNameRemark ? 17 : 0;
}

- (void)leftViewProductDetail
{
    [MyAOPManager relateStatistic:@"ClickTradeGameDetails" Info:@{@"gameName":self.leftListModel.game_name, @"price":self.leftListModel.trade_price, @"type":@"horizontal"}];
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = self.leftListModel.trade_id;
    [[YYToolModel getCurrentVC].navigationController pushViewController:product animated:YES];
}

- (void)rightViewProductDetail
{
    [MyAOPManager relateStatistic:@"ClickTradeGameDetails" Info:@{@"gameName":self.rightListModel.game_name, @"price":self.rightListModel.trade_price, @"type":@"horizontal"}];
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = self.rightListModel.trade_id;
    [[YYToolModel getCurrentVC].navigationController pushViewController:product animated:YES];
}

@end
