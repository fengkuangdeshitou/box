//
//  RecentlyPlayCollectionViewCell.m
//  Game789
//
//  Created by maiyou on 2021/6/22.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RecentlyPlayCollectionViewCell.h"

@interface RecentlyPlayCollectionViewCell ()

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * title;

@end

@implementation RecentlyPlayCollectionViewCell

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.title.text = data[@"game_name"];
    [self.icon yy_setImageWithURL:[NSURL URLWithString:data[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
