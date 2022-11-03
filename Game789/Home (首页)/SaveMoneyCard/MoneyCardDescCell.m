//
//  MoneyCardDescCell.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MoneyCardDescCell.h"

@interface MoneyCardDescCell ()

@property(nonatomic,weak)IBOutlet UIImageView * descImageView;
@property(nonatomic,weak)IBOutlet UIView * borderView;

@end

@implementation MoneyCardDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buyButton.titleLabel.numberOfLines = 0;
    
    self.borderView.layer.borderWidth = 0.5;
    self.borderView.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
    self.borderView.layer.cornerRadius = 10;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
