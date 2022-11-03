//
//  MyDailyTaskHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyDailyTaskHeaderView.h"

@implementation MyDailyTaskHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyDailyTaskHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.dailyTaskTitle_top.constant = 70 + kStatusBarHeight;
    }
    return self;
}

@end
