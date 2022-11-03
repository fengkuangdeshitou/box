//
//  HGRecommendGameListCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGRecommendGameListCell.h"

@implementation HGRecommendGameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
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
    self.showGameType.text = game_classify_type;
    self.nameRemark.layer.cornerRadius = 3;
        self.nameRemark.layer.borderColor = [UIColor colorWithHexString:@"#E3B579"].CGColor;
        self.nameRemark.layer.borderWidth = 0.5;    self.nameRemark.hidden = [dataDic[@"nameRemark"] length] == 0;
    self.nameRemark.text = [dataDic[@"nameRemark"] stringByAppendingString:@" "];
}

@end
