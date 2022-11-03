//
//  MyTaskSignedView.m
//  Game789
//
//  Created by Maiyou on 2020/10/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTaskSignedView.h"

@implementation MyTaskSignedView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTaskSignedView" owner:self options:nil].firstObject;
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
