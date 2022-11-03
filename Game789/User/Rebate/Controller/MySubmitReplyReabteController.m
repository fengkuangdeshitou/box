//
//  MySubmitReplyReabteController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySubmitReplyReabteController.h"
#import "MySubmitRebateListCell.h"
#import "MySubmitRebateFooterView.h"
#import "MySubmitRebateSuccessController.h"

#import "ReturnSubmitApi.h"
#import "ReturnReSubmitApi.h"
#import "MyGetAccountRoleApi.h"

@interface MySubmitReplyReabteController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * roleInfoArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger selectedServerIndex;
@property (nonatomic, strong) NSMutableDictionary * replyDic;

@end

@implementation MySubmitReplyReabteController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getRoleInfo];
}

- (void)prepareBasic
{
    self.navBar.title = @"申请返利";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.view addSubview:self.tableView];
    
    NSString * time = [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[self.detailDic[[self.detailDic[@"status"] integerValue] == -1 ? @"recharge_time" : @"last_recharge_time"] doubleValue]];
    
    NSString * money = [NSString stringWithFormat:@"%@元", _detailDic[[self.detailDic[@"status"] integerValue] == -1 ? @"recharge_amount" : @"can_rebate_amount"]];
    
    NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.detailDic[@"game_name"], userName, time, money, self.detailDic[@"server_name"], self.detailDic[@"role_name"], self.detailDic[@"role_id"], nil];
}

- (void)getRoleInfo
{
    MyGetAccountRoleApi * api = [[MyGetAccountRoleApi alloc] init];
    api.game_id = _detailDic[@"game_id"];
    api.userName = [YYToolModel getUserdefultforKey:@"user_name"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.roleInfoArray = request.data;
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [_tableView registerNib:[UINib nibWithNibName:@"MySubmitRebateListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MySubmitRebateListCell"];
    }
    return _tableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[@[@{@"icon":@"rebate_reply_icon1", @"title":@"申请游戏"},
                          @{@"icon":@"rebate_reply_icon2", @"title":@"申请账号"}],
                          @[@{@"icon":@"rebate_reply_icon3", @"title":@"充值时间"},
                          @{@"icon":@"rebate_reply_icon4", @"title":@"充值金额"}],
                          @[@{@"icon":@"rebate_reply_icon5", @"title":@"游戏区服"},
                          @{@"icon":@"rebate_reply_icon6", @"title":@"角色名"},
                          @{@"icon":@"rebate_reply_icon7", @"title":@"角色ID"}]];
    }
    return _titleArray;
}

- (UIView *)creatFooterView
{
    MySubmitRebateFooterView * footerView = [[MySubmitRebateFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 230)];
    footerView.submitRebateAction = ^(NSString * _Nonnull content) {
        [self submitRebateClick:content];
    };
    return footerView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MySubmitRebateListCell";
    MySubmitRebateListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.titleDic = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section < 2)
    {
        [cell.showDetail setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
        cell.dropIcon.hidden = YES;
        cell.showDetail_right.constant = 0;
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            [cell.showDetail setTitleColor:[UIColor colorWithHexString:@"#FF5E00"] forState:0];
        }
    }
    else
    {
        [cell.showDetail setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0];
        cell.dropIcon.hidden = NO;
        cell.showDetail_right.constant = 5;
    }
    if (indexPath.section == 0)
    {
        [cell.showDetail setTitle:self.dataArray[indexPath.row] forState:0];
    }
    else if (indexPath.section == 1)
    {
        [cell.showDetail setTitle:self.dataArray[indexPath.row + 2] forState:0];
    }
    else if (indexPath.section == 2)
    {
        [cell.showDetail setTitle:self.dataArray[indexPath.row + 4] forState:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld", (long)indexPath.row);
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        if (self.roleInfoArray.count == 0)
        {
            [MBProgressHUD showToast:@"暂无游戏区服" toView:self.view];
            return;
        }
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * dic in self.roleInfoArray)
        {
            [array addObject:dic[@"zonename"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择游戏区服" dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            MySubmitRebateListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.showDetail setTitle:selectValue forState:0];
            [self.dataArray replaceObjectAtIndex:indexPath.section * 2 + indexPath.row withObject:selectValue];
            self.selectedServerIndex = index;
        }];
    }
    else if (indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2))
    {
        NSString * server = self.dataArray[4];
        if ([server isEqualToString:@""])
        {
            [MBProgressHUD showToast:@"请选择游戏区服" toView:self.view];
            return;
        }
        NSInteger index = 0;
        NSArray * roleArray = @[];
        for (int i = 0; i < self.roleInfoArray.count; i ++)
        {
            NSDictionary * dic = self.roleInfoArray[i];
            if ([server isEqualToString:dic[@"zonename"]])
            {
                index = i;
                roleArray = dic[@"roinfo"];
                break;
            }
        }
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * dic in roleArray)
        {
            [array addObject:dic[@"rolename"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择角色" dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            
            NSDictionary * dic = roleArray[index];
            [self.dataArray replaceObjectAtIndex:indexPath.section * 2 + 1 withObject:dic[@"rolename"]];
            [self.dataArray replaceObjectAtIndex:indexPath.section * 2 + 2 withObject:dic[@"roleid"]];
            [self.tableView reloadData];
        }];
    }
}

