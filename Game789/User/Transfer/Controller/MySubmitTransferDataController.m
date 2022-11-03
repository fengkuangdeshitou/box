//
//  MySubmitTransferDataController.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MySubmitTransferDataController.h"
#import "MySubmitTransferDataCell.h"
#import "MyCustomerServiceController.h"
#import "MyTransferDetailController.h"

#import "MySubmitTransferData.h"

#import "MyTransferListApi.h"
@class MySubmitTransferApi;

@interface MySubmitTransferDataController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *valueArray;

@property (nonatomic, strong) NSArray *roleList1;
@property (nonatomic, strong) NSArray *roleList2;
@property (nonatomic, strong) NSArray *timeList;

@property (nonatomic, strong) MySubmitTransferData *submitData;

@end

@implementation MySubmitTransferDataController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"申请转游".localized;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    self.submitData = [[MySubmitTransferData alloc] init];
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"转游说明".localized titleColor:FontColor99];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navBar setOnClickRightButton:^{
        WebViewController * coin = [WebViewController new];
        coin.urlString = TransferInstructionsUrl;
        [weakSelf.navigationController pushViewController:coin animated:YES];
    }];
    
    [self getData];
}

- (void)getData
{
    NSString * username = self.dataDic[@"username"];
    self.valueArray = [NSMutableArray arrayWithObjects:
                       @[username, @"", @"", @""],
                       @[self.dataDic[@"transfer_type_name"],
                         self.dataDic[@"game_name"],
                         username,
                         @"", @"", @"", @""], nil];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithObjects:
        @[@{@"title":@"申请账号".localized, @"type":@"0"},
          @{@"title":@"游戏名称".localized, @"type":@"1"},
          @{@"title":@"角色名".localized, @"type":@"1"},
          @{@"title":@"累计充值金额".localized, @"type":@"0"}],
          @[@{@"title":@"转游类型".localized, @"type":@"0"},
          @{@"title":@"转入游戏".localized, @"type":@"0"},
          @{@"title":@"账号".localized, @"type":@"0"},
          @{@"title":@"区服".localized, @"type":@"1"},
          @{@"title":@"角色名".localized, @"type":@"1"},
          @{@"title":@"充值日期".localized, @"type":@"1"},
          @{@"title":@"充值金额".localized, @"type":@"0"}], nil];
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        _tableView.separatorColor = FontColorDE;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = self.footerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MySubmitTransferDataCell" bundle:nil] forCellReuseIdentifier:@"MySubmitTransferDataCell"];
    }
    return _tableView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        _footerView.backgroundColor = UIColor.clearColor;
        
        CGFloat view_width = (kScreenW - 26.5 * 2 - 22.5) / 2;
        for (int i = 0; i < 2; i ++)
        {
            UIColor * bgColor = i == 0 ? ColorWhite : MAIN_COLOR;
            NSString * title = i == 0 ? @"联系客服" : @"提交申请";
            UIButton * button = [UIControl creatButtonWithFrame:CGRectMake(26.5 + (view_width + 22.5) * i, 45, view_width, 40) backgroundColor:bgColor title:title titleFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] actionBlock:^(UIControl *control) {
                UIButton * sender = (UIButton *)control;
                sender.tag == 10 ? [self contactServices] : [self submitReply];
            }];
            button.tag = i + 10;
            [button setTitleColor:i == 0 ? MAIN_COLOR : ColorWhite forState:0];
            button.layer.borderColor = MAIN_COLOR.CGColor;
            button.layer.borderWidth = 1;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = button.height / 2;
            [_footerView addSubview:button];
        }
    }
    return _footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return view;
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
    NSInteger type = [self.dataDic[@"transfer_type_id"] integerValue];
    if (type == 1 && indexPath.section == 1 && (indexPath.row == 5 || indexPath.row == 6))
    {
        return 0.001;
    }
    else if (type == 2 && indexPath.section == 1 && indexPath.row == 5)
    {
        return 0.001;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MySubmitTransferDataCell";
    MySubmitTransferDataCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.dataDic = self.dataArray[indexPath.section][indexPath.row];
    if ((indexPath.section == 0 && indexPath.row == 3) || (indexPath.section == 1 && indexPath.row == 6))
    {
        cell.showValue.textColor = [UIColor colorWithHexString:@"#FF5E00"];
        cell.showValue.text = [NSString stringWithFormat:@"%@元", self.valueArray[indexPath.section][indexPath.row]];
    }
    else
    {
        cell.showValue.textColor = [UIColor colorWithHexString:@"#282828"];
        cell.showValue.text = self.valueArray[indexPath.section][indexPath.row];
    }
    NSInteger type = [self.dataDic[@"transfer_type_id"] integerValue];
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
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)//选择游戏名称
        {
            [self selectReplyGame];
        }
        else if (indexPath.row == 2)//选择角色名
        {
            [self selectRole];
        }
    }
    else
    {
        if (indexPath.row == 3)//选择区服
        {
            [self selectZoneName];
        }
        else if (indexPath.row == 4)//选择角色名
        {
            [self selectZoneWithRole];
        }
        else if (indexPath.row == 5)//选择充值时间
        {
            [self selectRechargeTime];
        }
    }
}

