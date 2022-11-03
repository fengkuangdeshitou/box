//
//  MytryPlayViewController.m
//  Game789
//
//  Created by Maiyou on 2020/12/31.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MytryPlayViewController.h"
#import "MyTryPlayQuestionController.h"

#import "MyTryPlayListCell.h"
#import "MyTryPlayHeaderView.h"

#import "MyTryPlayApi.h"

@interface MytryPlayViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyTryPlayHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MytryPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self basicPrepare];
    
    [self loadData];
    
    [self getTryPlayData:YES DataComplete:nil];
}

- (void)basicPrepare
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    WEAKSELF
    self.navBar.title = @"试玩任务";
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    self.navBar.lineView.hidden = YES;
    self.navBar.backgroundColor = UIColor.clearColor;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    [self.navBar wr_setRightButtonWithImage:MYGetImage(@"try_play_intro_icon")];
    self.navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.navBar setOnClickRightButton:^{
        [weakSelf.navigationController pushViewController:[MyTryPlayQuestionController new] animated:YES];
    }];
    
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
}

- (void)getTryPlayData:(BOOL)isShow DataComplete:(RequestData)block
{
    MyTryPlayApi * api = [[MyTryPlayApi alloc] init];
    api.isShow = isShow;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"list"])
            {
                MyTryPlayModel * model = [[MyTryPlayModel alloc] initWithDictionary:dic];
                [array addObject:model];
            }
            self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:array] : [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self setFooterViewState:self.tableView Data:request.data[@"paginated"] FooterView:[self creatFooterView]];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.tableHeaderView = self.headerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyTryPlayListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTryPlayListCell"];
        
        if (@available(iOS 11.0, *))
        {
//            _tableView.estimatedRowHeight = 100;
//            _tableView.estimatedSectionFooterHeight = 0;
//            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (MyTryPlayHeaderView *)headerView
{
    if (!_headerView)
    {
        CGFloat height = 183.f * kScreenW / 375.f;
        _headerView = [[MyTryPlayHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, height)];
    }
    return _headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyTryPlayListCell";
    MyTryPlayListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.bgImageView.hidden = indexPath.section == 0 ? NO : YES;
    cell.dataModel = self.dataArray[indexPath.section];
    cell.receivedActionBlock = ^{
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"=======%ld", (long)indexPath.section);
    
    MyTryPlayModel * dataModel = self.dataArray[indexPath.section];
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.maiyou_gameid = [NSString stringWithFormat:@"%ld", (long)dataModel.gameid];
    [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0)
    {
        self.navBar.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:scrollView.contentOffset.y / 44.f];
    }
    else
    {
        self.navBar.backgroundColor = UIColor.clearColor;
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getTryPlayData:NO DataComplete:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getTryPlayData:NO DataComplete:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
