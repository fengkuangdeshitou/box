//
//  GuidePageMaskView.m
//  Game789
//
//  Created by Maiyou on 2018/12/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GuidePageMaskView.h"

@implementation GuidePageMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"GuidePageMaskView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        self.sureButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.sureButton.layer.borderWidth = 1;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (IBAction)sureAction:(id)sender
{
    self.clickBlock();
    [self removeFromSuperview];
}

@end
