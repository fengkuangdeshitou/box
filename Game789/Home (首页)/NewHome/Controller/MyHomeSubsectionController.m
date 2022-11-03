//
//  MyGameVideoSubsectionController.m
//  Game789
//
//  Created by Maiyou on 2020/4/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeSubsectionController.h"
#import "RankingMyViewController.h"
#import "MyGameVideoTrackController.h"
#import "MyHomeGameListController.h"
#import "HGNavbarSearchView.h"
#import "SGPagingView.h"
#import "MyNewGameStartingController.h"
#import "SegmentTypeApi.h"
#import "MyProjectGameController.h"
#import "RecommendViewController.h"
@class GetMiluVipCionsApi;
#import "MyGetMuliVipCoinsView.h"
#import "NoNetwrokView.h"
#import "InternalTestingViewController.h"

@interface MyHomeSubsectionController () <UIScrollViewDelegate, YNPageScrollMenuViewDelegate, SGPageTitleViewDelegate,NoNetwrokViewDelegate>

@property (nonatomic, strong) NSArray * vcArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) YNPageScrollMenuView *menuView;
@property (nonatomic, strong) HGNavbarSearchView * NavView;
@property (nonatomic , strong) CGXPopoverManager *manager;
@property (nonatomic, strong) RankingMyViewController * awemeList;
@property (nonatomic, strong) MyHomeGameListController * homeVc;
@property (nonatomic, strong) MyNewGameStartingController * gameVC;
@property (nonatomic, strong) MyProjectGameController * project;
@property (nonatomic, strong) WebViewController * web;
@property (nonatomic, strong) RecommendViewController * recommend;
@property (nonatomic, strong) InternalTestingViewController * testing;

@property (nonatomic, assign) BOOL isOpenDanmu;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UIImageView * newImageView;
@property (nonatomic, strong) UIColor * navBackgroundColor;
@property (nonatomic, strong) SGPageTitleView * pageTitleView;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NoNetwrokView *noNetwork;

@end

@implementation MyHomeSubsectionController

- (UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

- (UIImageView *)newImageView
{
    if (!_newImageView)
    {
        _newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_section_new_icon"]];
    }
    return _newImageView;
}

- (NoNetwrokView *)noNetwork{
    if (!_noNetwork) {
        _noNetwork = [NoNetwrokView sharedInstance];
    }
    _noNetwork.delegate = self;
    return _noNetwork;
}

- (void)onAgainRequestAction
{
    AppDelegate *delegate =  (AppDelegate*)UIApplication.sharedApplication.delegate;
    [delegate getTopButtonCount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.lineView.hidden = YES;
    self.navBackgroundColor = [UIColor clearColor];
    self.navBar.backgroundColor = self.navBackgroundColor;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScrollOffsetY:) name:@"RefreshScrollOffsetY" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAction:) name:NSStringFromClass([self class]) object:nil];
    
    [[DeviceInfo shareInstance] addObserver:self forKeyPath:@"navList" options:NSKeyValueObservingOptionNew context:nil];
        
    [self getPromoteGameID];
    
    //获取下载至尊版是否要发金币
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YYToolModel shareInstance] getMiluVipCions];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"navList"]) {
        DeviceInfo * device = object;
        if (device.navList.count == 0) {
            [self.view addSubview:self.noNetwork];
            [self.noNetwork show];
        }else{
            [self.noNetwork dismiss];
            if (self.flag == false) {
                self.flag = true;
                [self addChildVC];
            }
        }
    }
}

