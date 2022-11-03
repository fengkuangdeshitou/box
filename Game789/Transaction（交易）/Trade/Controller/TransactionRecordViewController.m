//
//  TransactionRecordViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TransactionRecordViewController.h"
#import "tradingViewCell.h"
#import "TradingListApi.h"
#import "ProductDetailsViewController.h"
#import "TradingObtainedApi.h"

@interface TransactionRecordViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataArray1;
@property (nonatomic, strong) NSMutableArray * dataArray2;
@property (nonatomic, strong) NSMutableArray * dataArray3;

@property (nonatomic, assign) NSInteger  selectIndex;
@property (nonatomic, assign) NSInteger  pageNumber1;
@property (nonatomic, assign) NSInteger  pageNumber2;
@property (nonatomic, assign) NSInteger  pageNumber3;
@property (nonatomic, assign) NSInteger  pageNumber4;

@end

@implementation TransactionRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    self.navBar.title = @"交易记录";
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.selectIndex = 0;
    self.pageNumber1 = 1;
    self.pageNumber2 = 1;
    self.pageNumber3 = 1;
    self.pageNumber4 = 1;
    
    [self creatTopView];
    
    [self.view addSubview:self.scrollView];
    
    [self getData:@"" Data:nil Hud:YES];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.topView.frame) - kTabbarSafeBottomMargin)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreenW * 4, _scrollView.height);
        
        for (int i = 0; i < 4; i ++)
        {
            CGFloat view_y = i == 2 ? 25 : 0;
            UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * kScreenW, view_y, _scrollView.width, _scrollView.height - view_y)];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tag = i + 20;
            tableView.backgroundColor = BackColor;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"trade_no_data" titleStr:[self showNothingData:i] detailStr:@""];
            tableView.ly_emptyView.contentView.hidden = YES;
            [_scrollView addSubview:tableView];
            //初始化刷新控件
            [self loadData:tableView];
            if (i == 2)
            {
                tableView.y = 25;
                UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, 25)];
                tipLabel.text = @"温馨提示:左滑即可下架该交易";
                tipLabel.font = [UIFont systemFontOfSize:14];
                tipLabel.textColor = [UIColor redColor];
                tipLabel.textAlignment = NSTextAlignmentCenter;
                tipLabel.backgroundColor = UIColor.clearColor;
                [_scrollView addSubview:tipLabel];
            }
        }
    }
    return _scrollView;
}

#pragma mark - 创建顶部view
- (void)creatTopView
{
    UIView * topView = [[UIView alloc] initWithFrame: CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    self.topView = topView;
    
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height - 1, kScreenW, 1)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#E0E5E0"];
    [topView addSubview:sepView];
    
    CGFloat button_width = kScreenW / 4;
    NSArray * titleArray = @[@"全部", @"已购买", @"已提交", @"已出售"];
    for (int i = 0; i < titleArray.count; i ++)
    {
        UIButton * button = [UIControl creatButtonWithFrame:CGRectMake(i * button_width, 0, button_width, 45) backgroundColor:[UIColor clearColor] title:[titleArray[i] localized] titleFont:[UIFont systemFontOfSize:14] actionBlock:^(UIControl *control)
        {
            [self switchTypeAction:(UIButton *)control];
        }];
        button.tag = i + 10;
        [button setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [topView addSubview:button];
        
        if (i == 0)
        {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
            self.selectButton = button;
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(button.center.x - 9, topView.height - 13, 18, 3)];
            lineView.backgroundColor = MAIN_COLOR;
            lineView.layer.cornerRadius = 1.5;
            lineView.layer.masksToBounds = YES;
            [topView addSubview:lineView];
            self.lineView = lineView;
        }
    }
}

