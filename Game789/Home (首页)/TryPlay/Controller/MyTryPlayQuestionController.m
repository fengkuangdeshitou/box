//
//  MyTryPlayQuestionController.m
//  Game789
//
//  Created by Maiyou on 2021/1/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTryPlayQuestionController.h"

@interface MyTryPlayQuestionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MyTryPlayQuestionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"下载试玩赚金币答疑";
    self.view.backgroundColor = ColorWhite;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 懒加载
- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[
        @{@"question":@"怎么通过试玩游戏赚金币？", @"answer":@"1、首先领取任务，数量有限，先抢先得\n2、然后下载游戏，按照要求在任务有效期内创建角色或者达到指定等级\n3、返回试玩任务页面领取金币"},
        @{@"question":@"任务完成了，为什么没有获得金币？", @"answer":@"1、任务需要领取后才可完成，未领取状态下试玩游戏，无法获得金币\n2、完成任务不能领金币也可能是系统延时，刷新页面或退出重新登录游戏即可领取\n3、在指定时间内完成任务即可领取，任务结束仍未完成，不能领取金币"},
        @{@"question":@"领任务有限制么？每天可领取多少个?", @"answer":@"1、每人每天可领取的任务无上限，重要的是手要快\n2、同个游戏，同个设备每个账号只能领取一次"},
        @{@"question":@"重要提示", @"answer":@"1、一旦发现使用非正常手段刷金币，将永久封号并收回所得\n2、如有问题请进入客服页面联系官方客服"}];
    }
    return _dataArray;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ColorWhite;
    }
    return _tableView;
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
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    label.text = self.dataArray[section][@"question"];
    label.textColor = [UIColor colorWithHexString:@"#562DB7"];
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = ColorWhite;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"cell1";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = ColorWhite;
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = 5;
    NSDictionary * attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,
                               NSKernAttributeName:@(0),
                                 NSForegroundColorAttributeName:FontColor66,
                                 NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:self.dataArray[indexPath.section][@"answer"] attributes:attriDict];
    cell.textLabel.attributedText = attributedString;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