- (void)scrollTopAction:(NSNotification *)noti
{
    if (self.selectedIndex == 0)
    {
        [self.homeVc.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    NSNumber * number = noti.object;
    //双击刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([number boolValue])
        {
            if (self.selectedIndex == 0)
            {
                [self.homeVc.tableView.mj_header beginRefreshing];
            }
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat ratio = self.homeVc.tableView.contentOffset.y / self.homeVc.topBackView.height;
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    [UIApplication sharedApplication].statusBarStyle = index == 0 ? (ratio >= 0.6 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent) : UIStatusBarStyleDefault;
    
//    [self.awemeList videoViewAppear];
    [self.homeVc homeViewOpen];
    NSDictionary * obj = DeviceInfo.shareInstance.navList[self.selectedIndex];
    NSString * type = obj[@"type"];
    if([type isEqualToString:@"active"]){
        NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", obj[@"value"], [obj[@"value"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        self.web.urlString = url;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //获取当前版本
    [appd getVersionApiRequest];
}

- (void)addChildVC
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, ScreenHeight - kTabbarHeight)];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * DeviceInfo.shareInstance.navList.count, 0);
    _scrollView.delegate = self;
    [self.view insertSubview:_scrollView belowSubview:self.navBar];
    
    NSArray * navList = [DeviceInfo shareInstance].navList;
    NSMutableArray * titleArray = [[NSMutableArray alloc] init];
    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
    NSMutableArray * selectImageArray = [[NSMutableArray alloc] init];

    for (int i=0; i<navList.count; i++) {
        NSDictionary * obj = navList[i];
        NSLog(@"obj=%@",obj);
        [titleArray addObject:obj[@"title"]];
        [imageArray addObject:obj[@"small_title_img"]];
        [selectImageArray addObject:obj[@"big_title_img"]];
    }
    NSArray *titleArr = titleArray;
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    configure.titleSelectedFont = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    configure.titleColor = ColorWhite;
    configure.titleSelectedColor = ColorWhite;
    configure.equivalence = NO;
    configure.contentInsetSpacing = 10;
    configure.titleAdditionalWidth = 28;
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.titleGradientEffect = YES;
//    configure.titleTextZoom = YES;
//    configure.titleTextZoomRatio = 0.5;
    configure.showBottomSeparator = NO;
    configure.showVerticalSeparator = NO;
    configure.showIndicator = NO;
    
    SGPageTitleView * titleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW - 76.5, 44) delegate:self titleNames:titleArr configure:configure];
    titleView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:titleView];
    self.pageTitleView = titleView;
        
    [titleView setImages:imageArray selectedImages:selectImageArray imagePositionType:SGImagePositionTypeDefault spacing:0];
    for (int i=0; i<navList.count; i++) {
        NSDictionary * obj = navList[i];
        NSString * small_title_img = obj[@"small_title_img"];
        if (small_title_img.length > 0) {
            [titleView resetTitle:@"" forIndex:i];
        }
    }
    
    HGNavbarSearchView * view = [[HGNavbarSearchView alloc] initWithFrame:CGRectMake(kScreenW - 80, self.navBar.height - 44, 80, 44)];
    view.currentVC = self;
    view.isVideo = NO;
    view.isHome = true;
    view.SearchBtnClick = ^(BOOL value) {
        [self selectButtonAction];
    };
    [self.navBar addSubview:view];
    self.NavView = view;
}

- (NSArray *)allItems
{
    NSMutableArray * actionAry = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i++)
    {
        CGXPopoverItem *action = [CGXPopoverItem actionWithTitle:self.titleArray[i]];
        action.titleColor = FontColor28;
        action.alignment = NSTextAlignmentCenter;
        [actionAry addObject:action];
    }
    return actionAry;
}

- (void)selectButtonAction
{
    WEAKSELF
    CGXPopoverView *popoverView = [[CGXPopoverView alloc] initWithFrame:CGRectNull WithManager:self.manager];
    [popoverView showToPoint:CGPointMake(kScreenW - 25, kStatusBarAndNavigationBarHeight) SelectItem:^(CGXPopoverItem *item, NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            [self danmuStatus];
            item.title = weakSelf.isOpenDanmu ? @"关闭弹幕" : @"打开弹幕";
        } else {
            MyGameVideoTrackController * track = [MyGameVideoTrackController new];
            track.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:track animated:YES];
        }
    }];
}

- (void)danmuStatus
{
    WEAKSELF
    weakSelf.isOpenDanmu = !weakSelf.isOpenDanmu;
    [YYToolModel saveUserdefultValue:[NSNumber numberWithBool:weakSelf.isOpenDanmu] forKey:@"SaveDanmuStatus"];
    
    //获取当前显示的cell
//    AwemeListCell *cell = [weakSelf.awemeList.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.awemeList.currentIndex inSection:0]];
//    if (weakSelf.isOpenDanmu)
//    {
//        [cell play:YES];
//    }
//    else
//    {
//        cell.showIndex = 0;
//        [cell.barrageManager stop];
//
//        [[MyVideoPlayerManager shareManager].barrageArray enumerateObjectsUsingBlock:^(OCBarrageManager * obj, NSUInteger idx, BOOL *stop) {
//            [obj stop];
//        }];
//    }
}

- (CGXPopoverManager *)manager
{
    if (!_manager)
    {
        _manager = [CGXPopoverManager new];
        _manager.style = CGXPopoverManagerItemDefault;
        _manager.showShade = NO;
        _manager.isAnimate = YES;
        _manager.hideAfterTouchOutside = YES;
        _manager.selectTitleColor = FontColor28;
        _manager.modleArray = [NSMutableArray arrayWithArray:[self allItems]];
        _manager.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _manager.arrowStyle = CGXPopoverManagerArrowStyleTriangle;
    }
    return _manager;
}