#pragma mark - 点击切换交易记录状态
- (void)switchTypeAction:(UIButton *)sender
{
    if (self.selectButton != sender)
    {
        self.selectButton.selected = NO;
        self.selectButton.titleLabel.font = [UIFont systemFontOfSize:14];
        sender.selected = YES;
        sender.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.selectButton = sender;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView.ly_centerX = sender.center.x;
        }];
        
        self.scrollView.contentOffset = CGPointMake((sender.tag - 10) * kScreenW, 0);
        
        self.selectIndex = self.scrollView.contentOffset.x / kScreenW;
        
        NSString * type = @"";
        if (self.selectIndex == 0)
        {
            type = @"";
            self.pageNumber = self.pageNumber1;
            if (self.dataArray.count > 0)
            {
                return;
            }
        }
        else if (self.selectIndex == 1)
        {
            type = @"1";
            self.pageNumber = self.pageNumber2;
            if (self.dataArray1.count > 0)
            {
                return;
            }
        }
        else if (self.selectIndex == 2)
        {
            type = @"0,2,3";
            self.pageNumber = self.pageNumber3;
            if (self.dataArray2.count > 0)
            {
                return;
            }
        }
        else if (self.selectIndex == 3)
        {
            type = @"1";
            self.pageNumber = self.pageNumber4;
            if (self.dataArray3.count > 0)
            {
                return;
            }
        }
        [self getData:type Data:nil Hud:YES];
    }
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == 2)
    {
        return YES;
    }
    return NO;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex == 2)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (self.selectIndex == 2)
        {
            [self jxt_showAlertWithTitle:@"确定要下架此账号吗？" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1)
                {
                    TradingListModel * model = self.dataArray2[indexPath.row];
                    TradingObtainedApi * api = [[TradingObtainedApi alloc] init];
                    api.trade_id = model.trade_id;
                    api.trade_status = @"-1";
                    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                        
                        if (request.success == 1)
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataTradeStatus" object:nil];
                            
                            [MBProgressHUD showToast:@"下架成功"];
                            [self.dataArray2 removeObjectAtIndex:indexPath.row];
                            [tableView reloadData];
                        }
                        else
                        {
                            [MBProgressHUD showToast:request.error_desc];
                        }
                        
                    } failureBlock:^(BaseRequest * _Nonnull request) {
                        
                    }];
                }
            }];
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"下架";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectIndex == 0)
    {
        return self.dataArray.count;
    }
    else if (self.selectIndex == 1)
    {
        return self.dataArray1.count;
    }
    else if (self.selectIndex == 2)
    {
        return self.dataArray2.count;
    }
    else
    {
        return self.dataArray3.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    tradingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
    }
    if (self.selectIndex == 0)
    {
        cell.isShow = YES;
        cell.listModel = self.dataArray[indexPath.row];
    }
    else if (self.selectIndex == 1)
    {
        cell.listModel = self.dataArray1[indexPath.row];
    }
    else if (self.selectIndex == 2)
    {
        cell.isShow = YES;
        cell.listModel = self.dataArray2[indexPath.row];
    }
    else
    {
        cell.listModel = self.dataArray3[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradingListModel * model = [[TradingListModel alloc] init];
    
    if (self.selectIndex == 0)
    {
        model = self.dataArray[indexPath.row];
    }
    else if (self.selectIndex == 1)
    {
        model = self.dataArray1[indexPath.row];
    }
    else if (self.selectIndex == 2)
    {
        model = self.dataArray2[indexPath.row];
    }
    else if (self.selectIndex == 3)
    {
        model = self.dataArray3[indexPath.row];
    }
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        NSInteger index = scrollView.contentOffset.x / kScreenW;
        
        UIButton * button = (UIButton *)[self.topView viewWithTag:index + 10];
        [self switchTypeAction:button];
    }
}