#pragma mark ——— 选择充值时间
- (void)selectRechargeTime
{
    if (self.timeList.count > 0)
    {
        NSMutableArray * gameList = [NSMutableArray array];
        for (NSDictionary * dic in self.timeList)
        {
            [gameList addObject:dic[@"pay_date"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择充值时间" dataSource:gameList defaultSelValue:gameList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            
            NSDictionary * dic = self.timeList[index];
            self.submitData.into_pay_date = dic[@"pay_date"];
            self.submitData.into_pay_amount = dic[@"pay_amount"];
            
            [self replaceData:1 Row:5 Value:selectValue];
            [self replaceData:1 Row:6 Value:[NSString stringWithFormat:@"%@", self.timeList[index][@"pay_amount"]]];
        }];
    }
    else
    {
        [MBProgressHUD showToast:@"该角色暂无充值记录" toView:self.view];
    }
}

#pragma mark ——— 选择转入区服
- (void)selectZoneName
{
    NSArray * array = self.dataDic[@"transfer_into"][@"zone_list"];
    if (array.count > 0)
    {
        NSMutableArray * zoneList = [NSMutableArray array];
        for (NSDictionary * dic in array)
        {
            [zoneList addObject:dic[@"zone_name"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择区服" dataSource:zoneList defaultSelValue:zoneList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            NSDictionary * dic = array[index];
            if (self.submitData.into_zone_id.integerValue != [dic[@"zone_id"] integerValue])
            {
                self.submitData.into_role_id = @"";
                self.submitData.into_pay_date = @"";
                self.submitData.into_pay_amount = @"";
                [self replaceData:1 Row:4 Value:@""];
                [self replaceData:1 Row:5 Value:@""];
                [self replaceData:1 Row:6 Value:@""];
            }
            self.submitData.into_zone_id = dic[@"zone_id"];
            [self replaceData:1 Row:3 Value:selectValue];
            self.roleList2 = array[index][@"role_list"];
        }];
    }
    else
    {
        [MBProgressHUD showToast:@"暂无可选区服" toView:self.view];
    }
}

#pragma mark ——— 根据转入区服选择角色名
- (void)selectZoneWithRole
{
    if (self.roleList2.count > 0)
    {
        NSMutableArray * gameList = [NSMutableArray array];
        for (NSDictionary * dic in self.roleList2)
        {
            [gameList addObject:dic[@"role_name"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择角色名" dataSource:gameList defaultSelValue:gameList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            NSDictionary * dic = self.roleList2[index];
            self.submitData.into_role_id = dic[@"role_id"];
            
            [self replaceData:1 Row:4 Value:selectValue];
            
            NSInteger type = [self.dataDic[@"transfer_type_id"] integerValue];
            if (type == 2)//累充转游
            {
                NSDictionary * dic = self.roleList2[index];
                self.submitData.into_pay_amount = dic[@"pay_amount"];
                
                [self replaceData:1 Row:6 Value:dic[@"pay_amount"]];
            }
            else
            {
                self.timeList = self.roleList2[index][@"pay_list"];
            }
        }];
    }
    else
    {
        [MBProgressHUD showToast:@"暂无可转的角色" toView:self.view];
    }
}

#pragma mark ——— 选择游戏名称
- (void)selectReplyGame
{
    NSArray * array = self.dataDic[@"played_game_list"];
    if (array.count == 0)
    {
        [MBProgressHUD showToast:@"暂无可转的游戏" toView:self.view];
        return;
    }
    NSMutableArray * gameList = [NSMutableArray array];
    for (NSDictionary * dic in array)
    {
        [gameList addObject:dic[@"game_name"]];
    }
    [BRStringPickerView showStringPickerWithTitle:@"请选择游戏名称" dataSource:gameList defaultSelValue:gameList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
        NSDictionary * dic = array[index];
        if (self.submitData.gameid.integerValue != [dic[@"gameid"] integerValue])
        {
            self.submitData.role_id = @"";
            self.submitData.amount  = @"";
            [self replaceData:0 Row:2 Value:@""];
            [self replaceData:0 Row:3 Value:@""];
        }
        self.submitData.gameid = dic[@"gameid"];
        [self replaceData:0 Row:1 Value:selectValue];
        
        self.roleList1 = array[index][@"role_list"];
    }];
}

#pragma mark ——— 选择转出角色
- (void)selectRole
{
    if (self.roleList1.count > 0)
    {
        NSMutableArray * gameList = [NSMutableArray array];
        for (NSDictionary * dic in self.roleList1)
        {
            [gameList addObject:dic[@"role_name"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择角色名" dataSource:gameList defaultSelValue:gameList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
            NSDictionary * dic = self.roleList1[index];
            self.submitData.role_id = dic[@"role_id"];
            self.submitData.amount  = dic[@"pay_amount"];
            
            [self replaceData:0 Row:2 Value:selectValue];
            [self replaceData:0 Row:3 Value:[NSString stringWithFormat:@"%@", dic[@"pay_amount"]]];
        }];
    }
    else
    {
        [MBProgressHUD showToast:@"暂无可转的角色" toView:self.view];
    }
}

- (void)replaceData:(NSInteger)section Row:(NSInteger)row Value:(NSString *)value
{
    NSMutableArray * data = [NSMutableArray arrayWithArray:self.valueArray[section]];
    [data replaceObjectAtIndex:row withObject:value];
    [self.valueArray replaceObjectAtIndex:section withObject:data];
    [self.tableView reloadData];
}

#pragma mark ——— 联系客服
- (void)contactServices
{
    MyCustomerServiceController * services = [MyCustomerServiceController new];
    [self.navigationController pushViewController:services animated:YES];
}

#pragma mark ——— 提交申请
- (void)submitReply
{
    self.submitData.transfer_id = self.dataDic[@"id"];
    self.submitData.username    = self.dataDic[@"username"];
    
    NSString * transfer_type_id = self.dataDic[@"transfer_type_id"];
    self.submitData.transfer_type_id = self.dataDic[@"transfer_type_id"];
    self.submitData.into_gameid = self.dataDic[@"transfer_into"][@"gameid"];
    self.submitData.into_username = self.dataDic[@"transfer_into"][@"username"];
    
    if (!self.submitData.gameid)
    {
        [MBProgressHUD showToast:@"请选择游戏名称" toView:self.view];
        return;
    }
    if (!self.submitData.role_id)
    {
        [MBProgressHUD showToast:@"请选择角色名" toView:self.view];
        return;
    }
    if (!self.submitData.into_zone_id)
    {
        [MBProgressHUD showToast:@"请选择转入区服" toView:self.view];
        return;
    }
    if (!self.submitData.into_role_id)
    {
        [MBProgressHUD showToast:@"请选择转入角色名" toView:self.view];
        return;
    }
    if ([transfer_type_id integerValue] == 3 || [transfer_type_id integerValue] == 4)
    {
        if (!self.submitData.into_pay_date)
        {
            [MBProgressHUD showToast:@"请选择充值时间" toView:self.view];
            return;
        }
    }
    NSDictionary * dic = [[self.submitData mj_keyValues] deleteAllNullValue];
    MySubmitTransferApi * api = [[MySubmitTransferApi alloc] init];
    api.isShow = YES;
    api.dataDic = dic;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [MyAOPManager gameRelateStatistic:@"ClickToSubmitTransferGameRechargeApplication" GameInfo:self.dataDic Add:@{@"game_classify_name":self.dataDic[@"game_classify_type"]}];
            
            MyTransferDetailController * detail = [MyTransferDetailController new];
            detail.isSubmit = YES;
            detail.detail_id = request.data[@"id"];
            [self.navigationController pushViewController:detail animated:YES];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

@end
