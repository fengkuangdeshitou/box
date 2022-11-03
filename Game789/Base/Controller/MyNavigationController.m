//
//  MyNavigationController.m
//  Game789
//
//  Created by Maiyou on 2021/3/20.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyNavigationController.h"
#import "SettingDetailViewController.h"
#import "MyYouthModePwdController.h"

@interface MyNavigationController ()

@property (nonatomic,strong) CATransition *transition;

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (CATransition *)transition{
    if (!_transition) {
        _transition = [CATransition animation];
        _transition.duration = 0.25;
        _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _transition.type = kCATransitionFade;
        _transition.subtype = kCATransitionFromTop;
    }
    return _transition;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
                
        if (![viewController isKindOfClass:[SettingDetailViewController class]] && ![viewController isKindOfClass:[MyYouthModePwdController class]] && ![viewController isKindOfClass:[LoginViewController class]])
        {
            if ([DeviceInfo shareInstance].isOpenYouthMode)
            {
                [YJProgressHUD showMessage:@"当前为青少年模式暂不能访问！" inView:self.view];
                return;
            }
        }
    }
    [super pushViewController:viewController animated:YES];
    
//    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//        [super pushViewController:viewController animated:NO];
//    } completion:nil];
}

@end
