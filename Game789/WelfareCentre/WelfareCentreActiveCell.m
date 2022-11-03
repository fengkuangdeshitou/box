//
//  WelfareCentreActiveCell.m
//  Game789
//
//  Created by maiyou on 2021/9/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreActiveCell.h"

@interface WelfareCentreActiveCell ()

@property(nonatomic,weak)IBOutlet UIImageView * imageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;

@end

@implementation WelfareCentreActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:data[@"cover"]] placeholder:MYGetImage(@"game_icon")];
    self.titleLabel.text = data[@"title"];
}

@end
