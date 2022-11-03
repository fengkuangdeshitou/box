//
//  MySubmitRebateNotice.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySubmitRebateNoticeView.h"

@implementation MySubmitRebateNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySubmitRebateNoticeView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)cancleBtnClick:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)submitBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    if (self.submitRebateAction)
    {
        self.submitRebateAction(self.showContent);
    }
}

@end
