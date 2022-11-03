//
//  GiftViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/3.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "MyGiftViewController.h"
#import "GiftListTableViewCell.h"
#import "MyGameGiftDetailController.h"

#import "MyGiftListApi.h"
#import "GetGiftApi.h"
#import "MainSearchView.h"

#import "LYEmptyViewHeader.h"
@interface MyGiftViewController () <UITableViewDelegate, UITableViewDataSource, MainSearchViewDelegate, GiftListTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) MainSearchView *searchView;

@property (strong, nonatomic) NSString *searchInfo;

@property (strong, nonatomic) NSString *code;

@end

@implementation MyGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = [self creatHeaderView];
    [self.view addSubview:self.tableView];

    [self.view insertSubview:self.navBar aboveSubview:self.view];

    self.navBar.title = @"我的礼包";
    self.searchInfo = @"";
    self.pageNumber = 1;
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)creatHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_width, 55)];
    view.backgroundColor = BackColor;
    [view addSubview:self.searchView];
    return view;
}

- (MainSearchView *)searchView {
    if (!_searchView) {
        _searchView = [self createBallView];
        _searchView.frame = CGRectMake(20, 10, kScreenW - 40, 35);
        _searchView.delegate = self;
    }
    return _searchView;
}

- (MainSearchView *)createBallView {
    MainSearchView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainSearchView class]) owner:nil options:nil] firstObject];
    return view;
}

- (void)loadData {
    __unsafe_unretained UITableView *tableView = self.tableView;

    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self giftApiRequest:self.searchInfo isHud:YES Data:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self giftApiRequest:self.searchInfo isHud:YES Data:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)giftApiRequest:(NSString *)searchInfo isHud:(BOOL)isShow Data:(RequestData)block
{
    MyGiftListApi *api = [[MyGiftListApi alloc] init];
    api.isShow = isShow;
    api.search_info = searchInfo;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(MyGiftListApi *)api
{
    if (api.success == 1)
    {
        if (self.pageNumber == 1)
        {
            self.dataSource = [[NSMutableArray alloc] initWithArray:api.data[@"gift_list"]];
        }
        else
        {
            [self.dataSource addObjectsFromArray:api.data[@"gift_list"]];
        }
        NSDictionary *pageDic = api.data[@"paginated"];
        self.hasNextPage = [pageDic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:pageDic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}


- (void)getGiftApiRequest:(NSString *)giftId
{
    GetGiftApi *api = [[GetGiftApi alloc] init];
    api.gift_id = giftId;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGiftSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleGiftSuccess:(GetGiftApi *)api
{
    if (api.success == 1)
    {
        self.code = api.data[@"data"];
        self.pageNumber = 1;
        [self giftApiRequest:@"" isHud:NO Data:nil];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"GiftListTableViewCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
    GiftListTableViewCell *cells = (GiftListTableViewCell *)cell;
    cells.delegate = self;
    [cell setModelDic:dic];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
//    [self getGiftApiRequest:dic[@"gift_id"]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section];
    MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
    detail.isReceived = NO;
    detail.gift_id = dic[@"gift_id"];
    detail.vc = YYToolModel.getCurrentVC;
    [self presentViewController:detail animated:YES completion:nil];
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

- (void)showHUDView:(NSString *)codeStr
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = codeStr;
    
    [MBProgressHUD showToast:@"礼包码已复制到剪贴板" toView:self.view];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BackColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GiftListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"GiftListTableViewCell"];
         _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_gift_no_data" titleStr:@"暂无礼包，快去游戏详情页领取吧~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)getSearchViewText:(NSString *)string
{
    self.searchInfo = string;
    [self giftApiRequest:self.searchInfo isHud:NO Data:nil];
}

@end
