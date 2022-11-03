//
//  MyOrderDetailSectionView.m
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyOrderDetailSectionView.h"

@implementation MyOrderDetailSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyOrderDetailSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

@end
