//
//  MyGMGameListView.m
//  Game789
//
//  Created by Maiyou on 2019/5/29.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGMGameListView.h"
#import "HomeListTableViewCell.h"
#import "HomeListApi.h"

@implementation MyGMGameListView

- (instancetype)initWithFrame:(CGRect)frame Tag:(NSInteger)tag
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.tag = tag;
        self.pageNumber = 1;
        
        [self loadData];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)listRequest
{
    HomeListApi *api = [[HomeListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.type = @"4";
    api.mainType = @"1";
    api.count = 30;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleListSuccess:(HomeListApi *)api
{
    if (api.success == 1)
    {
        NSArray *array = [api.data objectForKey:@"game_list"];
        if(self.dataArray == nil)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        self.pageNumber == 1 ?
        self.dataArray = [[NSMutableArray alloc] initWithArray:array] :
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        
        NSDictionary *dic = api.data[@"paginated"];
        if (self.dataArray.count >= [dic[@"total"] integerValue])
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"listCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    cell.currentVC = self.currentVC;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    [dic setValue:@"0" forKey:@"isHotGame"];
    if (self.tag == 21)
        [dic setValue:@"1" forKey:@"isGMAssisant"];
    [cell setModelDic:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self gameContentTableCellBtn:self.dataArray[indexPath.row]];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic
{
    GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.isLoadData = YES;
        self.pageNumber = 1;
        [self listRequest];
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        self.isLoadData = YES;
        [self listRequest];
        [tableView.mj_footer endRefreshing];
        
    }];
}

@end
