//
//  MyLimitedBuyTitleCell.m
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyLimitedBuyTitleCell.h"

@implementation MyLimitedBuyTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showTime.text = dataDic[@"show_time"];
    
    self.showStatus.text = dataDic[@"status_info"];
}

@end
