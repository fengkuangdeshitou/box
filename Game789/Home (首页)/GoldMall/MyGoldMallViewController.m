//
//  MyGoldMallViewController.m
//  Game789
//
//  Created by maiyou on 2021/3/9.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGoldMallViewController.h"
#import "MyGoldMallCell.h"
#import "GoldMallModel.h"
#import "MyGoldExchangeViewController.h"
#import "MyLimitedBuyGetCoinView.h"
#import "UserCoinsHistoryViewController.h"
#import "GoldMallRequestAPI.h"

@interface MyGoldMallViewController ()<UITableViewDelegate,UITableViewDataSource,MyGoldMallCellDelegate>

@property(nonatomic,strong)NSDictionary * userInfo;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * imageHeight;
@property(nonatomic,weak)IBOutlet UILabel * goldNumberLabel;
@property(nonatomic,weak)IBOutlet UIView * roundView;
@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

@end

@implementation MyGoldMallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"金币商城".localized;
    self.navBar.titleLable.textColor = UIColor.whiteColor;
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = true;
    [self.navBar.leftButton setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
    [self.navBar wr_setRightButtonWithTitle:@"金币明细".localized titleColor:FontColor66];
    self.imageHeight.constant = ScreenWidth/375*215;
    WEAKSELF
    [self.navBar setOnClickRightButton:^{
        [weakSelf goldHistory];
    }];
    
    self.roundView.layer.borderColor = [UIColor colorWithHexString:@"#FEAA51"].CGColor;
    self.roundView.layer.borderWidth = 0.5;
    self.roundView.layer.cornerRadius = 15;
    
    self.tableView.rowHeight = 96;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyGoldMallCell" bundle:nil] forCellReuseIdentifier:@"MyGoldMallCell"];
    self.tableView.tableFooterView = [self creatFooterView];
    
    [self loadGoodsListData:nil Hud:YES];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/// 请求数据
- (void)loadGoodsListData:(RequestData)block Hud:(BOOL)isShow
{
    GoldMallAPI * api = [[GoldMallAPI alloc] init];
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            NSDictionary * resultObject = [request.data deleteAllNullValue];
            self.goldNumberLabel.text = [NSString stringWithFormat:@"我的金币:%@", resultObject[@"balance"]];
            self.dataArray = [GoldMallModel mj_objectArrayWithKeyValuesArray:resultObject[@"list"]];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

/// 刷新金币
/// @param sender 按钮
- (IBAction)reloadGoldData:(UIButton *)sender
{
    [self loadGoodsListData:nil Hud:YES];
}

/// MyGoldMallCellDelegate
- (void)onExchangeSuccess
{
    [self loadGoodsListData:nil Hud:YES];
}

/// 获取金币简介
/// @param sender 按钮
- (IBAction)goldDescAction:(UIButton *)sender
{
    MyLimitedBuyGetCoinView * getCoinView = [[MyLimitedBuyGetCoinView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:getCoinView];
}

/// 金币记录
/// @param sender 按钮
- (void)goldHistory
{
    UserCoinsHistoryViewController * history = [[UserCoinsHistoryViewController alloc]init];
    history.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:history animated:YES];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellName = @"MyGoldMallCell";
    MyGoldMallCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    GoldMallModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self loadGoodsListData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
}

@end
