//
//  TradingSearchGameController.m
//  Game789
//
//  Created by Maiyou on 2018/8/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingSearchGameController.h"
#import "TradingListApi.h"
#import "tradingViewCell.h"
#import "ProductDetailsViewController.h"

@interface TradingSearchGameController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UITextField * searchTextField;
@end

@implementation TradingSearchGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self creatSearchView];
    [self loadData];
    
    if (self.gameName.length > 0)
    {
        self.searchTextField.text = self.gameName;
        [self searchGameWithText];
    }
}

- (void)creatSearchView
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(50, self.navBar.height - 39.5, kScreenW - 100, 35)];
    backView.backgroundColor = MYColor(243, 245, 252);
    backView.layer.cornerRadius = backView.height / 2;
    backView.layer.masksToBounds = YES;
    [self.navBar addSubview:backView];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, backView.width - 30, 35)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.placeholder = @"搜索要查找的游戏".localized;
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(valueChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [backView addSubview:textField];
    self.searchTextField = textField;
}

- (void)valueChangeAction:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        [self searchGameWithText];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchGameWithText];
    
    return YES;
}

#pragma mark - 搜索游戏
- (void)searchGameWithText
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.trade_type = @"3";
    api.game_name = self.searchTextField.text;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
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
        if (self.dataArray.count >= [dic[@"total"] integerValue])
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
        self.tableView.ly_emptyView.contentView.hidden = NO;
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
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self searchGameWithText];
        
        [tableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self searchGameWithText];
        [tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - 初始化tableView
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        self.tableView.ly_emptyView.contentView.hidden = YES;
    }
    return _tableView;
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
    
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.navigationController pushViewController:product animated:YES];
}

@end
