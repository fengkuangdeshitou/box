//
//  TradeDetailView.m
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradeDetailView.h"
#import "tradingViewCell.h"
#import "TradingListApi.h"
#import "ProductDetailsViewController.h"

@implementation TradeDetailView

- (instancetype)initWithFrame:(CGRect)frame Game_id:(NSString *)game_id
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.game_id = game_id;
        self.backgroundColor = [UIColor whiteColor];
        self.pageNumber = 1;
        [self getData];
    }
    return self;
}

#pragma mark - 获取数据
- (void)getData
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.trade_type = @"3";
    api.game_id = self.game_id;
    api.count = 10;
    api.pageNumber = self.pageNumber;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            NSArray * array = [TradingListModel mj_objectArrayWithKeyValuesArray:api.data[@"account_list"]];
            if (self.pageNumber == 1)
            {
                self.tradeArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.tradeArray addObjectsFromArray:[TradingListModel mj_objectArrayWithKeyValuesArray:api.data[@"account_list"]]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetTradeData" object:self.tradeArray];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
            _tableView.ly_emptyView.y = 0;
            //加载刷新控件
            [self loadData];
            NSDictionary *dic = request.data[@"paginated"];
            UIView * view = [self.currentVC creatFooterView];
            view.backgroundColor = BackColor;
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:view];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 125;
        _tableView.backgroundColor = BackColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"trade_no_data" titleStr:@"暂无交易~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView  new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tradeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    tradingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
    }
    cell.isShowServerName = YES;
    cell.isShow = NO;
    cell.isHiddenTag = YES;
    cell.listModel = self.tradeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradingListModel * model = self.tradeArray[indexPath.row];
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.currentVC.navigationController pushViewController:product animated:YES];
}


- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getData];
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getData];
        [tableView.mj_footer endRefreshing];
    }];
}

@end
