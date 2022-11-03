//
//  MyHotSearchListCell.m
//  Game789
//
//  Created by Maiyou on 2020/12/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHotSearchListCell.h"

@implementation MyHotSearchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellItem:(NSInteger)cellItem
{
    _cellItem = cellItem;
    
    self.showIndex.text = [NSString stringWithFormat:@"%ld", (long)(cellItem + 1)];
    
    if (cellItem < 3)
    {
//        self.showIndex.font = [UIFont boldSystemFontOfSize:14];
        self.showIndex.textColor = [UIColor colorWithHexString:@"#F80000"];
        
        self.tagIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"search_recommend_icon%ld", (long)cellItem + 1]];
        self.tagIcon.hidden = NO;
        self.tagIcon_width.constant = 19;
        
        NSString * str = [NSString stringWithFormat:@"game_rank_%ld", (long)cellItem + 1];
        self.gameRankIcon.image = MYGetImage(str);
        self.gameRankIcon.hidden = NO;
        self.showIndex.hidden = YES;
    }
    else
    {
//        self.showIndex.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        self.showIndex.textColor = [UIColor colorWithHexString:@"#999999"];
        self.showIndex.font = [UIFont italicSystemFontOfSize:13];
        self.tagIcon.hidden = YES;
        self.tagIcon_width.constant = 0;
        
        self.gameRankIcon.hidden = YES;
        self.showIndex.hidden = NO;
    }
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.gameName.text = dataDic[@"game_name"];
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_icon"]] placeholder:MYGetImage(@"game_icon")];
    
    self.showGameType.text = dataDic[@"tagsName"];
}

@end
