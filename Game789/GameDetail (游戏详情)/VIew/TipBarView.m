//
//  TipBarView.m
//  Game789
//
//  Created by Maiyou on 2018/11/7.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "TipBarView.h"

@implementation TipBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"TipBarView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    
    if (isFirst)
    {
        self.showText.text = @"送首充".localized;
    }
}

- (IBAction)closeButtonAction:(id)sender
{
    [self removeFromSuperview];
    
    self.isFirst ?
    [YYToolModel saveUserdefultValue:@"1" forKey:@"ShowFirstRecharge"] :
    [YYToolModel saveUserdefultValue:@"1" forKey:@"CommentMakgeMoney"];
}

@end
