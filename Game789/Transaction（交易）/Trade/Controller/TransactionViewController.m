//
//  TransactionViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TransactionViewController.h"
#import "ProductDetailsViewController.h"
#import "TradingNoticeViewController.h"

#import "TradingSectionView.h"
#import "TradingHeaderView.h"
#import "tradingViewCell.h"
#import "TradingMoreViewCell.h"

#import "TradingListApi.h"
#import "HomeTypeApi.h"
@class StageABTestApi;

@interface TransactionViewController () <UITableViewDataSource, UITableViewDelegate, TradingSectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * selectTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) TradingHeaderView * headerView;
@property (nonatomic, strong) TradingSectionView * sectionView;

@property (nonatomic, copy) NSString *searchText;
/**  1：BT 2:折扣 3：H5 4:GM，默认不传取全部  */
@property (nonatomic, copy) NSString * game_species_type;
/** 0:双端 1：ios 2：Android，默认不传取全部 */
@property (nonatomic, copy) NSString *game_device_type;
/**  价格区域  */
@property (nonatomic, copy) NSString *trade_price_range;
/** 游戏类型id  筛选游戏类型 */
@property (nonatomic, copy) NSString *game_classify_id;
/** 排序类型 */
@property (nonatomic, copy) NSString *sort_type;
/// 是否多列显示
@property (nonatomic, assign) BOOL more;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation TransactionViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
//    [self creatRightNavButton];
    NSDictionary * dic = [YYToolModel getCacheData:MiluTradeListCache];
    if (dic)
    {
        [self parmasData:dic];
    }
    [self getData:nil Hud:!dic];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取用户信息
    [self getUserInfoApiRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"账号交易";
    self.navBar.titleLable.textColor = UIColor.whiteColor;
    self.navBar.barBackgroundColor = MAIN_COLOR;
    self.tableView.tableHeaderView = self.headerView;
    self.more = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTradeStatus) name:@"ReloadDataTradeStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAction:) name:NSStringFromClass([self class]) object:nil];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ——— 单击指定双击刷新
- (void)scrollTopAction:(NSNotification *)noti
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    NSNumber * number = noti.object;
    //双击刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([number boolValue])
        {
            [self getData:nil Hud:YES];
        }
    });
}

#pragma mark - 下架后刷新数据
- (void)reloadDataTradeStatus
{
    [self getData:nil Hud:YES];
}

#pragma mark - 创建导航栏右按钮
- (void)creatRightNavButton
{
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"交易须知" titleColor:[UIColor blackColor]];
    [self.navBar setOnClickRightButton:^{
        TradingNoticeViewController * notice = [TradingNoticeViewController new];
        notice.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:notice animated:YES];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - (self.navigationController.viewControllers.count > 1 ? kTabbarSafeBottomMargin : kTabbarHeight)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"trade_no_data" titleStr:@"暂无交易~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.backgroundColor = BackColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (TradingHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"TradingHeaderView" owner:self options:nil].firstObject;
        _headerView.currentVC = self;
        _headerView.frame = CGRectMake(0, 0, kScreenW, 252.5);
        [_headerView setButtonImage];
    }
    return _headerView;
}

- (TradingSectionView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[TradingSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 72.5)];
        _sectionView.currentVC = self;
        _sectionView.delegate = self;
    }
    _sectionView.switchBtn.selected = self.more;
    return _sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.more == NO ? 125 : 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArray.count;
    return self.more == NO ? count : (count % 2 == 0 ? count / 2 : count / 2 + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.more == NO)
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
    else
    {
        static NSString * identifier = @"TradingMoreViewCell";
        TradingMoreViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TradingMoreViewCell" owner:self options:nil].firstObject;
        }
        cell.leftListModel = self.dataArray[indexPath.row * 2];
        if (indexPath.row * 2 + 1 >= self.dataArray.count)
        {
            cell.rightListModel = nil;
        }
        else
        {
            cell.rightListModel = self.dataArray[indexPath.row * 2 + 1];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.more)
    {
        TradingListModel * model = self.dataArray[indexPath.row];
        [MyAOPManager relateStatistic:@"ClickTradeGameDetails" Info:@{@"gameName":model.game_name, @"price":model.trade_price, @"type":@"vertical"}];
        ProductDetailsViewController * product = [ProductDetailsViewController new];
        product.hidesBottomBarWhenPushed = YES;
        product.trade_id = model.trade_id;
        [self.navigationController pushViewController:product animated:YES];
    }
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

