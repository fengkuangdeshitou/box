//
//  MyActivityGuideListView.m
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyActivityGuideListView.h"
#import "MyActivityDetailController.h"
#import "NoticeDetailViewController.h"

#import "MyActivityGuideApi.h"

#import "MyActivityGuideCell.h"

@implementation MyActivityGuideListView

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

- (void)getVoucherList:(RequestData)block
{
    MyActivityGuideApi * api = [[MyActivityGuideApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 15;
    api.type = self.type;
    api.game_id = self.game_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1) {
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
            view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:view];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
            
        } else {
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
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.rowHeight = 69;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"暂无活动内容" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
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
    static NSString *reuseID = @"cell";
    MyActivityGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyActivityGuideCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self.currentVC;
    cell.type = self.type;
    cell.dataDic = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld", (long)indexPath.row);
    
    NSDictionary * dic = self.dataArray[indexPath.section];
//    if ([dic[@"type"] integerValue] == 2)
//    {
//        NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
//        detailVC.news_id = dic[@"news_id"];
//        detailVC.gameInfo = self.gameInfo;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
//    }
//    else
//    {
        MyActivityDetailController *detailVC = [[MyActivityDetailController alloc] init];
        detailVC.news_id = dic[@"news_id"];
        detailVC.gameInfo = self.gameInfo;
        detailVC.type = dic[@"type"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds  = scrollView.bounds;
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