#pragma mark — 接收首页tableView滚动的距离
- (void)refreshScrollOffsetY:(NSNotification *)noti
{
    NSNumber * number = noti.object;
    CGFloat y = number.floatValue;
    CGFloat ratio = y / self.homeVc.topBackView.height;
    if (ratio >= 1)
    {
        self.navBackgroundColor = ColorWhite;
    }
    else
    {
        self.navBackgroundColor = [ColorWhite colorWithAlphaComponent:ratio];
    }
    [self.NavView.showBtn1 setImage:MYGetImage(ratio >= 0.6 ? @"home_service_icon_black" : @"home_service_icon") forState:0];
    [self.NavView.showBtn2 setImage:MYGetImage(ratio >= 0.6 ? @"home_search_icon_black" : @"home_search_icon") forState:0];
    [self.pageTitleView resetTitleColor:ratio >= 0.6 ? FontColor66 : ColorWhite titleSelectedColor:ratio >= 0.6 ? FontColor28 : ColorWhite];
    [UIApplication sharedApplication].statusBarStyle = ratio >= 0.6 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    self.navBar.backgroundColor = self.navBackgroundColor;
}

#pragma mark — UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    NSDictionary * obj = DeviceInfo.shareInstance.navList[index];
    NSString * type = obj[@"type"];
    if([type isEqualToString:@"active"]){
        if (![YYToolModel islogin])
        {
            [self.scrollView setContentOffset:CGPointMake(ScreenWidth*self.pageTitleView.selectedIndex, 0)];
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            VC.quickLoginBlock = ^{
                self.scrollView.contentOffset = CGPointMake(index * kScreenW, 0);
                self.pageTitleView.resetSelectedIndex = index;
                [self.web.webView reload];
            };
            return;
        }
    }
    [self.pageTitleView setResetSelectedIndex:index];
    
