//
//  MyInviteRecordsController.m
//  Game789
//
//  Created by Maiyou001 on 2021/5/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyInviteRecordsController.h"
#import "MyInviteRecordListCell.h"
#import "InviteRecordsAPI.h"
#import "InviteRecordModel.h"

@interface MyInviteRecordsController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleView_top;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic)NSMutableArray * dataArray;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyInviteRecordsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"邀请明细";
    self.titleView_top.constant = kStatusBarAndNavigationBarHeight;
    [self.view addSubview:self.tableView];
    
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getRecordsList:(RequestData)block
{
    InviteRecordsAPI * api = [[InviteRecordsAPI alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 20;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1)
        {
            NSArray *array = [InviteRecordModel mj_objectArrayWithKeyValuesArray:request.data[@"dataList"]];
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
            if (self.dataArray.count >= [dic[@"total"] integerValue])
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
         [self getRecordsList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getRecordsList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        CGFloat view_y = kStatusBarAndNavigationBarHeight + 35;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, view_y, kScreenW, kScreenH - view_y - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"MyInviteRecordListCell" bundle:nil] forCellReuseIdentifier:@"MyInviteRecordListCell"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"search_no_data" titleStr:@"暂无邀请记录" detailStr:@""];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyInviteRecordListCell";
    MyInviteRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.InviteModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
