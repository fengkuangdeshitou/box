//
//  SaveMoneyCardViewController.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "SaveMoneyCardViewController.h"
#import "YNPageViewController.h"
#import "MoneyCardViewController.h"
#import "CardMemberViewController.h"
#import "CardMemberHeaderView.h"
#import "MoneyCardHeaderView.h"

#import "SaveMoneyAPI.h"

@interface SaveMoneyCardViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSDictionary * data;
@property(nonatomic,strong)MoneyCardViewController *vc_1;
@property(nonatomic,strong)CardMemberViewController *vc_2;
@property(nonatomic,strong)CardMemberHeaderView * headerView;
@property(nonatomic,strong)MoneyCardHeaderView * moneyCard;

@end

@implementation SaveMoneyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = YES;
    [self.navBar.leftButton setImage:MYGetImage(@"back-1") forState:0];
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    
    
    if (self.selectedIndex == 0) {
        self.navBar.title = @"省钱卡";
        SaveMoneyAPI * api = [[SaveMoneyAPI alloc] init];
        api.isShow = YES;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (api.success) {
                self.data = request.data;
                self.vc_1  = [[MoneyCardViewController alloc] init];
                [self addChildViewController:self.vc_1];
                self.vc_1.view.frame = self.view.bounds;
                [self.view addSubview:self.vc_1.view];
                self.vc_1.tableView.tableHeaderView = self.moneyCard;
                self.moneyCard.data = self.data;
                self.vc_1.data = self.data;
                [self.view bringSubviewToFront:self.navBar];
            }else{
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {

        }];
    }else{
        self.navBar.title = @"会员中心";
        CardMember * api = [[CardMember alloc] init];
        api.isShow = YES;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (api.success) {
                self.data = request.data;
                self.vc_2  = [[CardMemberViewController alloc] init];
                [self addChildViewController:self.vc_2];
                self.vc_2.view.frame = self.view.bounds;
                [self.view addSubview:self.vc_2.view];
                self.vc_2.tableView.tableHeaderView = self.headerView;
                self.headerView.data = self.data;
                self.vc_2.data = self.data[@"vip"];
                [self.view bringSubviewToFront:self.navBar];
                [self setHeaderViewDataWithIndex:self.selectedIndex];
            }else{
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {

        }];
    }
}

- (CardMemberHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CardMemberHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 91 + kStatusBarAndNavigationBarHeight)];
    }
    return _headerView;
}

- (MoneyCardHeaderView *)moneyCard{
    if (!_moneyCard) {
        _moneyCard = [[MoneyCardHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40 + kStatusBarAndNavigationBarHeight + (ScreenWidth-30)/345*150)];
    }
    return _moneyCard;
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    if(progress <= 0.01){
        //往上滑动，透明度为0
        self.navBar.backgroundColor = [UIColor clearColor];
        self.navBar.alpha = 1;
    }else{
        self.navBar.backgroundColor = [[UIColor colorWithHexString:@"#1C1714"] colorWithAlphaComponent:progress];
    }
}

- (void)setHeaderViewDataWithIndex:(NSInteger)index{
    self.headerView.button.hidden = index;
    self.headerView.levelImageView.hidden = index == 0;
    if (index == 0) {
        if ([self.data[@"money_saving_card"][@"is_buy"] boolValue]) {
            self.headerView.time.text = [NSString stringWithFormat:@"%@",self.data[@"money_saving_card"][@"end_date_time"]];
        }else{
            self.headerView.time.text = @"暂未购买".localized;
        }
    }else{
        if ([self.data[@"vip"][@"is_vip"] boolValue]) {
            self.headerView.time.text = [NSString stringWithFormat:@"%@",self.data[@"vip"][@"end_date_time"]];
        }else{
            self.headerView.time.text = @"暂未购买".localized;
        }
    }
}

@end
