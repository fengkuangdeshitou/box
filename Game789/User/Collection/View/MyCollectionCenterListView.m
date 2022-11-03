//
//  MyCollectionCenterListView.m
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyCollectionCenterListView.h"
#import "HomeListTableViewCell.h"
#import "tradingViewCell.h"
#import "MyGetCollectionGameListApi.h"
#import "MyGetCollectionTradeListApi.h"
#import "ProductDetailsViewController.h"
#import "MyPlayingApi.h"

@implementation MyCollectionCenterListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self loadData];
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setIsLoaded:(BOOL)isLoaded
{
    _isLoaded = isLoaded;
    if (_isLoaded)
    {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"collection_no_data" titleStr:self.tag == 20 ? @"暂未玩过任何游戏" : (self.index == 21 ? @"暂未收藏任何游戏" : @"暂未收藏任何交易") detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
    }
    return _tableView;
}
#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.index != 2 ? self.dataArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.index != 2 ? 1 : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 2) {
        return 125;
    }
    GameModel * model = self.dataArray[indexPath.section];
    return model.cellHeight+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.index == 2 ? 0.001 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 2)
    {
        static NSString *reuseID = @"cell1";
        tradingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listModel = self.dataArray[indexPath.row];
        return cell;
    }
    else
    {
        static NSString * identifity = @"GameTableViewCell";
        GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
        }
        cell.source = @"home";
        cell.containViewHeight = 20;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.radiusView.layer.cornerRadius = 13;
        [cell setModelDic:[self.dataArray[indexPath.section] mj_JSONObject]];
        cell.currentVC = self.currentVC;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    if (self.index == 2)
    {
        TradingListModel * model = [self.dataArray objectAtIndex:indexPath.row];
        ProductDetailsViewController * product = [ProductDetailsViewController new];
        product.hidesBottomBarWhenPushed = YES;
        product.trade_id = model.trade_id;
        [self.currentVC.navigationController pushViewController:product animated:YES];
    }
    else
    {
        GameModel * dic = [self.dataArray objectAtIndex:indexPath.section];
        GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic.game_id;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds  = scrollView.bounds;
    CGSize size    = scrollView.contentSize;
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

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        _index == 2 ? [self getTradeList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }] : [self getGamesList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        _index == 2 ? [self getTradeList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }] : [self getGamesList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)getGamesList:(RequestData)block
{
    BaseRequest * api;
    if (self.index == 0) {
        api = [[MyPlayingApi alloc] init];
    }else{
        api = [[MyGetCollectionGameListApi alloc] init];
    }
    api.pageNumber = self.pageNumber;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1)
        {
            NSArray *array = [GameModel mj_objectArrayWithKeyValuesArray:request.data[@"game_list"]];
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
            if (self.dataArray.count >= [dic[@"total"] integerValue])
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (void)getTradeList:(RequestData)block
{
    MyGetCollectionTradeListApi * api = [[MyGetCollectionTradeListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1)
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
            if (self.dataArray.count >= [dic[@"total"] integerValue])
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

@end
