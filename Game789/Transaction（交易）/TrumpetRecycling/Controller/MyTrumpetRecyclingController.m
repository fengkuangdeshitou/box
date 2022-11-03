//
//  MyTrumpetRecyclingController.m
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTrumpetRecyclingController.h"
#import "MyTrumpetRecyclingCell.h"
#import "MyTrumpetRecyclingDetailController.h"
#import "MyRecycleRecordsController.h"
#import "MyRecycleGameListApi.h"
#import "MyPromptDetailsCell.h"
#import "MyTrumpetRecylingHeaderView.h"

@interface MyTrumpetRecyclingController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_top;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MyTrumpetRecyclingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getRecycleGameList:nil Hud:YES];
}

- (void)prepareBasic
{
    self.navBar.title = @"小号回收";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView_top.constant = kStatusBarAndNavigationBarHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self creatHeaderView];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"recycle_no_data" titleStr:@"暂无可回收小号" detailStr:@""];
    self.tableView.ly_emptyView.contentViewY = 550;
//    self.tableView.ly_emptyView.contentView.hidden = YES;
    self.tableView.backgroundColor = BackColor;
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"回收记录".localized titleColor:[UIColor blackColor]];
    [self.navBar setOnClickRightButton:^{
        MyRecycleRecordsController * record = [MyRecycleRecordsController new];
        [weakSelf.navigationController pushViewController:record animated:YES];
    }];
}

- (UIView *)creatHeaderView
{
    MyTrumpetRecylingHeaderView * headerView = [[MyTrumpetRecylingHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 520)];
    return headerView;
}

#pragma mark ——— 获取可回收游戏列表
- (void)getRecycleGameList:(RequestData)block Hud:(BOOL)isShow
{
    MyRecycleGameListApi * api = [[MyRecycleGameListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleListSuccess:(BaseRequest *)request
{
    if (request.success == 1)
    {
        NSArray * array = request.data[@"list"];
        NSMutableArray * tplArray = [NSMutableArray array];
        for (NSDictionary * dic in array)
        {
            MyRecycleGameListModel * model = [[MyRecycleGameListModel alloc] initWithDictionary:dic];
            [tplArray addObject:model];
        }
        if (self.pageNumber == 1)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:tplArray];
        }
        else
        {
            [self.dataArray addObjectsFromArray:tplArray];
        }
        NSDictionary *dic = request.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.dataArray.count > 0 ? 10 : 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    footer.backgroundColor = UIColor.clearColor;
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    MyTrumpetRecyclingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyTrumpetRecyclingCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.dataArray[indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTrumpetRecyclingDetailController * detail = [MyTrumpetRecyclingDetailController new];
    detail.listModel = self.dataArray[indexPath.section];
    detail.RecycleXhSuccess = ^{
//            [self getRecycleGameList:nil Hud:YES];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
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
        [self getRecycleGameList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getRecycleGameList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
