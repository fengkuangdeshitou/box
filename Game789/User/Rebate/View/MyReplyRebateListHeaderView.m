//
//  MyReplyRebateListHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateListHeaderView.h"

@implementation MyReplyRebateListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyReplyRebateListHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

@end
