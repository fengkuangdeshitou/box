//
//  WelfareCentreFooterView.m
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreFooterView.h"

@implementation WelfareCentreFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verifyTapClick)];
    [self.verifyView addGestureRecognizer:tap];
}

- (void)verifyTapClick
{
    [MyAOPManager relateStatistic:@"ClickRealNameAuthenticationOfWelfareCentrePage" Info:@{}];
    [AuthAlertView showAuthAlertViewWithDelegate:self];
}

- (void)onAuthSuccess
{
    if (self.authVerifySuccess) {
        self.authVerifySuccess();
    }
}

@end
