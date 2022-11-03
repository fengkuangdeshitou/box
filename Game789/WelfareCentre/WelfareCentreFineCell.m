//
//  WelfareCentreFineCell.m
//  Game789
//
//  Created by maiyou on 2021/9/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreFineCell.h"

@interface WelfareCentreFineCell ()

@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;

@end

@implementation WelfareCentreFineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.icon yy_setImageWithURL:[NSURL URLWithString:data[@"icon"]] placeholder:MYGetImage(@"game_icon")];
    self.titleLabel.text = data[@"title"];
    self.descLabel.text = data[@"desc"];
}

@end
