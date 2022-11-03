//
//  ActiveListViewController.m
//  Game789
//
//  Created by xinpenghui on 2018/3/18.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ActiveListViewController.h"
#import "ActiveListTableViewCell.h"
#import "GetMessageListApi.h"
#import "NoticeDetailViewController.h"
#import "ActiveNoticeTableViewCell.h"

@interface ActiveListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger selectIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *dataSource1;
@property (strong, nonatomic) NSMutableArray *dataSource2;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation ActiveListViewController
- (void)noticeRequest:(RequestData)block Hud:(BOOL)isShow
{
    GetMessageListApi *api = [[GetMessageListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.news_type = self.selectIndex == 0 ? @"1" : @"2";
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(GetMessageListApi *)api
{
    if (api.success == 1)
    {
        if (self.selectIndex == 0)
        {
            if (self.pageNumber == 1)
            {
                self.dataSource1 = [[NSMutableArray alloc] initWithArray:api.data[@"top_news_list"]];
            }
            else
            {
                [self.dataSource1 addObjectsFromArray:api.data[@"top_news_list"]];
            }
            self.dataSource = self.dataSource1;
        }
        else
        {
            if (self.pageNumber == 1)
            {
                self.dataSource2 = [[NSMutableArray alloc] initWithArray:api.data[@"top_news_list"]];
            }
            else
            {
                [self.dataSource2 addObjectsFromArray:api.data[@"top_news_list"]];
            }
            self.dataSource = self.dataSource2;
        }
        
        NSDictionary *pageDic = api.data[@"paginated"];
        self.hasNextPage = [pageDic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:pageDic FooterView:[self creatFooterView]];
        [self.tableView reloadData];
    }
    else {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"活动中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.selectIndex = 0;
    [self addUI];
    self.pageNumber = 1;
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadData {
    __unsafe_unretained UITableView *tableView = self.tableView;

    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self noticeRequest:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self noticeRequest:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

- (void)addUI {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, 44)];
    [self.view addSubview:topView];

    UIView *topViewLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width/2, 44)];
    [topView addSubview:topViewLeftView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreen_width/2, 43);
    [btn setTitleColor:FontColor28 forState:UIControlStateSelected];
    [btn setTitleColor:FontColor66 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    btn.tag = 10110;
    btn.selected = YES;
    [btn setTitle:@"活动推荐".localized forState:UIControlStateNormal];
    [topViewLeftView addSubview:btn];
    [btn addTarget:self action:@selector(topButtonPress:) forControlEvents:UIControlEventTouchUpInside];

    UIView *bottomLabel = [[UIView alloc] initWithFrame:CGRectMake(topViewLeftView.ly_centerX - 17, topViewLeftView.height - 8, 18, 3)];
    bottomLabel.backgroundColor = MAIN_COLOR;
    bottomLabel.layer.cornerRadius = 1.5;
    bottomLabel.layer.masksToBounds = YES;
    [topView addSubview:bottomLabel];
    self.lineView = bottomLabel;


    UIView *topViewRightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width/2, 0, kScreen_width/2, 44)];
    [topView addSubview:topViewRightView];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, kScreen_width/2, 43);
    [btn2 setTitleColor:FontColor28 forState:UIControlStateSelected];
    [btn2 setTitleColor:FontColor66 forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    btn2.tag = 10111;
    [btn2 setTitle:@"活动公告".localized forState:UIControlStateNormal];
    [topViewRightView addSubview:btn2];
    [btn2 addTarget:self action:@selector(topButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)topButtonPress:(UIButton *)btn
{
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = btn.superview.ly_centerX;
    }];
    
    if (btn.tag == 10110) {
        if (!btn.selected) {
            self.selectIndex = 0;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];

            UIButton *btn2 = [self.view viewWithTag:10111];
            btn2.selected = NO;
            btn2.titleLabel.font = [UIFont systemFontOfSize:14];
            
            if (!self.dataSource1) {
                [self noticeRequest:nil Hud:YES];
            }
            else {
                self.dataSource = self.dataSource1;
                [self.tableView reloadData];
            }
        }
        else {

        }
    }
    else {
        if (!btn.selected) {
            self.selectIndex = 1;
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];

            UIButton *btn2 = [self.view viewWithTag:10110];
            btn2.selected = NO;
            btn2.titleLabel.font = [UIFont systemFontOfSize:14];

            if (!self.dataSource2) {
                [self noticeRequest:nil Hud:YES];
            }
            else {
                self.dataSource = self.dataSource2;
                [self.tableView reloadData];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex == 0) {
        return 185;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"ActiveListTableViewCell";
    if (self.selectIndex == 0) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell setModelDic:dic];
        return cell;
    }
    identifier = @"ActiveNoticeTableViewCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModelDic:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [self pushToDetailVC:dic];
}
- (void)pushToDetailVC:(NSDictionary *)dic {
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
    detailVC.news_id = dic[@"news_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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

#pragma mark --lazy load--
- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+44, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight-kTabbarSafeBottomMargin-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"ActiveListTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ActiveNoticeTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"ActiveNoticeTableViewCell"];

    }
    return _tableView;
}

@end
