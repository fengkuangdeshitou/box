//
//  ExclusiveTableViewCell.m
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "ExclusiveTableViewCell.h"

@interface ExclusiveTableViewCell ()

@property(nonatomic,weak)IBOutlet UIView * bgView;
@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,strong) CAGradientLayer * bggradient;
@property(nonatomic,strong) CAGradientLayer * gradient;


@end

@implementation ExclusiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bggradient = [CAGradientLayer layer];
    self.bggradient.cornerRadius = 9;
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.cornerRadius = 14;
}

- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.titleLabel.text = model[@"title"];
    self.titleLabel.textColor = [UIColor colorWithHexString:model[@"tc"]];
    self.descLabel.text = model[@"desc"];
    self.descLabel.textColor = [UIColor colorWithHexString:model[@"dc"]];
    self.icon.image = [UIImage imageNamed:model[@"image"]];
    self.bggradient.startPoint = CGPointMake(0, 0.5);
    self.bggradient.endPoint = CGPointMake(1, 0.5);
    self.bggradient.colors = @[(id)[UIColor colorWithHexString:model[@"bgc1"]].CGColor,(id)[UIColor colorWithHexString:model[@"bgc2"]].CGColor];
    [self.bgView.layer insertSublayer:self.bggradient atIndex:0];
    
    self.gradient.startPoint = CGPointMake(0, 0.5);
    self.gradient.endPoint = CGPointMake(1, 0.5);
    self.gradient.colors = @[(id)[UIColor colorWithHexString:model[@"rec1"]].CGColor,(id)[UIColor colorWithHexString:model[@"rec2"]].CGColor];
    [self.actionButton.layer insertSublayer:self.gradient atIndex:0];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.bggradient.frame = self.bgView.bounds;
    self.gradient.frame = self.actionButton.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