- (void)submitRebateClick:(NSString *)content
{
    NSString * service = self.dataArray[4];
    NSString * roleName = self.dataArray[5];
    NSString * roleId = self.dataArray[6];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:self.detailDic];
    if (service.length == 0) {
        [MBProgressHUD showToast:@"区服不可为空" toView:self.view];
        return;
    }
    else
    {
        [dic setValue:service forKey:@"server_name"];
    }
    if (roleName.length == 0) {
        [MBProgressHUD showToast:@"角色名不可为空" toView:self.view];
        return;
    }
    else
    {
        [dic setValue:roleName forKey:@"role_name"];
    }
    if (roleId.length == 0) {
        [MBProgressHUD showToast:@"角色ID不可为空" toView:self.view];
        return;
    }
    else
    {
        [dic setValue:roleId forKey:@"role_id"];
    }
    if (content.length > 0) {
        /// 备注
        [dic setValue:content forKey:@"remark"];
    }
    
    if ([self.detailDic[@"status"] integerValue] == -1)
    {
        [self listDetailReSubmitRequest:dic];
    }
    else
    {
        [self listDetailRequest:dic];
    }
}

#pragma mark — 提交
- (void)listDetailRequest:(NSDictionary *)dic {

    ReturnSubmitApi *api = [[ReturnSubmitApi alloc] init];
    api.valueDic = dic;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleListSuccess:(ReturnSubmitApi *)api
{
    if (api.success == 1) {
        NSLog(@"info data = %@",api.data);
        //记录返利提交成功事件
        [MyAOPManager relateStatistic:@"SubmitRebates" Info:@{}];
        MySubmitRebateSuccessController *detailVC = [[MySubmitRebateSuccessController alloc] init];
        detailVC.detailDic = self.detailDic;
        detailVC.rebate_id = api.data[@"rebate"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}
#pragma mark — 重新提交
- (void)listDetailReSubmitRequest:(NSDictionary *)dic {

    self.replyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    ReturnReSubmitApi *api = [[ReturnReSubmitApi alloc] init];
    api.isShow = YES;
    api.valueDic = dic;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListDetailReSubmitSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleListDetailReSubmitSuccess:(ReturnReSubmitApi *)api
{
    if (api.success == 1)
    {
        NSLog(@"info data = %@", api.data);
        //记录返利提交成功事件
        [MyAOPManager relateStatistic:@"SubmitRebates" Info:@{}];
        
        [self.replyDic setValue:self.detailDic[@"game_name"] forKey:@"game_name"];
        MySubmitRebateSuccessController *detailVC = [[MySubmitRebateSuccessController alloc] init];
        detailVC.detailDic = self.replyDic;
        detailVC.rebate_id = api.data[@"rebate"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
