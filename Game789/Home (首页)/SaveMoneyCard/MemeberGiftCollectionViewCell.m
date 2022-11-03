//
//  MemeberGiftCollectionViewCell.m
//  Game789
//
//  Created by maiyou on 2021/9/14.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemeberGiftCollectionViewCell.h"

@interface MemeberGiftCollectionViewCell ()

@property(nonatomic,weak)IBOutlet UIView * borderView;
@property(nonatomic,weak)IBOutlet YYAnimatedImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * title;
@property(nonatomic,weak)IBOutlet UILabel * desc;

@end

@implementation MemeberGiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.borderView.layer.borderColor = [UIColor colorWithHexString:@"#BC8B6B"].CGColor;
    self.borderView.layer.borderWidth = 0.5;
    self.borderView.layer.cornerRadius = 14;
    
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.icon yy_setImageWithURL:[NSURL URLWithString:data[@"logo"]] placeholder:MYGetImage(@"game_icon")];
    self.title.text = data[@"gamename"];
    self.desc.text = data[@"packname"];
}

@end
