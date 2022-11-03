//
//  MyDailyTaskController.m
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyDailyTaskController.h"
#import "MyDailyTaskHeaderView.h"
#import "MyTaskFinishCell.h"
#import "MyTaskCenterApi.h"
@class MyGetTaskProgressApi;

@interface MyDailyTaskController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyDailyTaskHeaderView *headerView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL isShow;
@end

@implementation MyDailyTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navBar.title = @"每日任务";
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.titleLable.textColor = UIColor.whiteColor;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    self.navBar.lineView.hidden = YES;
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNoviceTaskProgress];
}

- (void)getNoviceTaskProgress
{
    MyGetTaskProgressApi * api = [[MyGetTaskProgressApi alloc] init];
    api.isShow = !self.isShow;
    api.type = @"day";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.isShow = YES;
            [self pramaData:request];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)pramaData:(BaseRequest * _Nonnull)request
{
    NSDictionary * dic = request.data[@"task_info"];
    for (int i = 0; i < self.dataArray.count; i ++)
    {
        MyTaskCellModel * model = self.dataArray[i];
        NSString * str = @"";
        switch (i) {
            case 0:
                str = @"loginGame";
                break;
            case 1:
                str = @"recharge";
                break;
//            case 2:
//                str = @"publishArticle";
//                break;
            case 2:
                str = @"wxshare";
                break;
            case 3:
                str = @"qqkongjian";
                break;
            
            default:
                break;
        }
        model.balance = dic[str][@"balance"];
        model.type = str;
        model.status = [dic[str][@"completed"] boolValue];
        model.taked  = [dic[str][@"taked"] boolValue];
    }
    [self.tableView reloadData];
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSArray * array = @[@{@"title":@"每日登录游戏", @"desc":@"每日登录游戏就可领", @"coinNum":@"2", @"imageName":@"daily_task_icon1", @"status":@"0", @"tip":@"去完成"},
        @{@"title":@"每日首充", @"desc":@"每日只要首充，即可获得奖励", @"coinNum":@"8", @"imageName":@"daily_task_icon2", @"status":@"0", @"tip":@"去完成"},
//        @{@"title":@"发布话题", @"desc":@"游戏圈子中发布优质话题，即可获取金币", @"coinNum":@"2", @"imageName":@"daily_task_icon5", @"status":@"0", @"tip":@"去发布"},
        @{@"title":@"微信朋友圈分享", @"desc":@"分享到朋友圈，结伴游戏更畅快", @"coinNum":@"2", @"imageName":@"daily_task_icon3", @"status":@"0", @"tip":@"去分享"},
        @{@"title":@"QQ空间分享", @"desc":@"分享到QQ空间即可获取金币", @"coinNum":@"2", @"imageName":@"daily_task_icon4", @"status":@"0", @"tip":@"去分享"}];
        
        _dataArray = [MyTaskCellModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataArray;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = MAIN_COLOR;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [self footerView];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyTaskFinishCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTaskFinishCell"];
    }
    return _tableView;
}

- (MyDailyTaskHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyDailyTaskHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 416.5 / 375.f)];
    }
    return _headerView;
}

- (UIView *)footerView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenH, 30)];
    view.backgroundColor = UIColor.clearColor;
    return view;
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
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = MAIN_COLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyTaskFinishCell";
    MyTaskFinishCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.contentView.backgroundColor = MAIN_COLOR;
    cell.taskModel = self.dataArray[indexPath.section];
    cell.receiveBtnBlock = ^(MyTaskCellModel * _Nonnull model) {
        [self getNoviceTaskProgress];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTaskCellModel * model = self.dataArray[indexPath.section];
    MyTaskFinishCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell pushToVc:model];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 20)
    {
        self.navBar.backgroundColor = MAIN_COLOR;
    }
    else
    {
        self.navBar.backgroundColor = UIColor.clearColor;
    }
}


@end
