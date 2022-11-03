//
//  MyUserReturnRuleView.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/2.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnRuleView.h"

@implementation MyUserReturnRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyUserReturnRuleView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
