//
//  MyGameGiftDetailController.m
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGameGiftDetailController.h"

#import "MyGameGiftDetailView.h"

#import "GiftDetailApi.h"

@interface MyGameGiftDetailController ()

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) MyGameGiftDetailView * giftView;
@end

@implementation MyGameGiftDetailController

- (instancetype)init
{
    if ([super init])
    {
        _aniamtion = [[BTCoverVerticalTransition alloc] initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNoticeDetailApiRequest];
}

- (MyGameGiftDetailView *)giftView
{
    if (!_giftView)
    {
        WEAKSELF
        _giftView = [[MyGameGiftDetailView alloc] initWithFrame:self.view.bounds];
        _giftView.gift_id = self.gift_id;
        _giftView.isReceived = self.isReceived;
        _giftView.vc = weakSelf.vc;
        _giftView.receivedGiftCodeBlock = ^{
            if (weakSelf.receivedGiftCodeBlock) {
                weakSelf.receivedGiftCodeBlock();
            }
        };
        [self.view addSubview:_giftView];
    }
    return _giftView;
}

- (void)getNoticeDetailApiRequest
{
    GiftDetailApi *api = [[GiftDetailApi alloc] init];
    api.isShow = YES;
    api.gift_id = self.gift_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleNoticeSuccess:(GiftDetailApi *)api
{
    if (api.success == 1)
    {
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[api.data[@"data"] objectForKey:@"gift_info"]];
        self.giftView.dataDic = dic;
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)rightBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, kScreenH * 0.6);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)dealloc{
    NSLog(@"!!~~");
}

@end