- (void)tradingStyleChange:(BOOL)more
{
    [MyAOPManager userInfoRelateStatistic:@"ClickToSwitchTheDisplayModeOfTradeGame"];
    self.more = more;
    [self.tableView reloadData];
    
//    [self stageABTest];
}

#pragma mark - 获取数据
- (void)getData:(RequestData)block Hud:(BOOL)isShow
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.game_device_type = self.sectionView.game_device_type ? : @"2";
    api.game_species_type = self.sectionView.game_species_type  ? : @"1";
    api.trade_price_range = self.sectionView.trade_price_range;
    api.game_classify_id = self.sectionView.game_classify_id;
    api.sort_type = self.sort_type ? : @"publish";
    api.game_name = self.searchText;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)handleListSuccess:(BaseRequest *)request
{
    if (request.success == 1)
    {
        [self parmasData:request.data];
        
        if (!self.isFirstLoad)
        {
            self.isFirstLoad = YES;
            //缓存数据
            [YYToolModel saveCacheData:request.data forKey:MiluTradeListCache];
        }
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}

- (void)parmasData:(NSDictionary *)dic
{
    self.dataDic = dic;
    if (self.dataArray)
    {
//        NSDictionary * data = @{@"ab_test1":[NSString stringWithFormat:@"%@", dic[@"ab_test_trade_detail_style"]]};
//        //交易页面的统计
//        [MyAOPManager relateStatistic:@"BrowseAccountTransactionPage" Info:data];
    }
    NSArray *array = [TradingListModel mj_objectArrayWithKeyValuesArray:dic[@"account_list"]];
    self.headerView.dataArray = [TradingListModel mj_objectArrayWithKeyValuesArray:dic[@"featured_list"]];
    self.headerView.titleLabel.text = dic[@"title_info"][@"title"];
    [self.headerView.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"title_info"][@"image"]]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.headerView.imageView_width.constant = image.size.width/2;
        self.headerView.imageView_height.constant = image.size.height/2;
    }];
    if (self.pageNumber == 1)
    {
        self.dataArray = [[NSMutableArray alloc] initWithArray:array];
    }
    else
    {
        [self.dataArray addObjectsFromArray:array];
    }
    NSDictionary *paginated = dic[@"paginated"];
    self.hasNextPage = [paginated[@"more"] boolValue];
    [self setFooterViewState:self.tableView Data:paginated FooterView:[self creatFooterView]];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    _tableView.ly_emptyView.contentView.hidden = NO;
    _tableView.ly_emptyView.y = kScreenH / 2;
}

#pragma mark 获取个人信息
- (void)getUserInfoApiRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSString *member_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    if (userId && userId.length > 0 && member_info == NULL)
    {
        GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            [self handleUserSuccess:api];
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

- (void)handleUserSuccess:(GetUserInfoApi *)api
{
    if (api.success == 1)
    {
        NSDictionary * dic = api.data[@"member_info"] ;
        NSDictionary * memberDic = [dic deleteAllNullValue];
        [YYToolModel saveUserdefultValue:dic[@"member_name"] forKey:@"user_name"];
        [YYToolModel saveUserdefultValue:memberDic forKey:@"member_info"];
        if ([DeviceInfo shareInstance].isGameVip)
        {
            [YYToolModel saveUserdefultValue:@"0" forKey:DOWN_STYLE];
        }
        else
        {
            [YYToolModel saveUserdefultValue:dic[@"ios_down_style"] forKey:DOWN_STYLE];
        }
    }
    else
    {
        [YYToolModel deleteUserdefultforKey:USERID];
        NSLog(@" api.error--------->%@",api.error_desc);
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
    
    [tableView.mj_footer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([object isEqual:self.tableView.mj_footer] && self.tableView.mj_footer.state == MJRefreshStatePulling) {
        [self feedbackGenerator];
    }
}

- (void)feedbackGenerator {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

- (void)stageABTest
{
    StageABTestApi * api = [[StageABTestApi alloc] init];
    api.name = @"ab_test_trade_detail_style";
    api.value = [NSString stringWithFormat:@"%@", self.dataDic[@"ab_test_trade_detail_style"]];
    api.ab_test_stage = [NSString stringWithFormat:@"%@", self.dataDic[@"ab_test_stage"]];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
