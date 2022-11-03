//
//  WelfareCentreHeaderView.m
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreHeaderView.h"

@implementation WelfareCentreHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.moreButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
}

@end
