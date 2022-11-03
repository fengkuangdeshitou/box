//
//  PlayedGamesController.m
//  Game789
//
//  Created by Maiyou on 2018/11/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "PlayedGamesController.h"

#import "PersonalCenterApi.h"
@class GetPlayedGamesApi;

#import "HomeListTableViewCell.h"

@interface PlayedGamesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PlayedGamesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];

    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GameDownloadList:) name:@"GameDownloadList" object:nil];
}

- (void)GameDownloadList:(int)tag
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"请稍后...".localized;
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark - 获取玩过的游戏
- (void)getPlayerGamesData:(RequestData)block Hud:(BOOL)isShow
{
    GetPlayedGamesApi * api = [[GetPlayedGamesApi alloc] init];
    api.user_id = self.user_id;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            if (![request.data[@"game_list"] isKindOfClass:[NSNull class]])
            {
                self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:request.data[@"game_list"]] : [self.dataArray addObjectsFromArray:request.data[@"game_list"]];
            }
            
            [self.tableView reloadData];
            _tableView.ly_emptyView.y = 50;
            _tableView.ly_emptyView.contentView.hidden = NO;
            [self loadData];
            
            NSDictionary *dic = request.data[@"paginated"];
            if ([dic[@"more"] integerValue] == 0)
            {
                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_comment_no_data" titleStr:@"您还没玩过游戏哦，赶紧去下载吧" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"HomeListTableViewCell"];
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
    NSString * identifier = @"HomeListTableViewCell";
    HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.currentVC = self;
    [cell setModelDic:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getPlayerGamesData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getPlayerGamesData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
