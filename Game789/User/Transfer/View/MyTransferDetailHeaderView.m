//
//  MyTransferDetailHeaderView.m
//  Game789
//
//  Created by Maiyou on 2021/3/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferDetailHeaderView.h"

@implementation MyTransferDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTransferDetailHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

@end
