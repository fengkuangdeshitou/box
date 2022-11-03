//
//  MyUserReturnAlertView.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnAlertView.h"

@implementation MyUserReturnAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyUserReturnAlertView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveClick)];
        [self.bgImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    
    NSString * imageName = [NSString stringWithFormat:@"user_return_receive%ld", (long)self.day];
    self.bgImageView.image = MYGetImage(imageName);
}

- (void)receiveClick
{
    if (self.day == 1)
    {
        if (self.receiveAction) {
            self.receiveAction();
        }
        [self removeFromSuperview];
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
