//
//  HomeProjectMediaCell.m
//  Game789
//
//  Created by maiyou on 2021/7/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "HomeProjectMediaCell.h"

@interface HomeProjectMediaCell ()

@end

@implementation HomeProjectMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gameCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GameTableViewCell class]) owner:self options:nil] firstObject];
    self.gameCell.frame = CGRectMake(0, 0, ScreenWidth, 110);
    [self.contentView addSubview:self.gameCell];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gameCell.height = self.gameCell.cellHeight+25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (CGRectContainsPoint(self.gameIcon.frame, point)) {
//        return self.gameIcon;
//    }
//    return [super hitTest:point withEvent:event];
//}

@end
