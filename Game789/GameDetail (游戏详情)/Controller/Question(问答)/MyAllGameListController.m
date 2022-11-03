//
//  MyAllGameListController.m
//  Game789
//
//  Created by yangyongMac on 2020/2/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyAllGameListController.h"
#import "MySelectGameListCell.h"
#import "MyGetAllGamesApi.h"
#import "MyGameListSectionView.h"

@interface MyAllGameListController () <UITableViewDelegate, UITableViewDataSource, MyGameListSectionViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString * keyword;

@end

@implementation MyAllGameListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar.title = @"游戏列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.keyword = @"";
    
    [self creatTopView];
    [self getGameList:nil Hud:YES];
}

- (void)getGameList:(RequestData)block Hud:(BOOL)isShow
{
    MyGetAllGamesApi * api = [[MyGetAllGamesApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 20;
    api.isShow = isShow;
    api.gameName = self.keyword;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (api.success == 1)
        {
            NSArray *array = [api.data objectForKey:@"game_list"];
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
            [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
            
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)creatTopView
{
    MyGameListSectionView * sectionView = [[MyGameListSectionView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 50)];
    sectionView.delegate = self;
    [self.view addSubview:sectionView];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + 50;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - view_top) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight=0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [self loadData];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    MySelectGameListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MySelectGameListCell" owner:self options:nil].firstObject;
    }
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectGame)
    {
        self.selectGame(self.dataArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

//搜索
- (void)keywordSearchAction:(NSString *)keyword
{
    self.keyword = keyword;
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化刷新控件
- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getGameList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getGameList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
