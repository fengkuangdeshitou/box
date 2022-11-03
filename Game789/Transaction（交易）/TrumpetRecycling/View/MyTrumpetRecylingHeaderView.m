//
//  MyTrumpetRecylingHeaderView.m
//  Game789
//
//  Created by Maiyou001 on 2021/10/9.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTrumpetRecylingHeaderView.h"

@implementation MyTrumpetRecylingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTrumpetRecylingHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews
{
    self.height = CGRectGetMaxY(self.showTitle.frame) + 15;
}

@end
