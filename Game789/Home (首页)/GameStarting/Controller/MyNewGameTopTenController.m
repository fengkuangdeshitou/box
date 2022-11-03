//
//  MyNewGameTopTenController.m
//  Game789
//
//  Created by Maiyou on 2020/8/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewGameTopTenController.h"
#import "GameTableViewCell.h"
#import "MyGameTopTenApi.h"

@interface MyNewGameTopTenController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyNewGameTopTenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    
    [self loadData];
    [self getTopGameList:^(BOOL isSuccess) {
        
    } Hud:YES];
}

#pragma mark — 获取新游列表
- (void)getTopGameList:(RequestData)block Hud:(BOOL)isShow
{
    MyGameTopTenApi * api = [[MyGameTopTenApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 10;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
    {
        block(YES);
        if (request.success == 1)
        {
            NSArray *array = [GameModel mj_objectArrayWithKeyValuesArray:[api.data objectForKey:@"list"]];
            self.dataArray = [NSMutableArray arrayWithArray:array];
            NSDictionary *dic = api.data[@"paginated"];
            if ([dic[@"more"] integerValue] == 0)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarHeight-44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameTableViewCell"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        
        UIView * footerView = [self creatFooterView];
        footerView.backgroundColor = BackColor;
        _tableView.tableFooterView = footerView;
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
    GameModel * model = self.dataArray[indexPath.section];
    return model.cellHeight+25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 15 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
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
    static NSString * identifity = @"GameTableViewCell";
    GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
    }
    cell.source = @"home";
    cell.containViewHeight = 20;
    cell.indexPath = indexPath;
    cell.listType = @"8";
    [cell setModelDic:[self.dataArray[indexPath.section] mj_JSONObject]];
    cell.radiusView.layer.cornerRadius = 13;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    NSDictionary * dic = [self.dataArray[indexPath.section] mj_JSONObject];
    [MyAOPManager gameRelateStatistic:@"ViewGameDetailsOnStartingTodayPag" GameInfo:dic Add:@{}];
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = dic[@"game_id"];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 刷新控件
- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getTopGameList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
//    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageNumber ++;
//        [self kaiFuApiRequest];
//        [tableView.mj_footer endRefreshing];
//    }];
}

@end
