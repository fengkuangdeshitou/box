//
//  MyShowVoucherListCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyShowVoucherListCell.h"

@implementation MyShowVoucherListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showMoney_width.constant = self.contentView.width * 0.3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.showMoney.text = [NSString stringWithFormat:@"￥%@", @([dataDic[@"amount"] floatValue])];
    
    self.showVoucherMoney.text = [NSString stringWithFormat:@"%@%@%@", @"满".localized, dataDic[@"meet_amount"], @"元可用".localized];
    
    NSString * startTime = [NSDate dateTimeStringWithTS:[dataDic[@"start_time"] doubleValue]];
    NSString * endTime = [NSDate dateTimeStringWithTS:[dataDic[@"end_time"] doubleValue]];
    if ([dataDic[@"start_time"] doubleValue] == 0 && [dataDic[@"end_time"] doubleValue] > 0)
    {
        self.showTime.text = [NSString stringWithFormat:@"%@%@", @"使用截止时间".localized, endTime];
    }
    else if ([dataDic[@"start_time"] doubleValue] > 0 && [dataDic[@"end_time"] doubleValue] == 0)
    {
        self.showTime.text = [NSString stringWithFormat:@"%@%@", @"使用起始时间".localized, startTime];
    }
    else if ([dataDic[@"start_time"] doubleValue] > 0 && [dataDic[@"end_time"] doubleValue] > 0)
    {
        self.showTime.text = [NSString stringWithFormat:@"%@-%@", startTime, endTime];
    }
    else
    {
        self.showTime.text = @"不限制使用时间".localized;
    }
}

@end
