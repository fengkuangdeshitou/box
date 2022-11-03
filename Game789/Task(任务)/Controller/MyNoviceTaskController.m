//
//  MyNoviceTaskController.m
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNoviceTaskController.h"

#import "MyTaskFinishCell.h"

#import "MyTaskCenterApi.h"
@class MyGetTaskProgressApi;

@interface MyNoviceTaskController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIImageView *bgview;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation MyNoviceTaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar.title = @"新手任务";
    self.navBar.backgroundColor = UIColor.whiteColor;
    self.tableViewTop.constant = kStatusBarAndNavigationBarHeight;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back")];
    self.navBar.lineView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#C0ECFF"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyTaskFinishCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTaskFinishCell"];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, 812)];
    self.bgview.contentMode = UIViewContentModeScaleAspectFill;
    self.bgview.image = [UIImage imageNamed:@"everyday_bg"];
    [self.view insertSubview:self.bgview atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNoviceTaskProgress];
}

- (void)getNoviceTaskProgress
{
    NoviceDataAPI * api = [[NoviceDataAPI alloc] init];
    api.isShow = true;
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
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray * array = request.data;
    for (int i = 0; i < array.count; i ++)
    {
        NSDictionary * item = array[i];
        MyTaskCellModel * model = [[MyTaskCellModel alloc] init];
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
        model.alertMsg = item[@"alertMsg"];
        model.eventType = item[@"eventType"];
        [self.dataArray addObject:model];
    }
//    if (dic[@"douyin"]) {
//        [NSUserDefaults.standardUserDefaults setValue:dic[@"douyin"][@"tips"] forKey:@"douyin-tips"];
//    }else{
//        [NSUserDefaults.standardUserDefaults removeObjectForKey:@"douyin-tips"];
//    }
    
    [self.tableView reloadData];
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
//    MyTaskCellModel *taskModel = self.dataArray[indexPath.section];
//    if (([taskModel.type isEqualToString:@"weixin"] || [taskModel.type isEqualToString:@"douyin"]) && [taskModel.tips isBlankString])
//    {
//        return 0.001;
//    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 220 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyTaskFinishCell";
    MyTaskFinishCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.taskModel = self.dataArray[indexPath.section];
    cell.is_ua8x = self.is_ua8x;
    cell.receiveBtnBlock = ^(MyTaskCellModel * _Nonnull model) {
        [self getNoviceTaskProgress];
    };
    cell.showTitle.textColor = [UIColor colorWithHexString:@"#4B69CA"];
    cell.showDesc.textColor = [UIColor colorWithHexString:@"#4B69CA"];
    cell.showCoinNum.textColor = [UIColor colorWithHexString:@"#4B69CA"];
    cell.shadowView.layer.shadowOffset = CGSizeMake(0,0);
    cell.shadowView.layer.shadowOpacity = 1;
    cell.shadowView.layer.shadowRadius = 14;
    cell.shadowView.layer.cornerRadius = 13;
    cell.shadowView.layer.shadowColor = [UIColor colorWithRed:101/255.0 green:179/255.0 blue:227/255.0 alpha:0.96].CGColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTaskCellModel * model = self.dataArray[indexPath.section];
    MyTaskFinishCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.receiveBtnBlock = ^(MyTaskCellModel * _Nonnull model) {
        [self getNoviceTaskProgress];
    };
    [cell pushToVc:model];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.bgview.y = -scrollView.contentOffset.y+kStatusBarAndNavigationBarHeight;
}

@end
