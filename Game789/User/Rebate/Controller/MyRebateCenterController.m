//
//  MyRebateCenterController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRebateCenterController.h"
#import "MyReplyRebateListController.h"
#import "MyReplyRebateRecordsController.h"
#import "MyRebateNoticeInfoController.h"

@interface MyRebateCenterController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong) NSArray * vcArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MyRebateCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self addSegmentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //返利页面的统计
    [MyAOPManager relateStatistic:@"BrowseTheRebateApplicationPage" Info:@{}];
    
    if (self.selectedIndex == 0)
    {
        MyReplyRebateListController * list = self.vcArray[self.selectedIndex];
        [list.tableView.mj_header beginRefreshing];
    }
    else
    {
        MyReplyRebateRecordsController * record = self.vcArray[self.selectedIndex];
        [record.tableView.mj_header beginRefreshing];
    }
}

- (void)prepareBasic
{
    self.navBar.title = @"返利中心";
    self.view.backgroundColor = UIColor.whiteColor;
    self.selectedIndex = 0;
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"返利指南" titleColor:[UIColor colorWithHexString:@"#999999"]];
    [self.navBar setOnClickRightButton:^{
        MyRebateNoticeInfoController * info = [MyRebateNoticeInfoController new];
        [weakSelf.navigationController pushViewController:info animated:YES];
    }];
}

- (void)addSegmentView
{
    //设置标题
    NSArray *titleArr = @[@"申请返利".localized, @"申请记录".localized];
    //设置控制器
    self.vcArray = @[[MyReplyRebateListController new], [MyReplyRebateRecordsController new]];
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
        configration.pageStyle = YNPageStyleTop;
    configration.headerViewCouldScale = YES;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 0.5;
    configration.bottomLineBgColor = [UIColor colorWithHexString:@"#DEDEDE"];
    configration.lineHeight = 3;
    configration.lineCorner = 1.5;
    configration.lineColor = MAIN_COLOR;
    configration.lineLeftAndRightMargin = (kScreenW / self.vcArray.count - 18) / 2;
    configration.lineBottomMargin = 5;
    configration.normalItemColor  = FontColor66;
    configration.selectedItemColor = FontColor28;
    configration.itemFont = [UIFont systemFontOfSize:14];
    configration.selectedItemFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.vcArray
                                                              titles:titleArr
                                                              config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    vc.pageIndex = 0;
    vc.view.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight);
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index
{
    BaseViewController *baseVC = pageViewController.controllersM[index];
    if ([baseVC isKindOfClass:[MyReplyRebateListController class]])
    {
        return [(MyReplyRebateListController *)baseVC tableView];
    }
    else
    {
        return [(MyReplyRebateRecordsController *)baseVC tableView];
    }
}

- (void)pageViewController:(YNPageViewController *)pageViewController didScroll:(UIScrollView *)scrollView progress:(CGFloat)progress formIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.selectedIndex = toIndex;
    MYLog(@"==============%ld", (long)toIndex);
}

- (void)pageViewController:(YNPageViewController *)pageViewController didEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
