//
//  MyMainSearchViewController.m
//  Game789
//
//  Created by Maiyou on 2020/11/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyMainSearchViewController.h"
#import "MyMainSearchTagsCell.h"
#import "MyMainSearchSectionView.h"
#import "MyMainSearchFooterView.h"
#import "GameModel.h"
#import "MainSearchView.h"

#import "HomeListApi.h"
#import "HomeSearchDefaultApi.h"

@interface MyMainSearchViewController () <UITableViewDelegate, UITableViewDataSource, WMZTagDelegate, MainSearchViewDelegate, WMZTagCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MyMainSearchFooterView *footerView;
@property (nonatomic, strong) MainSearchView *searchView;
@property (strong, nonatomic) NSString *searchInfoText;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *dataHistoryList;
@property (nonatomic, assign) CGFloat maxRowHeight1;
@property (nonatomic, assign) CGFloat maxRowHeight2;
@property (nonatomic, strong) NSArray *search_keywords;
@property (nonatomic, assign) BOOL isSearched;

@end

@implementation MyMainSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    //加载刷新控件
    [self loadData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    [self getSearchDefaultRequest:YES Complate:^(BOOL isSuccess) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入搜索页面事件
    [MyAOPManager relateStatistic:@"SearchViewAppear" Info:@{}];
    
    [self.tableView reloadData];
}

- (void)prepareBasic
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    if (array == NULL)
    {
        array = @[];
    }
    self.dataArray = [NSMutableArray arrayWithArray:@[array, @[]]];
    self.maxRowHeight1 = 70;
    self.maxRowHeight2 = 70;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBar.title = self.title;
    [self.navBar addSubview:self.searchView];
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"搜索".localized titleColor:MAIN_COLOR];
    self.navBar.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.navBar setOnClickRightButton:^{
        NSString * searchText = weakSelf.searchView.searchTextField.text;
        NSArray * defaultText = [DeviceInfo shareInstance].homeSearchDefaultTitleList;
        if (searchText.length == 0 && defaultText.count > 0)
        {
            weakSelf.searchView.searchTextField.text = defaultText[weakSelf.searchView.current];
            searchText = weakSelf.searchView.searchTextField.text;
        }
        [weakSelf getSearchViewText:searchText];
    }];
}

#pragma mark ——— 初始化搜索框
- (MainSearchView *)searchView
{
    if (!_searchView)
    {
        _searchView = [self createBallView];
        _searchView.delegate = self;
        _searchView.frame = CGRectMake(50, self.navBar.height - (44 - 30) / 2 - 30, self.navBar.width - 110, 30);
        _searchView.isHome = self.isHome;
    }
    return _searchView;
}

- (MainSearchView *)createBallView
{
    MainSearchView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainSearchView class]) owner:nil options:nil] firstObject];
    return view;
}