//    [self switchViewChangeTabbar:index];
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    NSDictionary * obj = DeviceInfo.shareInstance.navList[selectedIndex];
    NSString * type = obj[@"type"];
    if([type isEqualToString:@"active"]){
        if (![YYToolModel islogin])
        {
            pageTitleView.resetSelectedIndex = self.scrollView.contentOffset.x/ScreenWidth;
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            VC.quickLoginBlock = ^{
                self.scrollView.contentOffset = CGPointMake(selectedIndex * kScreenW, 0);
                pageTitleView.resetSelectedIndex = selectedIndex;
                [self.web.webView reload];
            };
            return;
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(selectedIndex * kScreenW, 0);
    
    [self switchViewChangeTabbar:selectedIndex];
}

- (void)switchViewChangeTabbar:(NSInteger)index
{
    self.selectedIndex = index;
    
    NSDictionary * obj = DeviceInfo.shareInstance.navList[index];
    NSString * type = obj[@"type"];
    //切换修改顶部navbar的背景颜色
    BOOL isSetColor = [type isEqualToString:@"oneGame"] || [type isEqualToString:@"recommend"];
    self.navBar.backgroundColor = !isSetColor ? UIColor.whiteColor : self.navBackgroundColor;
    
    //统计
    [MyAOPManager relateStatistic:@"ClickTheTopTabOfHomePage" Info:@{@"tapName":obj[@"title"]}];
    
    UIColor * titleColorNormal   = ColorWhite;
    UIColor * titleColorSelected = ColorWhite;
    NSString * imageName1 = @"home_service_icon_black";
    NSString * imageName2 = @"home_search_icon_black";
    CGFloat ratio = 0;
    if ([type isEqualToString:@"recommend"]) {
        if (!self.homeVc) {
            //首页面
            MyHomeGameListController * homeVc = [MyHomeGameListController new];
            [homeVc.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
            [_scrollView addSubview:homeVc.view];
            [self addChildViewController:homeVc];
            self.homeVc = homeVc;
        }
        ratio = self.homeVc.tableView.contentOffset.y / self.homeVc.topBackView.height;
    }else if([type isEqualToString:@"newGame"]){
        if (!self.gameVC) {
            MyNewGameStartingController * homeVc = [MyNewGameStartingController new];
            [homeVc.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
            [_scrollView addSubview:homeVc.view];
//            homeVc.view.clipsToBounds = YES;
            [self addChildViewController:homeVc];
            self.gameVC = homeVc;
        }
        NSString * time = [NSDate getNowTimeTimestamp:@"yyyy-MM-dd"];
        [YYToolModel saveUserdefultValue:time forKey:@"MyNewGameReserve"];
        self.newImageView.hidden = YES;
    }else if([type isEqualToString:@"topGame"]){
        if (!self.awemeList) {
            RankingMyViewController * hallVc  = [RankingMyViewController new];
            [hallVc.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
            [_scrollView addSubview:hallVc.view];
            [self addChildViewController:hallVc];
            self.awemeList = hallVc;
        }
    }else if([type isEqualToString:@"special"]){
        int style = [obj[@"style"] intValue];
        if (style == 1) {
            if (!self.project) {
                MyProjectGameController * project  = [MyProjectGameController new];
                project.navBar.hidden = true;
                project.project_id = obj[@"value"];
                [project.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
                [_scrollView addSubview:project.view];
                [self addChildViewController:project];
                self.project = project;
            }
        }else if (style == 6){
            if (!self.testing) {
                InternalTestingViewController * test  = [InternalTestingViewController new];
                test.navBar.hidden = true;
                test.Id = obj[@"value"];
                [test.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
                [_scrollView addSubview:test.view];
                [self addChildViewController:test];
                self.testing = test;
            }
        }
        
    }else if([type isEqualToString:@"active"]){
        if (!self.web) {
            NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", obj[@"value"], [obj[@"value"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
            WebViewController * web  = [WebViewController new];
            web.urlString = url;
            web.navBar.hidden = true;
            [web.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
            [_scrollView addSubview:web.view];
            [self addChildViewController:web];
            self.web = web;
        } else {
            NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", obj[@"value"], [obj[@"value"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
            self.web.urlString = url;
//            [self.web.webView reload];
        }
    }
    else if([type isEqualToString:@"oneGame"]){
        if (!self.recommend) {
            RecommendViewController * recommend = [RecommendViewController new];
            recommend.gameId = obj[@"value"];
            [recommend.view setFrame:CGRectMake(kScreenW*index, 0, kScreenW, _scrollView.bounds.size.height)];
            [_scrollView addSubview:recommend.view];
            [self addChildViewController:recommend];
            self.recommend = recommend;
        }
//        ratio = self.recommend.tableView.contentOffset.y / self.homeVc.topBackView.height;
        self.navBar.backgroundColor = UIColor.clearColor;
    }
    
    if(![type isEqualToString:@"oneGame"]){
        [self.recommend stopPlayVideo];
    }
    
//    if(![type isEqualToString:@"recommend"]){
//        if (self.homeVc) {
//            CGPoint offset = self.homeVc.tableView.contentOffset;
//            [self.homeVc.tableView setContentOffset:offset animated:false];
//            NSNotification * notification = [[NSNotification alloc] initWithName:@"RefreshScrollOffsetY" object:[NSNumber numberWithFloat:offset.y] userInfo:nil];
//            [self refreshScrollOffsetY:notification];
//        }
//    }
    
    titleColorNormal = ratio >= 0.6 ?  FontColor66: ColorWhite;
    titleColorSelected = ratio >= 0.6 ? FontColor28 : ColorWhite;
    [self.pageTitleView resetTitleColor:!isSetColor ? FontColor66 : titleColorNormal titleSelectedColor:!isSetColor ? FontColor28 : titleColorSelected];
    
    imageName1 = ratio >= 0.6 ? @"home_service_icon_black" : @"home_service_icon";
    imageName2 = ratio >= 0.6 ? @"home_search_icon_black" : @"home_search_icon";
    [self.NavView.showBtn1 setImage:MYGetImage(isSetColor ? imageName1 : @"home_service_icon_black") forState:0];
    [self.NavView.showBtn2 setImage:MYGetImage(isSetColor ? imageName2 : @"home_search_icon_black") forState:0];
    
    //修改状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = index != 0 ? UIStatusBarStyleDefault : (ratio >= 0.6 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent);
    
//    }
//    if (self.awemeList && index != 2) {
//        AwemeListCell *cell = [self.awemeList.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.awemeList.currentIndex inSection:0]];
//        [cell pause];
//    }
}

#pragma mark ——— 获取推广的游戏id
- (void)getPromoteGameID
{
    NSString * gameid = [DeviceInfo shareInstance].myGameId;
    NSString * str = [YYToolModel getUserdefultforKey:@"MyPromoteGameID"];
    if (gameid && str == NULL)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YYToolModel saveUserdefultValue:@"1" forKey:@"MyPromoteGameID"];
            GameDetailInfoController * info = [GameDetailInfoController new];
            info.hidesBottomBarWhenPushed = YES;
            info.maiyou_gameid = gameid;
            [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
        });
    }
}

@end
