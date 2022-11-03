//
//  MyHallGameTypeCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyHallGameTypeCell.h"

@implementation MyHallGameTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
