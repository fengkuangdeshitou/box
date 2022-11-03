//
//  MyAchievementTaskController.m
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyAchievementTaskController.h"

#import "MyTaskFinishCell.h"

#import "MyTaskCenterApi.h"
@class MyGetTaskProgressApi;

@interface MyAchievementTaskController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) UIImageView * bgview;
@property (strong, nonatomic) UIImageView * bgview2;

@end

@implementation MyAchievementTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"福利任务";
    self.navBar.backgroundColor = UIColor.whiteColor;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back")];
    self.navBar.lineView.hidden = YES;
    
    self.tableViewTop.constant = kStatusBarAndNavigationBarHeight;
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskFinishCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTaskFinishCell"];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, 335)];
    self.bgview.contentMode = UIViewContentModeScaleAspectFill;
    self.bgview.image = [UIImage imageNamed:@"chengjiu_bg1"];
    [self.view insertSubview:self.bgview atIndex:0];
    self.bgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+335, ScreenWidth, 508)];
    self.bgview2.contentMode = UIViewContentModeScaleAspectFill;
    self.bgview2.image = [UIImage imageNamed:@"chengjiu_bg2"];
    [self.view insertSubview:self.bgview2 atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNoviceTaskProgress];
}

- (void)getNoviceTaskProgress
{
    WelfareDataAPI * api = [[WelfareDataAPI alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
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
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray * array = request.data;
    for (int i = 0; i < array.count; i ++)
    {
        NSDictionary * item = array[i];
        MyTaskCellModel * model = [[MyTaskCellModel alloc] init];
        model.source = 1;
        model.title = item[@"title"];
        model.desc = item[@"remark"];
        model.coinNum = item[@"rewardDesc"];
        model.balance = item[@"amount"];
        model.imageName = item[@"icon"];
        model.status = [item[@"isCompleted"] boolValue];
        model.tips = item[@"tips"];
        model.type = item[@"name"];
        model.taked = [item[@"isReceivedReward"] boolValue];
        model.btnTitle = item[@"btnTitle"];
        model.total = item[@"total"];
        model.progess = item[@"completedTotal"];
        model.alertMsg = item[@"alertMsg"];
        model.eventType = item[@"eventType"];
        [self.dataArray addObject:model];
    }

//    NSDictionary * dic = request.data[@"task_info"];
//    for (int i = 0; i < self.dataArray.count; i ++)
//    {
//        MyTaskCellModel * model = self.dataArray[i];
//        NSString * str = @"";
//        switch (i) {
//            case 0:
//                str = @"CumulativeSignIn";
//                break;
//            case 1:
//                str = @"goodCommentNew";
//                break;
//            case 2:
//                str = @"Recharge100";
//                break;
//            case 3:
//                str = @"Recharge1000";
//                break;
//
//            default:
//                break;
//        }
//        model.balance = [NSString stringWithFormat:@"%@", dic[str][@"balance"]];
//        model.progess = [NSString stringWithFormat:@"%@", dic[str][@"success_num"]];
//        model.type = str;
//        model.status = [dic[str][@"completed"] boolValue];
//        model.taked  = [dic[str][@"taked"] boolValue];
//    }
    [self.tableView reloadData];
}

//- (NSArray *)dataArray
//{
//    if (!_dataArray)
//    {
//        NSArray * array = @[@{@"title":@"累计签到", @"desc":@"累计签到58次即可获得100金币奖励", @"coinNum":@"100", @"imageName":@"achi_task_icon1", @"status":@"0", @"total":@"58", @"progess":@"0", @"tip":@"去完成"},
//        @{@"title":@"优质评价", @"desc":@"优质评价让你金币拿到手软", @"coinNum":@"30", @"imageName":@"achi_task_icon2", @"status":@"0", @"total":@"3", @"progess":@"0", @"tip":@"去完成"},
//        @{@"title":@"充值满100元", @"desc":@"累计充值100元，即可获得奖励", @"coinNum":@"50", @"imageName":@"achi_task_icon3", @"status":@"0", @"tip":@"去完成", @"total":@"100"},
//        @{@"title":@"充值满1000元", @"desc":@"累计充值1000元，即可获得奖励", @"coinNum":@"666", @"imageName":@"achi_task_icon4", @"status":@"0", @"tip":@"去完成", @"total":@"1000"}];
//
//        _dataArray = [MyTaskCellModel mj_objectArrayWithKeyValuesArray:array];
//    }
//    return _dataArray;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 270 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyTaskFinishCell";
    MyTaskFinishCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.taskModel = self.dataArray[indexPath.section];
    cell.receiveBtnBlock = ^(MyTaskCellModel * _Nonnull model) {
        [self getNoviceTaskProgress];
    };
    cell.shadowView.layer.shadowOffset = CGSizeMake(0,0);
    cell.shadowView.layer.shadowOpacity = 1;
    cell.shadowView.layer.shadowRadius = 14;
    cell.shadowView.layer.cornerRadius = 13;
    cell.shadowView.layer.shadowColor = [UIColor colorWithRed:253/255.0 green:198/255.0 blue:151/255.0 alpha:0.96].CGColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTaskCellModel * model = self.dataArray[indexPath.section];
    MyTaskFinishCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell pushToVc:model];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.bgview.y = -scrollView.contentOffset.y+kStatusBarAndNavigationBarHeight;
    self.bgview2.y = -scrollView.contentOffset.y+kStatusBarAndNavigationBarHeight+335;
}

@end