#pragma mark - 获取数据
- (void)getData:(NSString *)trade_type Data:(RequestData)block Hud:(BOOL)isShow
{
    TradingListApi * api = [[TradingListApi alloc] init];
    api.trade_type = trade_type;
    api.isShow = isShow;
    if (self.selectIndex == 0)
    {
        api.buy_member_id = @"Y";
        api.member_id = @"Y";
        api.pageNumber = self.pageNumber1;
    }
    else if (self.selectIndex == 1)
    {
        api.buy_member_id = @"Y";
        api.pageNumber = self.pageNumber2;
    }
    else if (self.selectIndex == 2)
    {
        api.member_id = @"Y";
        api.pageNumber = self.pageNumber3;
    }
    else if (self.selectIndex == 3)
    {
        api.member_id = @"Y";
        api.pageNumber = self.pageNumber4;
    }
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleListSuccess:(TradingListApi *)request
{
    if (request.success == 1)
    {
        NSInteger index = self.scrollView.contentOffset.x / kScreenW;
        UITableView * tableView = (UITableView *)[self.scrollView viewWithTag:index + 20];
        
        NSArray *array = [TradingListModel mj_objectArrayWithKeyValuesArray:request.data[@"account_list"]];
        if (self.pageNumber == 1)
        {
            if (self.selectIndex == 0)
            {
                self.dataArray = [[NSMutableArray alloc] initWithArray:array];
            }
            else if (self.selectIndex == 1)
            {
                self.dataArray1 = [[NSMutableArray alloc] initWithArray:array];
            }
            else if (self.selectIndex == 2)
            {
                self.dataArray2 = [[NSMutableArray alloc] initWithArray:array];
            }
            else
            {
                self.dataArray3 = [[NSMutableArray alloc] initWithArray:array];
            }
        }
        else
        {
            if (self.selectIndex == 0)
            {
                [self.dataArray addObjectsFromArray:array];
            }
            else if (self.selectIndex == 1)
            {
                [self.dataArray1 addObjectsFromArray:array];
            }
            else if (self.selectIndex == 2)
            {
                [self.dataArray2 addObjectsFromArray:array];
            }
            else
            {
                [self.dataArray3 addObjectsFromArray:array];
            }
        }
        tableView.ly_emptyView.contentView.hidden = NO;
        
        NSDictionary *dic = request.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:tableView Data:dic FooterView:[self creatFooterView]];
        [tableView reloadData];
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}


#pragma mark - 初始化刷新控件
- (void)loadData:(UITableView *)tableView1
{
    __unsafe_unretained UITableView *tableView = tableView1;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        [self getType:YES];
        [tableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getType:NO];
        [tableView.mj_footer endRefreshing];
    }];
}

- (void)getType:(BOOL)isRefresh
{
    NSString * type = @"";
    if (self.selectIndex == 0)
    {
        type = @"";
        (isRefresh) ? (self.pageNumber1 = 1) : (self.pageNumber1 ++);
        self.pageNumber = self.pageNumber1;
    }
    else if (self.selectIndex == 1)
    {
        type = @"1";
        (isRefresh) ? (self.pageNumber2 = 1) : (self.pageNumber2 ++);
        self.pageNumber = self.pageNumber2;
    }
    else if (self.selectIndex == 2)
    {
        type = @"0,2,3";
        (isRefresh) ? (self.pageNumber3 = 1) : (self.pageNumber3 ++);
        self.pageNumber = self.pageNumber3;
    }
    else if (self.selectIndex == 3)
    {
        type = @"1";
        (isRefresh) ? (self.pageNumber4 = 1) : (self.pageNumber4 ++);
        self.pageNumber = self.pageNumber4;
    }
    [self getData:type Data:nil Hud:YES];
}

- (NSString *)showNothingData:(int)index
{
    NSString * str = @"咦～什么都没有…";
    switch (index) {
        case 0:
            str = @"暂无交易记录";
        break;
        case 1:
            str =  @"暂无购买记录";
        break;
        case 2:
            str =  @"暂无提交记录";
        break;
        case 3:
            str =  @"暂无出售记录";
        break;
        
        default:
        break;
    }
    return str.localized;
}

@end
