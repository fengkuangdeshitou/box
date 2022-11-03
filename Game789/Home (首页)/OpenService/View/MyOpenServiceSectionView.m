//
//  MyOpenServiceSectionView.m
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyOpenServiceSectionView.h"

@implementation MyOpenServiceSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyOpenServiceSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = BackColor;
    }
    return self;
}

@end
