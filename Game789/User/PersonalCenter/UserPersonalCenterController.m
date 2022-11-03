//
//  UserPersonalCenterController.m
//  Game789
//
//  Created by Maiyou on 2018/10/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "UserPersonalCenterController.h"
#import "YNPageViewController.h"
#import "UIView+YNPageExtend.h"
#import "UserPersonalCenterView.h"
#import "SecureViewController.h"
#import "MyPersonalAnswerViewController.h"
#import "MyPersonalQuestionViewController.h"

#import "PersonalCenterApi.h"

#import "GameCommitDetailController.h"
#import "GameCommitMoreController.h"
#import "PublishedCommentController.h"
#import "PlayedGamesController.h"
#import "GameReviewContainerView.h"
#import "GameCircleContainerView.h"

@interface UserPersonalCenterController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView * navView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UserPersonalCenterView * headerView;

@end

@implementation UserPersonalCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    
//    [self setupPageVC];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getMyCommentInfo];
}

- (void)prepareBasic
{
    
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.lineView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBar.title = @"我的足迹";
    self.navBar.titleLable.textColor = UIColor.whiteColor;
    [self.navBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back-1"]];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    
    // 游戏点评
    GameReviewContainerView * gameReview = [[GameReviewContainerView alloc] initWithFrame:self.scrollView.bounds];
    [gameReview requestWithUserid:self.user_id];
    [self.scrollView addSubview:gameReview];
    
    // 游戏圈子
//    GameCircleContainerView * gameCircle = [[GameCircleContainerView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, self.scrollView.width, self.scrollView.height)];
//    [gameCircle requestWithUserid:self.user_id];
//    [self.scrollView addSubview:gameCircle];
    
    [self.view bringSubviewToFront:self.navBar];
    
}

#pragma mark - 获取个人主页的信息
- (void)getMyCommentInfo
{
    PersonalCenterApi * api = [[PersonalCenterApi alloc] init];
    api.user_id = self.user_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.headerView.dataDic = [request.data deleteAllNullValue];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.height, ScreenWidth, ScreenHeight-self.headerView.height)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, 0);
    }
    return _scrollView;
}

- (void)rightButtonAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[SecureViewController new] animated:YES];
}



- (void)setupPageVC
{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.lineBottomMargin = 5;
    configration.lineLeftAndRightAddWidth = -((kScreenW / 4) - 18) / 2;
    configration.bottomLineHeight = 0.5;
    configration.bottomLineBgColor = [UIColor colorWithHexString:@"#DEDEDE"];
    configration.lineColor = MAIN_COLOR;
    configration.lineHeight = 3;
    configration.normalItemColor = FontColor66;
    configration.selectedItemColor = FontColor28;
    configration.itemFont = [UIFont systemFontOfSize:14];
    configration.selectedItemFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = kStatusBarAndNavigationBarHeight;
    
    
//    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
//                                                                                titles:[self getArrayTitles]
//                                                                                config:configration];
//    vc.dataSource = self;
//    vc.delegate = self;
//    vc.headerView = [self creatHeaderView];
    /// 指定默认选择index 页面
//    vc.pageIndex = 0;
    /// 作为自控制器加入到当前控制器
//    [vc addSelfToParentViewController:self];
    
    [self.view addSubview:self.navView];
}

- (UserPersonalCenterView *)headerView{
    if (!_headerView) {
        WEAKSELF
        _headerView = [[UserPersonalCenterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, IS_IPhoneX_All ? 250 : 230)];
        _headerView.exchangeButtonBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
        };
    }
    return _headerView;
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index
{
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[PublishedCommentController class]])
    {
        return [(PublishedCommentController *)vc tableView];
    }
    else if ([vc isKindOfClass:[MyPersonalQuestionViewController class]])
    {
        return [(MyPersonalQuestionViewController *)vc tableView];
    }
    else if ([vc isKindOfClass:[MyPersonalAnswerViewController class]])
    {
        return [(MyPersonalAnswerViewController *)vc tableView];
    }
    else {
        return [(PlayedGamesController *)vc tableView];
    }
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
    self.navView.backgroundColor = MYAColor(255, 255, 255, progress);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x/kScreenW;
        [self.headerView didselectedIndex:index];
    }
}

@end
