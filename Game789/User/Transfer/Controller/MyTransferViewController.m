//
//  MyTransferViewController.m
//  Game789
//
//  Created by Maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferViewController.h"
#import "MyTransferRecordsController.h"
#import "MyTransferDescController.h"

#import "MyTransferListSectionView.h"
#import "MyTransferListApi.h"

@interface MyTransferViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyTransferListSectionView *sectionView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString *searchText;

@end

@implementation MyTransferViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getData:nil];

    [self loadData];
}

- (void)prepareBasic
{
    self.navBar.title = @"转游福利".localized;
    self.searchText = @"";
    
    [self.navBar wr_setRightButtonWithTitle:@"转游记录".localized titleColor:FontColor99];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    WEAKSELF
    [self.navBar setOnClickRightButton:^{
        MyTransferRecordsController * record = [MyTransferRecordsController new];
        [weakSelf.navigationController pushViewController:record animated:YES];
    }];
}

- (void)getData:(RequestData)block
{
    MyTransferListApi * api = [[MyTransferListApi alloc] init];
    api.isShow = YES;
    api.searchText = self.searchText;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (api.success == 1) {
            NSArray * array = request.data[@"list"];
            self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:array] : [self.dataArray addObjectsFromArray:array];
            NSDictionary *dic = api.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
            [self.tableView reloadData];
            self.tableView.ly_emptyView.contentView.hidden = NO;
        } else {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"collection_no_data" titleStr:@"暂无该游戏" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.ly_emptyView.contentViewOffset = 100;
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameTableViewCell"];
    }
    return _tableView;
}

- (UIImageView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 178 / 375)];
        _headerView.image = MYGetImage(@"transfer_header_bg");
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (MyTransferListSectionView *)sectionView
{
    if (!_sectionView)
    {
        WEAKSELF
        _sectionView = [[MyTransferListSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
        _sectionView.searchTextBlock = ^(NSString * _Nonnull searchText) {
            weakSelf.pageNumber = 1;
            weakSelf.searchText = searchText;
            [weakSelf getData:nil];
        };
    }
    return _sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count == 0 ? 0 : self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 50;
    }
    GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.row - 1]];
    return model.cellHeight+30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString * cellIdentify = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"热门推荐".localized;
        cell.textLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        cell.textLabel.textColor = FontColor28;
        cell.contentView.backgroundColor = BackColor;
        return cell;
    }
    else
    {
        static NSString * identifity = @"GameTableViewCell";
        GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
        [cell setModelDic:self.dataArray[indexPath.row - 1]];
//        cell.listType = @"4";
        cell.radiusView.layer.cornerRadius = 13;
        cell.radiusView_bottom.constant = 10;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        NSDictionary * dic = self.dataArray[indexPath.row - 1];
        MyTransferDescController * desc = [MyTransferDescController new];
        desc.dataDic = dic;
        [self.navigationController pushViewController:desc animated:YES];
        
        [MyAOPManager gameRelateStatistic:@"ClickTransferGameRechargeList" GameInfo:dic Add:@{@"game_classify_name":dic[@"game_classify_type"]}];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        self.sectionView.y = self.headerView.height;
    }else{
        self.sectionView.y = scrollView.contentOffset.y;
    }
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
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
