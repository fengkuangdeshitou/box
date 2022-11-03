//
//  AdultAlertView.m
//  Game789
//
//  Created by maiyou on 2021/9/9.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "AdultAlertView.h"

@implementation AdultAlertView

+ (void)showAdultAlertView{
    AdultAlertView * alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    alertView.frame = UIScreen.mainScreen.bounds;
    alertView.alpha = 0;
    [alertView show];
}

- (void)show{
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
    }];
}

- (IBAction)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
