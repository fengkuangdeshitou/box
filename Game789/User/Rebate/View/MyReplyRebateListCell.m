//
//  MyReplyRebateListCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateListCell.h"

@implementation MyReplyRebateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_icon"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.showTime.text = [NSString stringWithFormat:@"充值时间：%@", [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dataDic[@"last_recharge_time"] doubleValue]]];
    
    self.showMoney.text = [NSString stringWithFormat:@"%@元", dataDic[@"can_rebate_amount"]];
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dataDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

- (IBAction)replyBtnClick:(id)sender
{
    
}

@end
