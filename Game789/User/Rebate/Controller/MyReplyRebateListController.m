//
//  MyReplyRebateListController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateListController.h"
#import "MySubmitReplyReabteController.h"

#import "MyReplyRebateListCell.h"
#import "MyReplyRebateListHeaderView.h"

#import "ReturnMoneyApi.h"

@interface MyReplyRebateListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) MyReplyRebateListHeaderView * headerView;

@end

@implementation MyReplyRebateListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self loadData];
    
//    [self getReplyRebateList:nil];
}

- (void)getReplyRebateList:(RequestData)block Hud:(BOOL)isShow
{
    ReturnMoneyApi *api = [[ReturnMoneyApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleListSuccess:(ReturnMoneyApi *)api
{
    if (api.success == 1)
    {
        NSArray *array = [api.data objectForKey:@"can_rebate_list"];
        if (self.pageNumber == 1)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            [self.dataArray addObjectsFromArray:array];
        }
        NSDictionary *dic = api.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
        self.tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"rebate_no_data" titleStr:@"暂无可申请返利记录~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyReplyRebateListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyReplyRebateListCell"];
    }
    return _tableView;
}

- (MyReplyRebateListHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyReplyRebateListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
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
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 35 : 0.001;
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
    static NSString *reuseID = @"MyReplyRebateListCell";
    MyReplyRebateListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    MySubmitReplyReabteController * reply = [MySubmitReplyReabteController new];
    reply.detailDic = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:reply animated:YES];
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

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getReplyRebateList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getReplyRebateList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}


@end
