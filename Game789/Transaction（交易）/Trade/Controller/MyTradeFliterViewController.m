//
//  MyTradeFliterViewController.m
//  Game789
//
//  Created by Maiyou on 2020/4/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTradeFliterViewController.h"
#import "TradingSectionView.h"
#import "tradingViewCell.h"
#import "ProductDetailsViewController.h"
#import "TradingListApi.h"

@interface MyTradeFliterViewController () <UITableViewDelegate, UITableViewDataSource, TradingSectionViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, copy) NSString * searchText;
@property (nonatomic, strong) TradingSectionView * sectionView;
@property (nonatomic, copy) NSString * sort_type;
@property (nonatomic, strong)UIImageView * imageView;
//判断是否正在搜索
@property (nonatomic, assign) BOOL isSearch;


@end

@implementation MyTradeFliterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"超值捡漏";
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.tableView];
    
    [MyAOPManager userInfoRelateStatistic:@"ViewTenPercentOffAccountTransaction"];

    [self getData:nil Hud:YES];
    
    [self loadData];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.tableHeaderView = [self getHeaderView];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _tableView;
}

- (UIView *)getHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 105)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = true;
    self.imageView.layer.cornerRadius = 6;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[DeviceInfo shareInstance].trade_goods_cover] placeholderImage:MYGetImage(@"game_icon")];
    [headerView addSubview:self.imageView];
    return headerView;
}

- (TradingSectionView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[TradingSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 72.5+50)];
        _sectionView.currentVC = self;
        _sectionView.hiddenPriceRang = true;
        _sectionView.delegate = self;
        _sectionView.switchBtn_width.constant = 15;
        _sectionView.switchBtn.hidden = YES;
    }
    return _sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"tradingViewCell";
    tradingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
    }
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradingListModel * model = self.dataArray[indexPath.row];
    
    if (self.isSearch) {
        [MyAOPManager relateStatistic:@"ClickToSearchOfAccountTransactionPage" Info:@{@"gameName":model.game_name}];
    }
    
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.navigationController pushViewController:product animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {

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

#pragma mark — TradingSectionViewDelegate
- (void)searchTradeGame:(NSString *)text
{
    self.isSearch = ![YYToolModel isBlankString:text];
    self.searchText = text;
    self.pageNumber = 1;
    
    [self getData:nil Hud:YES];
}

- (void)fliterRefreshData
{
    self.pageNumber = 1;
    [self getData:nil Hud:YES];
}

- (void)selectSortType:(NSInteger)index
{
    NSArray * types = @[@"publish", @"effective", @"asc", @"desc"];
    self.sort_type = types[index];
    self.pageNumber = 1;
    [self getData:nil Hud:YES];
}

- (void)tradingPriceRange:(NSString *)trade_price_range{
    [MyAOPManager relateStatistic:@"ClickPriceRange" Info:@{@"priceRange":trade_price_range}];
    self.pageNumber = 1;
    self.sectionView.trade_price_range = trade_price_range;
    [self getData:nil Hud:YES];
}


#pragma mark - 获取数据
- (void)getData:(RequestData)block Hud:(BOOL)isShow
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.trade_featured = @"1";
    api.game_device_type = self.sectionView.game_device_type ? : @"2";
    api.game_species_type = self.sectionView.game_species_type  ? : @"1";
    api.trade_price_range = self.sectionView.trade_price_range;
    api.game_classify_id = self.sectionView.game_classify_id;
    api.sort_type = self.sort_type ? : @"publish";
    api.game_name = self.searchText;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    NSLog(@"12121212=%@",api.trade_price_range);
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
        
        NSArray *array = [TradingListModel mj_objectArrayWithKeyValuesArray:request.data[@"account_list"]];
        if (self.pageNumber == 1)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            [self.dataArray addObjectsFromArray:array];
        }
        NSDictionary *dic = request.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        _tableView.hidden = NO;
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}

#pragma mark - 初始化刷新控件
- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
