//
//  CloudGameDescViewController.m
//  Game789
//
//  Created by maiyou on 2022/4/27.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "CloudGameDescViewController.h"
#import "BTCoverVerticalTransition.h"

@interface CloudGameDescViewController ()

@property(nonatomic,weak)IBOutlet UIView * downloadView;
@property(nonatomic,strong) BTCoverVerticalTransition * transition;
@end

@implementation CloudGameDescViewController

- (instancetype)initWithStatus:(BOOL)isStart
{
    self = [super init];
    if (self) {
        self.transition = [[BTCoverVerticalTransition alloc] initPresentViewController:self withRragDismissEnabal:true];
        self.transitioningDelegate = self.transition;
        self.isStart = isStart;
        self.downloadView.hidden = isStart;
        
        [self updateCollection:self.traitCollection];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateCollection:(UITraitCollection *)traitcollection{
    self.preferredContentSize = CGSizeMake(ScreenWidth, self.isStart ? 260 : 316.5);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

- (IBAction)dismiss{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)vipBtnClick:(id)sender
{
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.btnClick)
        {
            weakSelf.btnClick(weakSelf.isStart);
        }
    }];
}

- (IBAction)waitBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cloudGameClick:(id)sender
{
    WEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.btnClick)
        {
            weakSelf.btnClick(weakSelf.isStart);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
