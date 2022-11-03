//
//  AwemeListController.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "Aweme.h"
#import "AwemeListController.h"
#import "AVPlayerView.h"
#import "NetworkHelper.h"
#import "LoadMoreControl.h"
#import "AVPlayerManager.h"
#import "MyAllGameVideosApi.h"
#import "UIScrollView+ListViewAutoplaySJAdd.h"

NSString * const kAwemeListCell   = @"AwemeListCell";

@interface AwemeListController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SJPlayerAutoplayDelegate>

@property (nonatomic, assign) BOOL                              isCurPlayerPause;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, copy) NSString                            *uid;

@property (nonatomic, strong) NSMutableArray<Aweme *>           *awemes;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation AwemeListController

- (instancetype)initWithVideoData:(NSMutableArray<Aweme *> *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid {
    self = [super init];
    if(self) {
        _isCurPlayerPause = NO;
        _currentIndex = currentIndex;
        _awemeType = type;
        _uid = uid;
        
        _awemes = [data mutableCopy];
        _data = [[NSMutableArray alloc] initWithObjects:[_awemes objectAtIndex:_currentIndex], nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCurPlayerPause = NO;
    
    [self.navBar.leftButton setImage:[UIImage imageNamed:@"back-1"] forState:0];
    if (!self.isTrack)
    {
        _currentIndex = 0;
    }
    WEAKSELF
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.lineView.hidden = YES;
    [self.navBar wr_setRightButtonWithImage:[UIImage imageNamed:@"danmu_close_bg"]];
    [self.navBar.rightButton setImage:[UIImage imageNamed:@"danmu_open_bg"] forState:UIControlStateSelected];
    self.navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.navBar setOnClickRightButton:^{
        [weakSelf rightBtnClick];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVideoListLikeStatus:) name:@"ChangeCurrentVideoList" object:nil];
    
    [self setBackgroundImage:@"img_video_loading"];
    [self setUpView];
        
    [self initNavigationBarTransparent];
    
    [self getAllGameVideosList];
}

- (void)changeVideoListLikeStatus:(NSNotification *)noti
{
    Aweme * aweme = noti.object;
    if (aweme)
    {
        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        [self.data enumerateObjectsUsingBlock:^(Aweme * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Aweme * aweme1 = obj;
            //如果从足迹传过来的是当前显示的cell则调用改变点赞的方法
            if ([aweme.game_id isEqualToString:aweme1.game_id])
            {
                aweme1.videoIsLiked = aweme.videoIsLiked;
                [cell changeLikeStatus:aweme];
                *stop = YES;
            }
            else
            {
                
            }
        }];
    }
}

- (void)rightBtnClick
{
    WEAKSELF
    weakSelf.navBar.rightButton.selected = !weakSelf.navBar.rightButton.selected;
    [YYToolModel saveUserdefultValue:[NSNumber numberWithBool:weakSelf.navBar.rightButton.selected] forKey:@"SaveDanmuStatus"];
    
    //获取当前显示的cell
    AwemeListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:0]];
    if (weakSelf.navBar.rightButton.selected)
    {
        [cell play:NO];
    }
    else
    {
        cell.showIndex = 0;
        [cell.barrageManager stop];
        
        [[MyVideoPlayerManager shareManager].barrageArray enumerateObjectsUsingBlock:^(OCBarrageManager * obj, NSUInteger idx, BOOL *stop) {
            [obj stop];
        }];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -(ScreenHeight - kTabbarHeight), ScreenWidth, (ScreenHeight - kTabbarHeight) * 3)];
        _tableView.contentInset = UIEdgeInsetsMake((ScreenHeight - kTabbarHeight), 0, (ScreenHeight - kTabbarHeight) * 1, 0);
       
        _tableView.backgroundColor = ColorClear;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
//        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView sj_enableAutoplayWithConfig:[SJPlayerAutoplayConfig configWithPlayerSuperviewTag:101 autoplayDelegate:self]];
        [_tableView sj_needPlayNextAsset];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:AwemeListCell.class  forCellReuseIdentifier:kAwemeListCell];
        [self.view addSubview:_tableView];
        
        [self.view bringSubviewToFront:self.navBar];
        
        [self loadData];
    }
    return _tableView;
}

- (void)setUpView
{
    self.view.layer.masksToBounds = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.data = self.awemes;
        
//        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
//        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
//                                      animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });
}

- (void)loadView
{
    [super loadView];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMaterialUI" object:[NSNumber numberWithBool:YES]];
}

