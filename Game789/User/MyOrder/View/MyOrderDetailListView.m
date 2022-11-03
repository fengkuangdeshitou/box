//
//  MyOrderDetailListView.m
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyOrderDetailListView.h"
#import "MyOrderDetailListCell.h"
#import "MyOrderDetailListApi.h"

@implementation MyOrderDetailListView

- (void)setIsLoaded:(BOOL)isLoaded
{
    _isLoaded = isLoaded;
    if (_isLoaded)
    {
        [self loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header beginRefreshing];
        });
    }
}

- (void)getVoucherList:(RequestData)block
{
    MyOrderDetailListApi * api = [[MyOrderDetailListApi alloc] init];
    api.money_type = [self getType];
    api.pageNumber = self.pageNumber;
    api.count = 20;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1)
        {
            NSArray * array = api.data[@"list"];
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.dataArray addObjectsFromArray:array];
            }
            NSDictionary *dic = api.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            UIView * view = [self.currentVC creatFooterView];
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:view];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.currentVC.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 45;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = FontColorDE;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"money_no_data" titleStr:[self noDataStr] detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"MyOrderDetailListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyOrderDetailListCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (MyOrderDetailSectionView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[MyOrderDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    }
    return _sectionView;
}

- (NSString *)getType
{
    if (self.index == 0)
    {
        return @"money";
    }
    else if (self.index == 1)
    {
        return @"ptb";
    }
    else if (self.index == 2)
    {
        return @"coin";
    }
    else
    {
        return @"voucher";
    }
}

- (NSString *)noDataStr
{
    if (self.index == 0)
    {
        return @"暂无现金记录";
    }
    else if (self.index == 1)
    {
        return @"暂无平台币记录";
    }
    else if (self.index == 2)
    {
        return @"暂无金币记录";
    }
    else
    {
        return @"暂无代金券记录";
    }
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
    self.sectionView.showTitle.text = [self getTitle];
    return self.sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyOrderDetailListCell";
    MyOrderDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.currentVC = self.currentVC;
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
}

- (NSString *)getTitle
{
    if (self.index == 0)
    {
        return @"现金";
    }
    else if (self.index == 1)
    {
        return @"平台币";
    }
    else if (self.index == 2)
    {
        return @"金币";
    }
    else
    {
        return @"代金券金额";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    float reload_distance = 10;
//    if(y > h + reload_distance && !self.isLoading && self.hasNextPage) {
//        self.isLoading = YES;
//        [self.tableView.mj_footer beginRefreshing];
//    } else {
//        if (self.isLoading) {
//            self.isLoading = NO;
//        }
//    }
    if (scrollView.contentOffset.y <= 0) {
        self.sectionView.y = 0;
    }else{
        self.sectionView.y = scrollView.contentOffset.y;
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
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getVoucherList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
