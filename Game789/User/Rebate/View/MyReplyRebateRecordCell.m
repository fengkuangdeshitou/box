//
//  MyReplyRebateRecordCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateRecordCell.h"
#import "TUConfig.h"

@implementation MyReplyRebateRecordCell

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
    
    if (![YYToolModel isBlankString:dataDic[@"game_img"]])
    {
        [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_img"]] placeholder:MYGetImage(@"game_icon")];
    }
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.showMoney.text = [NSString stringWithFormat:@"%@元", dataDic[@"recharge_amount"]];
    
    //返利处理状态（0 ： 待审核 / 1 ： 发放中 / 2：处理完成 / -1 : 驳回
    NSInteger status = [dataDic[@"status"] integerValue];
    self.showReason.text = @"";
    if (status == 0) {
        self.showStatus.text = @"正在审核";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#FF5E00"];
        
        self.showTime.text = [NSString stringWithFormat:@"提交时间：%@", [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dataDic[@"add_time"] doubleValue]]];
    }
    else if (status == 1) {
        self.showStatus.text = @"发放中";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#FF5E00"];
        
        self.showTime.text = [NSString stringWithFormat:@"提交时间：%@", [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dataDic[@"add_time"] doubleValue]]];
    }
    else if (status == 2) {
        self.showStatus.text = @"已完成";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#999999"];
        
        self.showTime.text = [NSString stringWithFormat:@"处理时间：%@", [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dataDic[@"handle_time"] doubleValue]]];
    }
    else if (status == -1) {
        self.showStatus.text = @"驳回";
        self.showStatus.textColor = [UIColor redColor];
        self.showReason.text = dataDic[@"handle_remark"];
        
        self.showTime.text = [NSString stringWithFormat:@"处理时间：%@", [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dataDic[@"handle_time"] doubleValue]]];
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dataDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

- (void)setTransferDic:(NSDictionary *)transferDic
{
    _transferDic = transferDic;
    
    NSDictionary * from_game_info = transferDic[@"from_game_info"];
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:from_game_info[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = from_game_info[@"game_name"];
    
    self.showMoney.text = @"";
    
    self.showMoneyTitle.text = [NSString stringWithFormat:@"转出游戏：%@", transferDic[@"into_game_info"][@"game_name"]];
    
    self.showTime.text = [NSString stringWithFormat:@"申请时间：%@", transferDic[@"create_time"]];
    
    //返利处理状态 1: 待审核, 2:通过, 3:驳回 , 4:完成
    NSInteger status = [transferDic[@"check_status"] integerValue];
    self.showReason.text = @"";
    if (status == 1) {
        self.showStatus.text = @"正在审核";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#FF5E00"];
    }
    else if (status == 2) {
        self.showStatus.text = @"审核通过";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#FF5E00"];
    }
    else if (status == 4) {
        self.showStatus.text = @"已完成";
        self.showStatus.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    else if (status == 3) {
        self.showStatus.text = @"已驳回";
        self.showStatus.textColor = [UIColor redColor];
        self.showReason.text = transferDic[@"check_msg"];
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:transferDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", transferDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

@end
