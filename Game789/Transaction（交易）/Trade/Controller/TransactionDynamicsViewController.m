//
//  TransactionDynamicsViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TransactionDynamicsViewController.h"
#import "tradingViewCell.h"
#import "TradingListApi.h"
#import "ProductDetailsViewController.h"

@interface TransactionDynamicsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TransactionDynamicsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"成交动态";
    self.navBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self getData:nil Hud:YES];
    [self loadData];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"tradingViewCell";
    tradingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradingListModel * model = self.dataArray[indexPath.row];
    
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.navigationController pushViewController:product animated:YES];
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

#pragma mark - 获取数据
- (void)getData:(RequestData)block Hud:(BOOL)isShow
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.trade_type = @"1";
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleListSuccess:(BaseRequest *)request
{
    if (request.success == 1)
    {
        NSArray *array = [TradingListModel mj_objectArrayWithKeyValuesArray:request.data[@"account_list"]];
        if (self.pageNumber == 1)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            [self.dataArray addObjectsFromArray:array];
        }
        NSDictionary *dic = request.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}

#pragma mark - 初始化刷新控件
- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
        
    }];
}


@end
