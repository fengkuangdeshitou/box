//
//  MyRecycleRecordsCell.m
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRecycleRecordsCell.h"

@implementation MyRecycleRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    switch (index)
    {
        case 1:
            self.statusImageView.image = [UIImage imageNamed:@"trading_daishuhui"];
            break;
        case 2:
            self.statusImageView.image = [UIImage imageNamed:@"trading_yishuhui"];
            break;
        case 3:
            self.statusImageView.image = [UIImage imageNamed:@"trading_expired"];
            break;
            
        default:
            break;
    }
}

- (void)setRecordModel:(MyRecycleRecordsModel *)recordModel
{
    _recordModel = recordModel;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:recordModel.game[@"img"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = recordModel.game[@"name"];
    
    self.xhName.text = recordModel.alt[@"alias"];
    
    self.recycleAmount.text = [NSString stringWithFormat:@"%@", recordModel.recycledCoin];
    
    self.ransomAmount.text = [NSString stringWithFormat:@"%@%@", recordModel.redeemdAmount, @"元".localized];
    
    if (self.index == 2)
    {
        self.redeemedTime.text = [NSString stringWithFormat:@"赎回时间:%@", [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:recordModel.redeemedTime.floatValue]];
    }
    else
    {
        self.redeemedTime.text = [NSString stringWithFormat:@"过期时间:%@", [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:recordModel.redeemEndTime.floatValue]];
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:recordModel.game[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", recordModel.game[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

@end
