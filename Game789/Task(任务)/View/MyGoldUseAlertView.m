//
//  MyGoldUseAlertView.m
//  Game789
//
//  Created by maiyou on 2022/3/9.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyGoldUseAlertView.h"
#import "UserCoinsHistoryViewController.h"

@implementation MyGoldUseAlertView

+ (void)showMyGoldUseAlertView{
    MyGoldUseAlertView * view = [[MyGoldUseAlertView alloc] init];
    [view show];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [NSBundle.mainBundle loadNibNamed:@"MyGoldUseAlertView" owner:nil options:nil].firstObject;
        self.frame = UIScreen.mainScreen.bounds;
        [UIApplication.sharedApplication.keyWindow addSubview:self];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
    }];
}

- (IBAction)dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}

- (IBAction)action:(id)sender{
    [self dismiss];
    UserCoinsHistoryViewController * vc = [[UserCoinsHistoryViewController alloc] init];
    vc.hidesBottomBarWhenPushed = true;
    [YYToolModel.getCurrentVC.navigationController pushViewController:vc animated:true];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
