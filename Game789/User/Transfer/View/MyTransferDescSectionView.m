//
//  MyTransferDescSectionView.m
//  Game789
//
//  Created by Maiyou on 2021/3/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferDescSectionView.h"

@implementation MyTransferDescSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTransferDescSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

@end
