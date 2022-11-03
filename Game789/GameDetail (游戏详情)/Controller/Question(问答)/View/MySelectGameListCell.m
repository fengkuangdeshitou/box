//
//  MySelectGameListCell.m
//  Mycps
//
//  Created by Maiyou on 2019/11/14.
//  Copyright © 2019 Maiyou. All rights reserved.
//

#import "MySelectGameListCell.h"

@implementation MySelectGameListCell

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

    //游戏类型
    self.game_type.text = [NSString stringWithFormat:@" %@ ", dataDic[@"gametype"]];

    //折扣
//    if (gameModel.discountRatio.floatValue < 1 && gameModel.discountRatio.floatValue > 0)
//    {
//        self.showDiscount.text = [NSString stringWithFormat:@"%.1f折", gameModel.discountRatio.floatValue * 10];
//        self.showDiscount.hidden = NO;
//    }
//    else
//    {
        self.showDiscount.hidden = YES;
//    }

    //名称
    self.game_name.text = dataDic[@"gamename"];
}

@end
