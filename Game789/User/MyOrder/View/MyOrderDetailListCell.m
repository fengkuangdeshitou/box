//
//  MyOrderDetailListCell.m
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyOrderDetailListCell.h"

@implementation MyOrderDetailListCell

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
    
    self.showMoney.text = dataDic[@"amount"];
    
    self.showTime.text = dataDic[@"date_time"];
    
    if (![dataDic[@"comment"] isKindOfClass:[NSNull class]])
    {
        self.showDetail.text = dataDic[@"comment"];
    }
    else
    {
        self.showDetail.text = @"";
    }
    
    if ([dataDic[@"amount"] containsString:@"+"])
    {
        self.showMoney.textColor = [UIColor colorWithHexString:@"#FF5E00"];
    }
    else
    {
        self.showMoney.textColor = FontColor28;
    }
}

@end
