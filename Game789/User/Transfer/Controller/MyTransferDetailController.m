//
//  MyTransferDetailController.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferDetailController.h"
#import "MyTransferViewController.h"

#import "MyTransferDetailHeaderView.h"

#import "MyTransferListApi.h"
@class MyTransferDetailApi;

@interface MyTransferDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) MyTransferDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *valueArray;

@property (nonatomic, copy) NSString *transfer_type_id;

@end

@implementation MyTransferDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"提交成功";
    WEAKSELF
    [self.navBar setOnClickLeftButton:^{
        [weakSelf popToHome];
    }];
    
    [self getData];
}

- (void)getData
{
    MyTransferDetailApi * api = [[MyTransferDetailApi alloc] init];
    api.isShow = YES;
    api.detail_id = self.detail_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary * dic = [request.data deleteAllNullValue];
            self.transfer_type_id = dic[@"transfer_type_id"];
            self.valueArray = @[@[dic[@"username"], dic[@"game_name"], dic[@"role_name"], dic[@"pay_amount"]],
            @[dic[@"transfer_type_name"], dic[@"into_game_name"], dic[@"into_username"], dic[@"into_zone_name"], dic[@"into_role_name"], dic[@"into_pay_date"], dic[@"into_pay_amount"], dic[@"check_msg"]]];
            NSString * imagename = [NSString stringWithFormat:@"submit_transfer_status%@", dic[@"check_status"]];
            self.headerView.imageView.image = MYGetImage(imagename);
            self.headerView.showStatus.text = [self getCheckStatus:[dic[@"check_status"] integerValue]];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (NSString *)getCheckStatus:(NSInteger)status
{
    NSString * str = @"";
    switch (status) {
        case 1:
            str = @"审核中";
            break;
        case 2:
            str = @"审核通过";
            break;
        case 3:
            str = @"已驳回";
            break;
        case 4:
            str = @"已完成";
            break;
        default:
            break;
    }
    return str;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithObjects:
        @[@"申请账号", @"游戏名称", @"角色名", @"累计充值金额"],
        @[@"转游类型", @"转入游戏", @"账号", @"区服", @"角色名", @"充值日期", @"充值金额", @"备注"], nil];
    }
    return _dataArray;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (MyTransferDetailHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyTransferDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        _footerView.backgroundColor = UIColor.clearColor;
        
        
        UIColor * bgColor = MAIN_COLOR;
        NSString * title = @"返回首页";
        UIButton * button = [UIControl creatButtonWithFrame:CGRectMake(26.5, 45, kScreenW - 26.5 * 2, 44) backgroundColor:bgColor title:title titleFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] actionBlock:^(UIControl *control) {
            [self popToHome];
        }];
        [button setTitleColor:ColorWhite forState:0];
        button.layer.borderColor = MAIN_COLOR.CGColor;
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.height / 2;
        [_footerView addSubview:button];
        
    }
    return _footerView;
}

- (void)popToHome
{
    if (self.isSubmit)
    {
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MyTransferViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 0 ? 11 : 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 11)];
    view.backgroundColor = ColorWhite;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kScreenW - 30, 1)];
    imageView.image = MYGetImage(@"rebate_detail_dottedline");
    [view addSubview:imageView];
    
    return section == 0 ? view : [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = self.transfer_type_id.integerValue;
    if (type == 1 && indexPath.section == 1 && (indexPath.row == 5 || indexPath.row == 6))
    {
        return 0.001;
    }
    else if (type == 2 && indexPath.section == 1 && indexPath.row == 5)
    {
        return 0.001;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"dataCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = FontColor99;
    
    cell.detailTextLabel.text = self.valueArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = FontColor28;
    if ((indexPath.section == 0 && indexPath.row == 3) || (indexPath.section == 1 && indexPath.row == 6)) {
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#FF5E00"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@元", self.valueArray[indexPath.section][indexPath.row]];
    }
    
    NSInteger type = self.transfer_type_id.integerValue;
    if (type == 1 && indexPath.section == 1 && (indexPath.row == 5 || indexPath.row == 6))
    {
        cell.hidden = YES;
    }
    else if (type == 2 && indexPath.section == 1 && indexPath.row == 5)
    {
        cell.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
