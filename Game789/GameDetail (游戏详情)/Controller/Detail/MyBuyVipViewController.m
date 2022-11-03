//
//  MyBuyVipViewController.m
//  Game789
//
//  Created by Maiyou001 on 2022/4/8.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyBuyVipViewController.h"
#import "MyBuyVipAlertView.h"

@interface MyBuyVipViewController ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic,strong) MyBuyVipAlertView *buyView;

@end

@implementation MyBuyVipViewController

- (instancetype)init
{
    if ([super init])
    {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
    self.navBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.buyView.dataDic = self.dataDic[@"vipSignMenu"];
    
    self.buyView.supremePayUrl = self.dataDic[@"supremePayUrl"];
}

- (MyBuyVipAlertView *)buyView
{
    if (!_buyView)
    {
        _buyView = [[MyBuyVipAlertView alloc] initWithFrame:self.view.bounds];
        _buyView.vc = self;
        [self.view addSubview:_buyView];
    }
    return _buyView;
}

- (void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 440);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)dealloc{
    NSLog(@"!!~~");
}

@end
