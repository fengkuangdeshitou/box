//
//  MyGamePreviewController.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGamePreviewController.h"

#import "MyGamePreviewCell.h"

#import "MyGetGamePreviewApi.h"

@interface MyGamePreviewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyGamePreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    
    if (self.isReserved)
    {
        self.navBar.title = @"我的预约";
    }
    else
    {
        self.navBar.title = @"新游预约";
    }
    [self loadData];
    
    [self getGamePreviewList:YES Data:^(BOOL isSuccess) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isReserved)
    {
        //我的页面统计
        [MyAOPManager relateStatistic:@"BrowseTheNewGameReservationPage" Info:@{}];
    }
}

- (void)myPreviewGame
{
    CGFloat buttonY = self.isHomeMore ? kScreen_height - kTabbarSafeBottomMargin - 60 : kScreen_height - kTabbarSafeBottomMargin - 60 - SegmentViewHeight - 42;
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 80, buttonY - kTabbarHeight, 80, 30)];
    [button setImage:MYGetImage(@"my_reserve_game") forState:0];
    [button addTarget:self action:@selector(pushToMyReserveList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.tableView];
}

- (void)pushToMyReserveList:(UIButton *)button
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    MyGamePreviewController * preview = [MyGamePreviewController new];
    preview.hidesBottomBarWhenPushed = YES;
    preview.isReserved = YES;
    preview.changePreviewStatus = ^{
        [self getGamePreviewList:NO Data:nil];
    };
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)getGamePreviewList:(BOOL)isShow Data:(RequestData)block
{
    MyGetGamePreviewApi * api = [[MyGetGamePreviewApi alloc] init];
    api.isReserved = self.isReserved;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (api.success == 1)
        {
            NSArray * array = api.data[@"game_list"];
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.dataArray addObjectsFromArray:array];
            }
            
            NSDictionary *dic = api.data[@"paginated"];
            UIView * view = [self creatFooterView];
            view.backgroundColor = BackColor;
            [self setFooterViewState:self.tableView Data:dic FooterView:view];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
            
        } else {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat height = (self.isHomeMore || self.isReserved) ? kTabbarSafeBottomMargin : (43 + kTabbarHeight);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kStatusBarAndNavigationBarHeight)];
        footerView.backgroundColor = UIColor.clearColor;
        _tableView.tableFooterView = footerView;
        [self.view addSubview:_tableView];
        
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:self.isReserved ? @"暂时还未预约游戏哦～" : @"暂时没有预约游戏哦～" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        if (!self.isReserved)
        {
            [self myPreviewGame];
        }
    }
    return _tableView;
}

#pragma mark TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
//    view.backgroundColor = BackColor;
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    MyGamePreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyGamePreviewCell" owner:self options:nil].firstObject;
    }
    NSDictionary * dic = [self.dataArray[indexPath.section] deleteAllNullValue];
    cell.video_url = dic[@"video_url"];
    cell.urlArray = dic[@"game_ur_list"];
    [cell setModelDic:dic];
    cell.currentVC = self;
    cell.PreviewGameAction = ^(BOOL isReserved) {
        [self actionAuccessRefreshData:isReserved IndexPath:indexPath Data:dic];
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
    detailVC.isReserve = YES;
    detailVC.gameID = self.dataArray[indexPath.section][@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.previewAction = ^(BOOL isReserved) {
        [weakSelf getGamePreviewList:NO Data:nil];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance && !self.isLoading && self.hasNextPage) {
        self.isLoading = YES;
        [self.tableView.mj_footer beginRefreshing];
    } else {
        if (self.isLoading) {
            self.isLoading = NO;
        }
    }
}

- (void)actionAuccessRefreshData:(BOOL)isReserved IndexPath:(NSIndexPath *)indexPath Data:(NSDictionary *)dic
{
    //只有我的预约，取消预约移除当前的数据
    if (isReserved)
    {
        [self.dataArray addObject:dic];
    }
    else
    {
        [self.dataArray removeObjectAtIndex:indexPath.section];
    }
    
//    else
//    {//预约界面直接更改预约状态
//        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:dic1];
//    }
    
    if (self.changePreviewStatus)
    {
        self.changePreviewStatus();
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getGamePreviewList:NO Data:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getGamePreviewList:NO Data:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
