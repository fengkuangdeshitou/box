//
//  MyUserReturnGameInfoCell.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnGameInfoCell.h"

@implementation MyUserReturnGameInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGamesModel:(MyUserReturnGamesModel *)gamesModel
{
    _gamesModel = gamesModel;
    
    self.selectedStatus.hidden = [gamesModel.is_received boolValue];
    
    self.gamaname.text = gamesModel.gamename;
    
    [self.logo yy_setImageWithURL:[NSURL URLWithString:gamesModel.logo] placeholder:MYGetImage(@"game_icon")];
    
    for (UILabel * label in self.stackView.subviews) {
        label.text = @"";
    }
    NSArray * array1 = @[];
    if ([gamesModel.versioncode hasPrefix:@" "])
    {
        array1 = [[gamesModel.versioncode substringFromIndex:1] componentsSeparatedByString:@" "];
    }
    else
    {
        array1 = [gamesModel.versioncode componentsSeparatedByString:@" "];
    }
    for (int i = 0; i < array1.count; i++) {
        UILabel * label = [self.stackView viewWithTag:i+10];
        label.text = [NSString stringWithFormat:@"%@", array1[i]];
    }
    
    //有描述显示描述，没有显示福利标签
    for (UILabel * label in self.stackView1.subviews) {
        label.text = @"";
    }
  
    self.desc.hidden = YES;
    NSArray * array = gamesModel.version;
    for (int i = 0; i<array.count; i++) {
        UILabel * label = [self.stackView1 viewWithTag:i+20];
        label.text = [NSString stringWithFormat:@"%@", array[i]];
    }
    //多少人在玩
    self.playGames.text = [NSString stringWithFormat:@"｜%@人在玩", gamesModel.how_many_play];
}

@end
