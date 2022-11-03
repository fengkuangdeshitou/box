//
//  MoneyCardCollectionViewCell.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MoneyCardCollectionViewCell.h"

@interface MoneyCardCollectionViewCell ()

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * priceLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UILabel * badgeLabel;
@property(nonatomic,weak)IBOutlet UILabel * oldPrice;

@end

@implementation MoneyCardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.titleLabel.text = data[@"f_desc"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",data[@"amount"]];
    self.oldPrice.text = [NSString stringWithFormat:@"原价：%@元",data[@"old_amount"]];
    self.descLabel.text = [NSString stringWithFormat:@"%@\n%@",data[@"t_desc"],data[@"s_desc"]];
    NSString * hot_title = data[@"hot_title"];
    self.badgeLabel.text = hot_title;
    self.badge.hidden = hot_title.length == 0;
    self.badge.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMaxYCorner;
    self.badge.layer.cornerRadius = 10;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:data[@"icon"]] placeholderImage:MYGetImage(@"game_icon")];
//    self.titleImageView.hidden = [data[@"active"] intValue] != 1;
//    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:data[@"hot_img"]]];
}

@end
