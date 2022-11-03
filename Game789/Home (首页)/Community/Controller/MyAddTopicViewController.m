//
//  MyAddTopicViewController.m
//  Game789
//
//  Created by Maiyou on 2020/12/22.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyAddTopicViewController.h"
#import "HGCommunicityTopicV.h"

@interface MyAddTopicViewController ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;

@end

@implementation MyAddTopicViewController

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
    
    HGCommunicityTopicV * topicView = [[HGCommunicityTopicV alloc] initWithFrame:self.view.bounds];
    topicView.topicBlock = ^(NSString *name, NSString *titleId) {
        if (self.AddTopicBlock) {
            self.AddTopicBlock(name, titleId);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:topicView];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, kScreenH * 0.7);
    
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