#pragma mark ——— MainSearchViewDelegate
- (void)getSearchViewText:(NSString *)string
{
    if (string.length == 0) {
        self.isSearched = false;
        [self.tableView reloadData];
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.tableView.tableHeaderView = header;
        self.tableView.tableFooterView = self.footerView;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        return;
    }
    self.pageNumber = 1;
    self.searchInfoText = string;
    [self searchGamelistRequest:NO Complate:^(BOOL isSuccess) {
        
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackColor;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameTableViewCell"];
    }
    return _tableView;
}

- (MyMainSearchFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[MyMainSearchFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 590)];
    }
    return _footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isSearched ? self.dataSource.count : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearched)
    {
        GameModel * model = self.dataSource[indexPath.section];
        model.listType = @"7";
        return model.cellHeight + 20;
    }
    else
    {
        NSLog(@"height=%f,%f",self.maxRowHeight1,self.maxRowHeight2);
        NSArray * array = self.dataArray[indexPath.section];
        if (indexPath.section == 0)
        {
            return array.count == 0 ? 0.001 : self.maxRowHeight1;
        }
        else
        {
            return array.count == 0 ? 0.001 : self.maxRowHeight2;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearched)
    {
        return [UIView new];
    }
    else
    {
        NSArray * array = self.dataArray[section];
        if (array.count == 0)
        {
            return [UIView new];
        }
        else
        {
            MyMainSearchSectionView * sectionView = [[MyMainSearchSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
            sectionView.showTitle.text = section == 0 ? @"搜索历史" : @"搜索热词";
            sectionView.deleteBtn.hidden = section == 0 ? NO : YES;
            sectionView.deleteTagsBlock = ^{
                if (self.dataArray.count > 0)
                {
                    [YYToolModel deleteUserdefultforKey:@"searchHistory"];
                    [self.dataArray replaceObjectAtIndex:0 withObject:@[]];
                    [self.tableView reloadData];
                }
            };
            return sectionView;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearched)
    {
        return 10;
    }
    else
    {
        NSArray * array = self.dataArray[section];
        return array.count == 0 ? 0.001 : 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearched)
    {
        static NSString * identifity = @"GameTableViewCell";
        GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
        }
        cell.source = @"home";
        cell.containViewHeight = 20;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listType = @"7";
        GameModel * model = self.dataSource[indexPath.section];
        model.listType = @"7";
        [cell setModelDic:[model mj_JSONObject]];
        cell.radiusView.layer.cornerRadius = 13;
        return cell;
    }
    else
    {
        MyMainSearchTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
        if(!cell)
        {
            cell = [[MyMainSearchTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld-%ld",indexPath.section, indexPath.row] IndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.section];
        cell.delegate = self;
        cell.myTag.tag = indexPath.section + 1;
        cell.tagClickBlock = ^(NSInteger idx ,NSString * _Nonnull tag) {
            if (indexPath.section == 1) {
                NSDictionary * item = self.search_keywords[idx];
                if ([item[@"type"] isEqualToString:@"tag"]) {
                    if (self.isHome) {
                        UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
                        [nav.tabBarController setSelectedIndex:1];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:false];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGameType" object:item[@"tid"]];
                        });
                    }else{
                        [self.navigationController popViewControllerAnimated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGameType" object:item[@"tid"]];
                        });
                    }
                }else{
                    self.searchView.searchTextField.text = tag;
                    [self getSearchViewText:tag];
                    //统计搜索历史或者搜索热词
                    [MyAOPManager relateStatistic:indexPath.section == 0 ? @"ClickSearchHistory" : @"ClickHotSearchWords" Info:@{@"text":tag}];
                }
            }else{
                self.searchView.searchTextField.text = tag;
                [self getSearchViewText:tag];
                //统计搜索历史或者搜索热词
                [MyAOPManager relateStatistic:indexPath.section == 0 ? @"ClickSearchHistory" : @"ClickHotSearchWords" Info:@{@"text":tag}];
            }
        };
        NSArray * array = self.dataArray[indexPath.section];
        cell.hidden = array.count == 0 ? YES : NO;
        cell.myTag.delegate = self;
        cell.myTag.tagViewHeight = indexPath.section == 0 ? self.maxRowHeight1 : self.maxRowHeight2;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearched)
    {
        NSDictionary * dic = [self.dataSource[indexPath.section] mj_JSONObject];
        [self insertToHistoryList:dic[@"game_name"]];
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic[@"game_id"];
        detailVC.title  = dic[@"game_name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//tag的代理方法 支持tableview刷新
- (void)updateCell:(id)cell data:(NSArray *)data
{
    NSLog(@"刷新回调 %@",data);
    [UIView performWithoutAnimation:^{
        NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell*)cell];
        self.dataArray[path.section] = data;
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }];

}

- (void)updateTagsFrame:(NSInteger)tag Height:(CGFloat)height
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:tag-1];
    MyMainSearchTagsCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (tag == 1) {
        self.maxRowHeight1 = height > 70 ? 70 : height;
        cell.myTag.tagViewHeight = self.maxRowHeight1;
    }else{
        self.maxRowHeight2 = height;
        cell.myTag.tagViewHeight = self.maxRowHeight2;
    }
}

