//
//  MyHomeCouponCenterController.m
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeCouponCenterController.h"
#import "MyVoucherListViewController.h"

#import "MyCouponCenterListCell.h"
#import "MyVoucherCenterSearchView.h"
#import "MyVoucherCenterHeaderView.h"

#import "MyGetVoucherListApi.h"
#import "MyHomeGameListApi.h"
@class MyReceiveVouchersListApi;
@class MyGetAllVouchersApi;
@class MyGetRecentGameVouchersApi;

@interface MyHomeCouponCenterController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * playArray;
@property (nonatomic, copy) NSString * searchText;
@property (nonatomic, strong) MyVoucherCenterHeaderView *headerView;

@end

@implementation MyHomeCouponCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self creatSearchView];
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self getRecentPlayGames];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //记录充值的事件
    [MyAOPManager relateStatistic:@"BrowseTheCouponsCenterPage" Info:@{}];
}

- (void)prepareBasic
{
    WEAKSELF
    self.navBar.title = @"领券中心".localized;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.navBar wr_setRightButtonWithTitle:@"我的代金券".localized titleColor:FontColor66];
    self.navBar.rightButton.width = 80;
    self.navBar.rightButton.x = kScreenW - 90;
    [self.navBar setOnClickRightButton:^{
        if ([YYToolModel isAlreadyLogin])
        {
            MyVoucherListViewController * list = [MyVoucherListViewController new];
            [weakSelf.navigationController pushViewController:list animated:YES];
        }
    }];
}

- (void)creatSearchView
{
    MyVoucherCenterSearchView * searchView = [[MyVoucherCenterSearchView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 44)];
    searchView.searchTextBlock = ^(NSString * _Nonnull text) {
        self.searchText = text;
        [self.tableView.mj_header beginRefreshing];
        
        [MyAOPManager relateStatistic:@"ClickTheSearchOfCouponCenter" Info:@{@"text":text}];
    };
    [self.view addSubview:searchView];
}

#pragma mark ——— 获取最近在玩的游戏
- (void)getRecentPlayGames
{
    MyGetRecentGameVouchersApi * api = [[MyGetRecentGameVouchersApi alloc] init];
    api.pageNumber = 1;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            self.playArray = api.data[@"list"];
            self.headerView.showTitle.text = api.data[@"title"];
            self.headerView.dataArray = self.playArray;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }];
}

#pragma mark — 获取可领取代金券列表
- (void)getVoucherList:(RequestData)block Hud:(BOOL)isShow
{
    MyGetAllVouchersApi * api = [[MyGetAllVouchersApi alloc] init];
    api.text   = self.searchText;
    api.isShow = isShow;
    api.pageNumber = self.pageNumber;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
     {
        if (block) block(YES);
        if (api.success == 1)
        {
            NSArray * array = api.data[@"list"];
            self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:array] : [self.dataArray addObjectsFromArray:array];
            UIView * view = [self creatFooterView];
            view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
            NSDictionary *dic = api.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            [self setFooterViewState:self.tableView Data:dic FooterView:view];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
     } failureBlock:^(BaseRequest * _Nonnull request) {
         [MBProgressHUD showToast:api.error_desc toView:self.view];
         if (block) block(NO);
     }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 44, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - 44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"暂无可领取代金券" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MyCouponCenterListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCouponCenterListCell"];
        [self.view addSubview:_tableView];
        _tableView.tableHeaderView = self.headerView;
        
        if (@available(iOS 11.0, *))
        {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

#pragma mark - 懒加载
- (MyVoucherCenterHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyVoucherCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 205)];
    }
    return _headerView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyCouponCenterListCell";
    MyCouponCenterListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = self.dataArray[indexPath.section];
    cell.refreshDataAction = ^{
        [self getVoucherList:^(BOOL isSuccess) {
            
        } Hud:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MyAOPManager gameRelateStatistic:@"ClickToGetTheVoucherOfCouponCenter" GameInfo:self.dataArray[indexPath.section][@"game_info"] Add:@{}];
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = self.dataArray[indexPath.section][@"game_info"][@"game_id"];
    info.hidesBottomBarWhenPushed = YES;
    info.isVoucherCenter = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
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
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getVoucherList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
        [self getRecentPlayGames];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getVoucherList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