- (void)videoViewAppear
{
    //统计进入视频页面统计
    [MyAOPManager relateStatistic:@"BrowseHomeVideoPage" Info:@{}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber * num = [YYToolModel getUserdefultforKey:@"SaveDanmuStatus"];
    if (num != NULL)
    {
        self.navBar.rightButton.selected = num.boolValue;
    }
    else
    {
        self.navBar.rightButton.selected = YES;
        [YYToolModel saveUserdefultValue:[NSNumber numberWithBool:self.navBar.rightButton.selected] forKey:@"SaveDanmuStatus"];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMaterialUI" object:[NSNumber numberWithBool:YES]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMaterialUI" object:[NSNumber numberWithBool:NO]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self applicationEnterBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![NetworkHelper isWifiStatus])
    {
        [MBProgressHUD showToast:@"当前为非WiFi环境，请注意流量消耗" toView:self.view];
    }
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAwemeListCell forIndexPath:indexPath];
    cell.currentVC = self;
    cell.isTrack  = self.isTrack;
    cell.rowIndex = indexPath.row;
    cell.currentIndex = self.currentIndex;
    [cell initData:_data[indexPath.row]];
    [cell startDownloadBackgroundTask];
    return cell;
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;

        self.pastIndex = self.currentIndex;

        if(translatedPoint.y < -100 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 100 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];

    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    MYLog(@"scrollViewDidEndDecelerating");
}

#pragma KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [cell startDownloadHighPriorityTask];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.player.playStatus == 5) {
            //播放视频
            [cell replay];
        }else {
            [[MyVideoPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
//            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play:NO];
                }
//            };
            
            if (self.currentIndex > self.data.count - 4)
            {
                self.pageNumber ++;
                [self getAllGameVideosList];
            }
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
//    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    if(!_isCurPlayerPause) {
//        [cell.playerView play];
//    }
}

- (void)applicationEnterBackground
{
    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [cell pause];
}


- (void)getAllGameVideosList
{
    __weak __typeof(self) wself = self;
    MyAllGameVideosApi * api = [[MyAllGameVideosApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 20;
    if (self.isTrack && self.pageIndex > 1)
    {
        api.count = 20 * self.pageIndex;
    }
    api.isTrack = self.isTrack ? @"1" : nil;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSArray * array = request.data[@"game_list"];
            array = [Aweme mj_objectArrayWithKeyValuesArray:array];
            self.tableView.ly_emptyView.contentView.hidden = NO;
            if (array.count == 0)
            {
                [MBProgressHUD showToast:@"暂无视频" toView:self.view];
                return;
            }
            
            if (self.pageNumber == 1)
            {
                if (wself.isRefresh)
                {
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    for (int i = 0; i < self.data.count; i ++)
                    {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [indexPaths addObject:indexPath];
                    }
                    [wself.data removeAllObjects];
                    // 再删除cell
                    [wself.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                }
                else
                {
                    wself.data = [NSMutableArray array];
                }
            }
//            else
//            {
                NSInteger count = wself.data.count;
                [wself.data addObjectsFromArray:array];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                for (int i = 0; i < array.count; i ++)
                {
                    count ++;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
                    [indexPaths addObject:indexPath];
                }
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [_tableView endUpdates];
//            }
            
            if (self.isTrack)//如果是足迹
            {
                [UIView animateWithDuration:0.2
                  delay:0.0
                options:UIViewAnimationOptionCurveEaseOut animations:^{
                    //UITableView滑动到指定cell
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                } completion:^(BOOL finished) {
                    //UITableView可以响应其他滑动手势
                    self.tableView.panGestureRecognizer.enabled = YES;
                }];
            }
            //在WiFi的情况下自动播放
            if ((wself.currentIndex == 0 || self.isTrack) && wself.pageNumber == 1)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AwemeListCell *cell = [wself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
                    if (cell.player.playStatus == 4 && cell.player.networkStatus == 2) {
                        [cell play:NO];
                    }
                });
            }
            wself.isRefresh = NO;
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.isRefresh = YES;
        self.pageNumber = 1;
        [self getAllGameVideosList];
        [tableView.mj_header endRefreshing];
    }];
    
//    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageNumber ++;
//        [self getAllGameVideosList];
//        [tableView.mj_footer endRefreshing];
//    }];
}

- (void)dealloc
{
    NSLog(@"======== dealloc =======");
    
    [_tableView.layer removeAllAnimations];
    NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
    for(AwemeListCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    if (self.currentIndex)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeObserver:self forKeyPath:@"currentIndex"];
    }
}

@end
