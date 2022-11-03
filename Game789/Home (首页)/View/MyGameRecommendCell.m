//
//  MyGameRecommendCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGameRecommendCell.h"
#import "NoticeDetailViewController.h"

@implementation MyGameRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"title"];
    
    self.gameDesc.text = dataDic[@"info"];
    
    self.recommendName.text = dataDic[@"name"];
    
    self.buttonTitle.text = dataDic[@"btn"];
    
    self.playButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (IBAction)playButtonClick:(id)sender
{
    [self gameContentTableCellBtn:self.dataDic];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic
{
    [[YYToolModel shareInstance] showUIFortype:dic[@"type"] Parmas:dic[@"value"]];
}

@end
