//
//  MyGuessLikeGamesCell.m
//  Game789
//
//  Created by Maiyou on 2020/8/29.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGuessLikeGamesCell.h"

@implementation MyGuessLikeGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.backView az_setGradientBackgroundWithColors:@[[UIColor colorWithWhite:0 alpha:0.0], [UIColor colorWithWhite:0 alpha:0.8]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameImage yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_ur_list"][0]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    if ([dataDic[@"discount"] floatValue] < 1 && [dataDic[@"discount"] floatValue] > 0)
    {
        self.discountBg.hidden  = NO;
        self.showDiscount.hidden = NO;
        self.showDiscount.text = [NSString stringWithFormat:@"%.1f折", [dataDic[@"discount"] floatValue] * 10];
    }
    else
    {
        self.discountBg.hidden  = YES;
        self.showDiscount.hidden = YES;
    }
    
    //如果第一个是空格，去掉空格
    NSString * game_classify_type = dataDic[@"game_classify_type"];
    if ([game_classify_type hasPrefix:@" "])
    {
        game_classify_type = [game_classify_type substringFromIndex:1];
    }
    game_classify_type = [game_classify_type stringByReplacingOccurrencesOfString:@" " withString:@"·"];
    self.gameType.text = game_classify_type;
}

@end
