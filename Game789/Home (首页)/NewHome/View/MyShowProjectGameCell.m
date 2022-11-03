//
//  MyShowProjectGameCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyShowProjectGameCell.h"

@implementation MyShowProjectGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];

    if ([dataDic[@"game_species_type"] intValue] == 2){
        if ([dataDic[@"discount"] floatValue] < 1 && [dataDic[@"discount"] floatValue] > 0)
        {
            self.showTag.hidden  = NO;
            self.showTag.text = [NSString stringWithFormat:@" %.1f折 ", [dataDic[@"discount"] floatValue] * 10];
        }else{
            self.showTag.hidden = YES;
        }
    }else{
        NSString * game_desc = dataDic[@"game_desc"];
        if ([game_desc containsString:@"+"])
        {
            NSArray * array = [game_desc componentsSeparatedByString:@"+"];
            self.showTag.text = [NSString stringWithFormat:@" %@ ", array[1]];
            self.showTag.hidden = NO;
        }
        else
        {
            self.showTag.hidden = YES;
        }
    }
    
    self.showGameType_height.constant = 0;
    self.showGameType.hidden = YES;
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataDic[@"nameRemark"]];
    self.nameRemark_top.constant = isNameRemark ? 0 : 7;
    self.nameRemark.hidden = isNameRemark;
    self.nameRemark.text = [NSString stringWithFormat:@"%@ ", dataDic[@"nameRemark"]];
    
    if ([self.type isEqualToString:@"banner"])
    {
        self.showGameType_top.constant = 0;
        self.gameIcon_width.constant = 67;
        self.gameIcon_height.constant = 67;
        self.gameIcon_top.constant = 6;
        self.showTag_top.constant = -6;
        self.showTag_height.constant = 12;
        self.showTag_right.constant = 10;
        self.showTag.layer.cornerRadius = 6;
        self.showTag.font = [UIFont systemFontOfSize:8];
        [self.contentView layoutIfNeeded];
    }
    
    if ([self.type isEqualToString:@"detail"])
    {
        self.showGameType_top.constant = 7;
        CGFloat width = (kScreenW - 30 - 13 * 2 - 15 * 3) / 4;
        self.gameIcon_width.constant  = width;
        self.gameIcon_height.constant = width;
        self.gameIcon_top.constant = 0;
        self.showTag.hidden = YES;
        self.showGameType_height.constant = 14;
        self.showGameType.hidden = NO;
        self.showGameType.text = dataDic[@"game_classify_type"];
        [self.contentView layoutIfNeeded];
    }
    
    if ([self.type isEqualToString:@"project"])
    {
        self.showGameType_top.constant = 0;
        self.gameIcon_width.constant = 67;
        self.gameIcon_height.constant = 67;
        self.gameIcon_top.constant = 6;
        self.showTag_height.constant = 12;
        if ([dataDic[@"game_species_type"] intValue] == 2){
            self.showTag_right.constant = 0;
            self.showTag_top.constant = 0;
        }else{
            self.showTag_right.constant = 10;
            self.showTag_top.constant = -6;
        }
        self.showTag.layer.cornerRadius = 6;
        self.showTag.font = [UIFont systemFontOfSize:8];
        [self.contentView layoutIfNeeded];
    }
}

@end
