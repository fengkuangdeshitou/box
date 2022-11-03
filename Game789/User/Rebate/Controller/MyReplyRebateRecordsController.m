//
//  MyReplyRebateRecordsController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateRecordsController.h"
#import "MyReplyRebateDetailController.h"

#import "MyReplyRebateRecordCell.h"

#import "ReturnSubmitListApi.h"

@interface MyReplyRebateRecordsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyReplyRebateRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getReplyRebateRecords:(RequestData)block Hud:(BOOL)isShow
{
    ReturnSubmitListApi *api = [[ReturnSubmitListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleReturnGuideApiListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleReturnGuideApiListSuccess:(ReturnSubmitListApi *)api
{
    if (api.success == 1)
    {
        NSArray *array = [api.data objectForKey:@"rebate_list"];
        self.pageNumber == 1 ? self.dataArray = [[NSMutableArray alloc] initWithArray:array] : [self.dataArray addObjectsFromArray:array];
        NSDictionary *dic = api.data[@"paginated"];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
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
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"rebate_no_data" titleStr:@"暂无申请返利记录~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MyReplyRebateRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyReplyRebateRecordCell"];
        [self.view addSubview:_tableView];
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
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyReplyRebateRecordCell";
    MyReplyRebateRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld", (long)indexPath.row);
    
    MyReplyRebateDetailController * detail = [MyReplyRebateDetailController new];
    detail.rebate_id = self.dataArray[indexPath.section][@"rebate_id"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getReplyRebateRecords:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getReplyRebateRecords:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
