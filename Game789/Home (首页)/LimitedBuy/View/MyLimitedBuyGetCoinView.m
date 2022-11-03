//
//  MyLimitedBuyGetCoinView.m
//  Game789
//
//  Created by Maiyou on 2021/1/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyLimitedBuyGetCoinView.h"

@implementation MyLimitedBuyGetCoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyLimitedBuyGetCoinView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)sureBtnClick:(id)sender
{
    [self removeFromSuperview];
}


@end
