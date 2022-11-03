//
//  TUAlerterView.m
//  TuuDemo
//
//  Created by 张鸿 on 16/3/8.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import "TUAlerterView.h"


@interface TUAlerterView ()<UIAlertViewDelegate>
@property (strong, nonatomic) UIAlertView *alert;
@property (copy, nonatomic) void(^completion)();
@property (copy, nonatomic) void(^verifyCompletion)(BOOL isVerify);
@end

@implementation TUAlerterView
DEF_SINGLETON(TUAlerterView)
- (void)showWithTitle:(NSString *)title Completion:(void(^)())completion
{
    self.completion = completion;
    [self showWithTitle:title];
}
- (void)showWithTitle:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle  Completion:(void(^)(BOOL isVerify))completion
{
    self.verifyCompletion = completion;
    self.alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    NSLog(@"＝＝＝＝%@",title);
    [self.alert show];
}

- (void)showWithTitle:(NSString *)title 
{
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    NSLog(@"＝＝＝＝%@",title);
    [alert show];
    [self performSelector:@selector(alertDismiss:) withObject:alert afterDelay:1];
}
- (void)alertDismiss:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if (_completion) {
        _completion();
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (alertView == self.alert) {
        if (buttonIndex == 1) {
            if (_verifyCompletion) {
                _verifyCompletion(YES);
            }
        }else{
            if (_verifyCompletion) {
                _verifyCompletion(NO);
            }
        }
    }
}

@end
