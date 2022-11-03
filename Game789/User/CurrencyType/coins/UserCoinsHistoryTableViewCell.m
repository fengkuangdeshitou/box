//
//  UserCoinsHistoryTableViewCell.m
//  Game789
//
//  Created by Maiyou on 2018/6/22.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "UserCoinsHistoryTableViewCell.h"

@implementation UserCoinsHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModelDic:(NSDictionary *)dic {
    dic = [dic deleteAllNullValue];
    self.firstLab.text = [self timeWithTimeIntervalString:[dic objectForKey:@"gold_time"]];
    self.secondLab.text = [dic objectForKey:@"gold_coin"];
    self.ThirdLab.text = [dic objectForKey:@"note"];
   
}
@end
