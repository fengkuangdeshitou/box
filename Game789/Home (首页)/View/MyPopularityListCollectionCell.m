//
//  MyPopularityListCollectionCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/14.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "MyPopularityListCollectionCell.h"

@implementation MyPopularityListCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.topView az_setGradientBackgroundWithColors:@[[UIColor colorWithWhite:0 alpha:0.0], [UIColor colorWithWhite:0 alpha:0.8]] locations:nil startPoint:CGPointMake(0, 1) endPoint:CGPointMake(0, 0)];
    
    [self.bottomView az_setGradientBackgroundWithColors:@[[UIColor colorWithWhite:0 alpha:0.0], [UIColor colorWithWhite:0 alpha:0.8]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_ur_list"][0]] placeholder:MYGetImage(@"game_shotscreen_bg")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.gameType.text = dataDic[@"game_classify_type"];
    
    if ([self.type isEqualToString:@"starting"])
    {
        self.showTime.text = [NSDate dateWithFormat:@"HH:mm" WithTS:[dataDic[@"starting_time"] doubleValue]];
    }
    else
    {
        self.showTime.text = [NSDate dateWithFormat:@"MM月dd日首发" WithTS:[dataDic[@"starting_time"] doubleValue]];
    }
}

@end
