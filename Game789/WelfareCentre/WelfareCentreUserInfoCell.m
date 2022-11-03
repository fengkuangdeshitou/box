//
//  WelfareCentreUserInfoCell.m
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreUserInfoCell.h"

@interface WelfareCentreUserInfoCell ()

@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UIImageView * img;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;

@end

@implementation WelfareCentreUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.icon yy_setImageWithURL:[NSURL URLWithString:data[@"icon"]] placeholder:MYGetImage(@"game_icon")];
    [self.img yy_setImageWithURL:[NSURL URLWithString:data[@"titleImage"]] placeholder:MYGetImage(@"game_icon")];
//    self.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"welfare_task_%@",data[@"name"]]];
    self.titleLabel.text = data[@"desc"];
}

@end
