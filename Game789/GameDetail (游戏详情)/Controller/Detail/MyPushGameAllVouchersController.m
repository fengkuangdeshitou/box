//
//  MyPushGameAllVouchersController.m
//  Game789
//
//  Created by Maiyou on 2020/7/21.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyPushGameAllVouchersController.h"
#import "MyVoucherListCell.h"
#import "MyGameVoucherListTopView.h"

#import "MyGetVoucherListApi.h"
#import "GameDetailApi.h"
@class MyReceiveGameVoucherApi;
@class GetGameVoucherListApi;

@interface MyPushGameAllVouchersController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MyPushGameAllVouchersController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.navBar.title = @"代金券";
    self.game_species_type = [self.dataDic[@"game_info"][@"game_species_type"] integerValue];
    
    [self loadData];
    
    [self getVoucherList];
    
    [self layoutUI];
}

- (void)getVoucherList
{
    GetGameVoucherListApi * api = [[GetGameVoucherListApi alloc] init];
    api.isShow = YES;
    api.gameId = self.dataDic[@"game_info"][@"game_id"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success)
        {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data)
            {
                MyVoucherListModel * voucherModel = [[MyVoucherListModel alloc] initWithDictionary:dic];
                [array addObject:voucherModel];
            }
            self.dataArray = array;
            self.tableView.ly_emptyView.contentView.hidden = NO;
            [self.tableView reloadData];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)layoutUI
{
    BOOL isDiscount = (self.game_species_type == 2 || self.game_species_type == 3) ? YES : NO;
    MyGameVoucherListTopView * topView = [[MyGameVoucherListTopView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight + 10, kScreenW, isDiscount ? 0 : 42)];
    topView.hidden = isDiscount;
    [self.view addSubview:topView];
    topView.monthCardClick = ^{
//        NSDictionary * dic = @{@"ab_test1":[NSString stringWithFormat:@"%@", self.dataDic[@"ab_test_game_detail_welfare"]]};
//        [MyAOPManager gameRelateStatistic:@"ClickMonthlyCardOnGameDetailsPage" GameInfo:self.dataDic[@"game_info"] Add:[self.dataDic[@"is_985"]  boolValue] ? dic : @{}];
    };
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat view_height = kStatusBarAndNavigationBarHeight + 10 + (self.game_species_type == 2 || self.game_species_type == 3 ? 0 : 42);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, view_height, kScreenW, kScreenH - view_height - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 94;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"voucher_no_data" titleStr:@"暂无可用代金券~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
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
    MyVoucherListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyVoucherListCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self;
    cell.isDetail = YES;
    cell.voucherModel = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![YYToolModel islogin])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LoginViewController * login = [LoginViewController new];
            login.isGameDetail = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:login animated:YES];
        });
        return;
    }
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    if ([YYToolModel isBlankString:dic[@"mobile"]])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
//            [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
//        });
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [MBProgressHUD showToast:@"请先绑定手机号"];
//        return;
//    }
    MyVoucherListModel * model = self.dataArray[indexPath.section];
    if (!model.is_received.boolValue)
    {
        [self receiveVoucher:model];
    }
}

- (void)receiveVoucher:(MyVoucherListModel *)model
{
    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
    api.voucher_id = model.Id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            //如果没有可领取的该状态
            if (![request.data[@"hasSome"] boolValue])
            {
                model.is_received = @"1";
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveVoucherSuccess" object:model.Id];
                if (self.receivedVoucherAction)
                {
                    self.receivedVoucherAction(self.dataArray, model);
                }
            }
            else
            {
                [MBProgressHUD showToast:@"领取成功" toView:[YYToolModel getCurrentVC].view];
            }
        }
        else
        {
            NSDictionary * data = api.responseObject;
            if (![data[@"status"][@"error_code"] isEqual:[NSNull null]] && [data[@"status"][@"error_code"] intValue] == 2001){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MyAlertConfigure * configure = [MyAlertConfigure new];
                    configure.btnTitleColors = @[ColorWhite];
                    configure.btnBackColors = @[MAIN_COLOR];
                    configure.btnTitles = @[@"开通会员"];
                    configure.content = api.error_desc;
                    [MyAlertView alertViewWithConfigure:configure buttonBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex == 0) {
                            SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
                            payVC.selectedIndex = 1;
                            payVC.hidesBottomBarWhenPushed = YES;
                            [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
                        }
                    }];
                });
            }else{
                [MBProgressHUD showToast:request.error_desc toView:self.view];
            }
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getVoucherList];
        [tableView.mj_header endRefreshing];
    }];
}


@end
