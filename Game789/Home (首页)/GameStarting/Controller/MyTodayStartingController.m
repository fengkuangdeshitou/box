//
//  MyTodayStartingController.m
//  Game789
//
//  Created by Maiyou on 2020/8/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTodayStartingController.h"

#import "MyGetNewGameListApi.h"

#import "HomeListTableViewCell.h"
#import "MyNewGamesSectionView.h"

@interface MyTodayStartingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyTodayStartingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBar.hidden = YES;
    
    [self loadData];
    
    [self getNewGameList:YES Data:^(BOOL isSuccess) {
        
    }];
}

#pragma mark — 获取新游列表
- (void)getNewGameList:(BOOL)isHud Data:(RequestData)block
{
    MyGetNewGameListApi * api = [[MyGetNewGameListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 5;
    api.isShow = isHud;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
    {
        block(YES);
        self.tableView.hidden = NO;
        if (request.success == 1)
        {
            NSArray *array = [api.data objectForKey:@"list"];
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.dataArray addObjectsFromArray:array];
            }
            NSDictionary *dic = api.data[@"paginated"];
            [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height-kStatusBarAndNavigationBarHeight-kTabbarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.estimatedRowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = BackColor;
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameTableViewCell"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
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
    return [self.dataArray[section][@"list"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.section][@"list"][indexPath.row]];
    model.listType = indexPath.section == 0 ? @"6" : @"999";
    return model.cellHeight+30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyNewGamesSectionView * sectionView = [[MyNewGamesSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    sectionView.currentVC = self;
    
    NSDictionary * dic = self.dataArray[section];
    NSString * time = [NSDate getCurrentTimes:@"YYYY-MM-dd"];
    
    CGFloat yesterdayTime =[[NSDate getNowTimeTimestamp] doubleValue] - 24 * 60 * 60;
    NSString * time1 = [NSDate dateTimeStringWithTS:yesterdayTime];
    
    sectionView.moreView.hidden = YES;
    
    if ([time isEqualToString:dic[@"group"]])
    {
        sectionView.showTitle.text = @"今日首发".localized;
    }
    else if ([time1 isEqualToString:dic[@"group"]])
    {
        sectionView.showTitle.text = @"昨日首发".localized;
    }
    else
    {
        sectionView.showTitle.text = dic[@"group"];
    }
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GameTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self;
    cell.source = @"home";
    cell.containViewHeight = 20;
    NSString * time = [NSDate getCurrentTimes:@"YYYY-MM-dd"];
    NSDictionary * dic = [self.dataArray[indexPath.section][@"list"][indexPath.row] deleteAllNullValue];
    cell.listType = [time isEqualToString:dic[@"group"]] ? @"6" : @"999";
    [cell setModelDic:dic];
    cell.radiusView.layer.cornerRadius = 13;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    NSDictionary * dic = [self.dataArray[indexPath.section][@"list"][indexPath.row] deleteAllNullValue];
    [MyAOPManager gameRelateStatistic:@"ViewGameDetailsOnStartingTodayPag" GameInfo:dic Add:@{}];
    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 5;
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
        [self getNewGameList:NO Data:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getNewGameList:NO Data:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
