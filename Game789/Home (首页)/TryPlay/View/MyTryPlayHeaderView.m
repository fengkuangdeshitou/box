//
//  MyTryPlayHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/12/31.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTryPlayHeaderView.h"

@implementation MyTryPlayHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTryPlayHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return self;
}

@end
