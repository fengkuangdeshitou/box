//
//  HGActionCell.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGActionCell.h"

@implementation HGActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.botView = [[HKPBotView alloc] init];
    [self.contentView addSubview:self.botView];
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
