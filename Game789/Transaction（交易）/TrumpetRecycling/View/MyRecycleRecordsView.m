//
//  MyRecycleRecordsView.m
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRecycleRecordsView.h"
#import "UserPayGoldViewController.h"

#import "MyRecycleRecordsCell.h"
#import "MyRansomAlertView.h"

#import "MyRecycleGameListApi.h"
@class MyRecycleRecordsApi;

@implementation MyRecycleRecordsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self loadData];
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setIsLoaded:(BOOL)isLoaded
{
    _isLoaded = isLoaded;
    if (_isLoaded)
    {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)getRecycleRecordsList
{
    MyRecycleRecordsApi * api = [[MyRecycleRecordsApi alloc] init];
    api.isRedeem = self.isRedeem;
    api.isRedeemed = self.isRedeemed;
    api.pageNumber = self.pageNumber;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            NSArray * array = api.data[@"list"];
            NSMutableArray * tplArray = [NSMutableArray array];
            for (NSDictionary * dic in array)
            {
                MyRecycleRecordsModel * model = [[MyRecycleRecordsModel alloc] initWithDictionary:dic];
                [tplArray addObject:model];
            }
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:tplArray];
            }
            else
            {
                [self.dataArray addObjectsFromArray:tplArray];
            }
            NSDictionary *dic = api.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:[self.currentVC creatFooterView]];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;

        } else {
            [MBProgressHUD showToast:api.error_desc toView:self.currentVC.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackColor;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"recycle_no_data" titleStr:@"暂无赎回记录" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
    }
    return _tableView;
}
#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    MyRecycleRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyRecycleRecordsCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self.currentVC;
    cell.index = self.index;
    cell.recordModel = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.section);
    
    NSDictionary * member_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    BOOL isRealNameAuth = [member_info[@"isRealNameAuth"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAuth && !isRealNameAuth) {
        [AuthAlertView showAuthAlertViewWithDelegate:self];
        return;
    }
    
    BOOL isAdult = [member_info[@"isAdult"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAdult && !isAdult) {
        [AdultAlertView showAdultAlertView];
        return;
    }
    
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
    {
        [[YYToolModel getCurrentVC].navigationController pushViewController:[BindMobileViewController new] animated:YES];
        return;
    }
    
    if (self.index == 1)
    {
        MyRecycleRecordsModel * model = self.dataArray[indexPath.section];
        MyRansomAlertView * ransomAlertView = [[MyRansomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        ransomAlertView.showDetail.text = [NSString stringWithFormat:@"%@%@%@", @"赎回该小号需".localized, model.redeemdAmount, @"元".localized];
        ransomAlertView.type = @"2";
        ransomAlertView.agree = ^(BOOL isAgree) {
            UserPayGoldViewController * pay = [UserPayGoldViewController new];
            pay.isRecycle = YES;
            pay.redeemUrl = model.redeemUrl;
            [self.currentVC.navigationController pushViewController:pay animated:YES];
        };
        [[UIApplication sharedApplication].delegate.window addSubview:ransomAlertView];
    }
}

- (void)onAuthSuccess{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];
    [dic setValue:@1 forKey:@"isRealNameAuth"];
    [NSUserDefaults.standardUserDefaults setValue:dic forKey:@"member_info"];
    [NSUserDefaults.standardUserDefaults synchronize];
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
        [self getRecycleRecordsList];
        [tableView.mj_header endRefreshing];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getRecycleRecordsList];
        [tableView.mj_footer endRefreshing];
    }];
}

@end
