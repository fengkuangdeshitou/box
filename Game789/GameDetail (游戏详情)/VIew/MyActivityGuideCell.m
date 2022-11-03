//
//  MyActivityGuideCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyActivityGuideCell.h"

@implementation MyActivityGuideCell

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
    
    switch ([dataDic[@"type"] integerValue]) {
        case 2:
            self.showType.text = @" 游戏攻略 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#5BA5FE"];
            break;
        case 3:
            self.showType.text = @" 独家永久 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#51C76C"];
            break;
        case 4:
            self.showType.text = @" 独家限时 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#6B6FF0"];
            break;
        case 5:
            self.showType.text = @" 永久活动 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#FF8C50"];
            break;
        case 6:
            self.showType.text = @" 限时活动 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#FFC100"];
            break;
            
        default:
            self.showType.text = @" 其他活动 ";
            self.showType.backgroundColor = [UIColor colorWithHexString:@"#FFC100"];
            break;
    }
    
    self.nameLabel.text = dataDic[@"news_title"];
    
    self.timeLabel.text = [NSDate dateWithFormat:@"yyyy-MM-dd" WithTS:[dataDic[@"news_date"] doubleValue]];
    
    if ([dataDic[@"type"] integerValue] != 2)
    {
        self.showStatusTitle.text = dataDic[@"status_title"];
    }
}

@end
