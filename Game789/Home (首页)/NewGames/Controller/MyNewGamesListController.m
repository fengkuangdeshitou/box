//
//  MyNewGamesListController.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewGamesListController.h"

#import "HomeListTableViewCell.h"
#import "MyNewGamePreviewCell.h"
#import "MyNewGamesHeaderView.h"
#import "MyNewGamesSectionView.h"

#import "MyGetNewGameListApi.h"
#import "MyNewGameRankApi.h"
#import "MyGetGamePreviewApi.h"

@interface MyNewGamesListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * previewArray;
@property (nonatomic, strong) MyNewGamesHeaderView * headerView;

@end

@implementation MyNewGamesListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"新游首发";
    
    [self getNewGameRankList];
    
    [self getGamePreviewList];
    
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入新游首发页面事件
    [MyAOPManager relateStatistic:@"NewGamesViewAppear" Info:@{}];
    
    [self.tableView reloadData];
}

- (UIView *)creatHeaderView
{
    MyNewGamesHeaderView * headerView = [[MyNewGamesHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 190)];
    headerView.currentVC = self;
    self.headerView = headerView;
    return headerView;
}

#pragma mark — 获取新游预约列表
- (void)getGamePreviewList
{
    MyGetGamePreviewApi * api = [[MyGetGamePreviewApi alloc] init];
    api.pageNumber = 1;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            self.previewArray = api.data[@"game_list"];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark — 获取排行榜数据
- (void)getNewGameRankList
{
    MyNewGameRankApi * api = [[MyNewGameRankApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.tableView.tableHeaderView = [self creatHeaderView];
            self.headerView.dataArray = api.data[@"game_list"];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark — 获取新游列表
- (void)getNewGameList
{
    MyGetNewGameListApi * api = [[MyGetNewGameListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 5;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
    {
        if (request.success == 1)
        {
            NSArray *array = [api.data objectForKey:@"list"];
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.dataArray addObjectsFromArray:array];
            }
            NSDictionary *dic = api.data[@"paginated"];
            if ([dic[@"more"] integerValue] == 0)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.tableFooterView = [UIView new];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeListTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyNewGamePreviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyNewGamePreviewCell"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
    }
    return _tableView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.previewArray.count > 0 ? 1 : 0;;
    }
    return [self.dataArray[section - 1][@"list"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.previewArray.count > 0 ? 165 : 0;
    }
    return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyNewGamesSectionView * sectionView = [[MyNewGamesSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    sectionView.currentVC = self;
    
    if (section == 0)
    {
        sectionView.showTitle.text = @"新游预约".localized;
        sectionView.moreView.hidden = NO;
        return self.previewArray.count > 0 ? sectionView : [UIView new];
    }
    else
    {
        NSDictionary * dic = self.dataArray[section - 1];
        NSString * time = [NSDate getCurrentTimes:@"YYYY-MM-dd"];
        
        CGFloat yesterdayTime =[[NSDate getNowTimeTimestamp] doubleValue] - 24 * 60 * 60;
        NSString * time1 = [NSDate dateTimeStringWithTS:yesterdayTime];
        
        sectionView.moreView.hidden = YES;
        
        if ([time isEqualToString:dic[@"group"]])
        {
            sectionView.showTitle.text = @"今日首发".localized;
        }
        else if ([time1 isEqualToString:dic[@"group"]])
        {
            sectionView.showTitle.text = @"昨日首发".localized;
        }
        else
        {
            sectionView.showTitle.text = dic[@"group"];
        }
    }
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.previewArray.count > 0 ? 50 : 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *reuseID = @"MyNewGamePreviewCell";
        MyNewGamePreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.dataArray = self.previewArray;
        return cell;
    }
    else
    {
        static NSString *reuseID = @"HomeListTableViewCell";
        HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        NSDictionary * dic = [self.dataArray[indexPath.section - 1][@"list"][indexPath.row] deleteAllNullValue];
        [cell setModelDic:dic];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    
    if (indexPath.section > 0)
    {
        NSDictionary * dic = [self.dataArray[indexPath.section - 1][@"list"][indexPath.row] deleteAllNullValue];
        [MyAOPManager gameRelateStatistic:@"ViewGameDetailsOnNewGameReservationsPage" GameInfo:dic Add:@{}];
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic[@"game_id"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getNewGameList];
        [self getGamePreviewList];
        [tableView.mj_header endRefreshing];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getNewGameList];
        [tableView.mj_footer endRefreshing];
    }];
}

@end
