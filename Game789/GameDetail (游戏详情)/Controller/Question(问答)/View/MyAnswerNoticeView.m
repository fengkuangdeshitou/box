//
//  MyAnswerNoticeView.m
//  Game789
//
//  Created by Maiyou on 2019/2/27.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyAnswerNoticeView.h"

@implementation MyAnswerNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAnswerNoticeView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)sureClick:(id)sender
{
    [self removeFromSuperview];
}


@end
