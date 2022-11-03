//
//  SecureListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "SecureListTableViewCell.h"

@interface SecureListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

@end

@implementation SecureListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {
    self.iconImageView.image = [UIImage imageNamed:dic[@"icon"]];
    self.nameLabel.text = [dic[@"title"] localized];
    self.contextLabel.text = dic[@"text"];
}

@end
