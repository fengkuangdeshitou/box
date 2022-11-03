//
//  UserCoinsHistoryViewController.m
//  Game789
//
//  Created by Maiyou on 2018/6/22.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "UserCoinsHistoryViewController.h"
#import "UserCoinsHistoryTableViewCell.h"
#import "UserCoinsHistoryApi.h"
#import "MyOrderDetailListCell.h"
#import "MyOrderDetailListApi.h"
#import "MyOrderDetailSectionView.h"

@interface UserCoinsHistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) MyOrderDetailSectionView *sectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation UserCoinsHistoryViewController

- (void)payListRequest:(RequestData)block Hud:(BOOL)isShow
{
    MyOrderDetailListApi *api = [[MyOrderDetailListApi alloc] init];
    api.money_type = @"coin";
    api.pageNumber = self.pageNumber;
    api.count = 20;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(MyOrderDetailListApi *)api
{
    if (api.success == 1)
    {
        NSArray * array = api.data[@"list"];
        if (self.pageNumber == 1)
        {
            self.dataSource = [NSMutableArray arrayWithArray:array];
        }
        else
        {
            [self.dataSource addObjectsFromArray:array];
        }
        NSDictionary *dic = api.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        UIView * view = [self creatFooterView];
        [self setFooterViewState:self.tableView Data:dic FooterView:view];
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"金币明细";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sectionView];
    [self.view addSubview:self.tableView];
    self.pageNumber = 1;
    [self loadData];
    [self payListRequest:nil Hud:YES];
}

- (void)loadData {
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self payListRequest:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self payListRequest:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

- (MyOrderDetailSectionView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[MyOrderDetailSectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 30)];
    }
    return _sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyOrderDetailListCell";
    MyOrderDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.currentVC = self;
    cell.dataDic = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

#pragma mark --lazy load--
- (UITableView *)tableView {
    if (!_tableView)
    {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sectionView.frame), kScreen_width, kScreen_height - kTabbarSafeBottomMargin - CGRectGetMaxY(self.sectionView.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"money_no_data" titleStr:@"暂无任务历史记录" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyOrderDetailListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyOrderDetailListCell"];
    }
    return _tableView;
}

@end