- (void)loadData {
    __unsafe_unretained UITableView *tableView = self.tableView;

    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.isSearched)
        {
            [tableView.mj_footer resetNoMoreData];
            self.pageNumber = 1;
            [self searchGamelistRequest:NO Complate:^(BOOL isSuccess) {
                [tableView.mj_header endRefreshing];
            }];
        }
        else
        {
            [self getSearchDefaultRequest:NO Complate:^(BOOL isSuccess) {
                [tableView.mj_header endRefreshing];
            }];
        }
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self searchGamelistRequest:NO Complate:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

#pragma mark ——— 获取搜索的数据
- (void)searchGamelistRequest:(BOOL)isShow Complate:(RequestData)block
{
    SearchApi *api = [[SearchApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.search_info = self.searchInfoText;
    api.isSearch = YES;
    api.mainType = @"0";
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        [self handleListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (void)handleListSuccess:(SearchApi *)api
{
    if (api.success == 1)
    {
        if (self.searchView.searchTextField.text.length == 0) {
            UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            header.backgroundColor = UIColor.clearColor;
            self.tableView.tableHeaderView = header;
            return;
        }
        self.tableView.ly_emptyView.contentView.hidden = NO;
        if (![[api.data objectForKey:@"gameList"] isKindOfClass:[NSArray class]]) {
            [self.tableView reloadData];
            return;
        }
        NSArray *array = [GameModel mj_objectArrayWithKeyValuesArray:[api.data objectForKey:@"gameList"]];
        if (self.pageNumber == 1)
        {
            self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        }
        else
        {
            [self.dataSource addObjectsFromArray:array];
        }
        
        NSDictionary *dic = api.data[@"paginated"];
        [self.tableView.mj_footer resetNoMoreData];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        if (self.searchView.searchTextField.text == 0) {
            self.isSearched = false;
        }else{
            self.isSearched = YES;
        }
        [self.tableView reloadData];
        NSString * recommendWords = api.data[@"recommendWords"];
        if (recommendWords.length > 0) {
            UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 14)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorWithHexString:@"#999999"];
            label.textAlignment = 1;
            label.text = recommendWords;
            [header addSubview:label];
            self.tableView.tableHeaderView = header;
        }else{
            UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            header.backgroundColor = UIColor.clearColor;
            self.tableView.tableHeaderView = header;
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

#pragma mark ——— 存储当前搜索的内容
- (void)insertToHistoryList:(NSString *)value
{
    if (value.length == 0)
    {
        return;
    }

    //统计搜索成功事件
    [MyAOPManager relateStatistic:@"SearchDataSuccess" Info:@{@"text":value}];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"];
    self.dataHistoryList = [NSMutableArray array];
    if (array)
    {
        [self.dataHistoryList addObjectsFromArray:array];

    }
    if (![self.dataHistoryList containsObject:value])
    {
        if (self.dataHistoryList.count > 0)
        {
            [self.dataHistoryList insertObject:value atIndex:0];
        }
        else
        {
            [self.dataHistoryList addObject:value];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.dataHistoryList forKey:@"searchHistory"];
    }
}

- (void)getSearchDefaultRequest:(BOOL)isShow Complate:(RequestData)block
{
    HomeSearchDefaultApi *api = [[HomeSearchDefaultApi alloc] init];
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        [self handleGetDefaultApiSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (void)handleGetDefaultApiSuccess:(HomeSearchDefaultApi *)api
{
    if (api.success == 1)
    {
        NSLog(@"api.data= %@",api.data);
//        self.dataSearchSource = api.data[@"recommend_game_list"];
        self.search_keywords = api.data[@"search_keywords"];
        [self.dataArray replaceObjectAtIndex:1 withObject:api.data[@"search_keyword"]];
        self.tableView.tableFooterView = self.footerView;
        self.footerView.dataDic = api.data;
        [self.tableView reloadData];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
