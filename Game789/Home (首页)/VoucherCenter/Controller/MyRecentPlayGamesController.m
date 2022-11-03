//
//  MyRecentPlayGamesController.m
//  Game789
//
//  Created by Maiyou on 2020/12/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRecentPlayGamesController.h"
#import "MyCouponCenterListCell.h"

#import "MyHomeGameListApi.h"
@class MyGetRecentGameVouchersApi;

@interface MyRecentPlayGamesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyRecentPlayGamesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)prepareBasic
{
    self.navBar.title = self.showTitle;
    self.view.backgroundColor = BackColor;
}

#pragma mark — 获取代金券列表
- (void)getVoucherList:(RequestData)block Hud:(BOOL)isShow
{
    MyGetRecentGameVouchersApi * api = [[MyGetRecentGameVouchersApi alloc] init];
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
            view.backgroundColor = BackColor;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"暂无可领取代金券" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MyCouponCenterListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCouponCenterListCell"];
        [self.view addSubview:_tableView];
        
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
    return section == 0 ? 10 : 0.001;
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
