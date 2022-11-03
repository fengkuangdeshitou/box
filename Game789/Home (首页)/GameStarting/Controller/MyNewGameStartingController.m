//
//  MyNewGameStartingController.m
//  Game789
//
//  Created by Maiyou on 2020/8/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewGameStartingController.h"
#import "MyGamePreviewController.h"
#import "MyTodayStartingController.h"
#import "MyNewGameTopTenController.h"

@interface MyNewGameStartingController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (nonatomic, strong) UIButton * selectedBtn;
@property (nonatomic, strong) YNPageViewController *pageVc;

@end

@implementation MyNewGameStartingController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navBar.hidden = YES;
    self.navBar.title = @"";
    self.navBar.leftButton.hidden = YES;
    self.navBar.backgroundColor = ColorWhite;
    self.view.backgroundColor = BackColor;
    self.navBar.lineView.backgroundColor = FontColorDE;
    self.topView_top.constant = kStatusBarAndNavigationBarHeight + 1;
    self.selectedBtn = self.topButton;
    
    [self setupPageVC];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入新游首发页面事件
    [MyAOPManager relateStatistic:@"NewGamesViewAppear" Info:@{}];
}

- (NSArray *)getArrayTitles
{
    return @[@"今日首发".localized, @"一周新游Top10".localized, @"新游预约".localized];
}

- (NSMutableArray *)getArrayVCs
{
    MyTodayStartingController * today = [MyTodayStartingController new];
    MyNewGameTopTenController * game  = [MyNewGameTopTenController new];
    MyGamePreviewController * preview = [MyGamePreviewController new];
    
    NSMutableArray * array = [NSMutableArray arrayWithObjects:today, game, preview, nil];
    return array;
}

- (void)setupPageVC
{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = NO;
    configration.pageScrollEnabled = NO;
    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 0.5;
    configration.bottomLineBgColor = FontColorDE;
    configration.normalItemColor = [UIColor colorWithHexString:@"#282828"];
    configration.selectedItemColor = [UIColor colorWithHexString:@"#282828"];
    configration.itemFont = [UIFont systemFontOfSize:14];
    configration.selectedItemFont = [UIFont systemFontOfSize:14];
    configration.lineHeight = 3;
    configration.lineCorner = 1.5;
    configration.lineColor = MAIN_COLOR;
    configration.lineLeftAndRightMargin = (kScreenW / [self getArrayVCs].count - 18) / 2;
    configration.lineBottomMargin = 5;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = 0;
    configration.isTodayStarting = YES;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    vc.headerView = [UIView new];
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    vc.view.backgroundColor = UIColor.whiteColor;
    vc.view.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight + 35, kScreenW, kScreenH);
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    self.pageVc = vc;
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index
{
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[MyGamePreviewController class]])
    {
        return [(MyGamePreviewController *)vc tableView];
    }
    else if ([vc isKindOfClass:[MyTodayStartingController class]])
    {
        return [(MyTodayStartingController *)vc tableView];
    }
    else
    {
        return [(MyNewGameTopTenController *)vc tableView];
    }
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress
{
    
}

- (void)pageViewController:(YNPageViewController *)pageViewController
                 didScroll:(UIScrollView *)scrollView
                  progress:(CGFloat)progress
                 formIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    MYLog(@"========================%ld ---- %f ----%ld", (long)toIndex, progress, (long)index);
    NSArray * array = @[@"ClickStartingTodayTab", @"ClickTop10OOfTheWeekTab", @"ClickNewGameReservationsTab"];
    [MyAOPManager relateStatistic:array[index] Info:@{}];
}

- (void)pageViewController:(YNPageViewController *)pageViewController didEndDecelerating:(UIScrollView *)scrollView{
//    if ([pageViewController isKindOfClass:[MyNewGameTopTenController class]]) {
//        ((MyNewGameTopTenController *)pageViewController).tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight+43, ScreenWidth, kScreenH - kTabbarHeight - 43 - kStatusBarAndNavigationBarHeight);
//    }
}

- (IBAction)topButtonClick:(id)sender
{
    UIButton * button = sender;
    if (self.selectedBtn != button)
    {
        [self.pageVc setSelectedPageIndex:button.tag - 10];
        self.selectedBtn = button;
    }
}

@end
