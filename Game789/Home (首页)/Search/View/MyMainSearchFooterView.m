//
//  MyMainSearchFooterView.m
//  Game789
//
//  Created by Maiyou on 2020/12/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyMainSearchFooterView.h"
#import "MyHotSearchListCell.h"
#import "MyMainSearchSectionView.h"

@implementation MyMainSearchFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutUI];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    for (int i = 0; i < 2; i ++)
    {
        UITableView * tableView = [self viewWithTag:20 + i];
        [tableView reloadData];
    }
}

- (void)layoutUI
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 550)];
    scrollView.contentSize = CGSizeMake(230 * 2 + 30 + 10, scrollView.height);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    for (int i = 0; i < 2; i ++)
    {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(15 + (230 + 10) * i, 0, 230, scrollView.height) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate   = self;
        [tableView registerNib:[UINib nibWithNibName:@"MyHotSearchListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyHotSearchListCell"];
        tableView.layer.borderColor = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
        tableView.layer.borderWidth = 0.5;
        tableView.layer.cornerRadius = 4;
        tableView.layer.masksToBounds = YES;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tag = 20 + i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        [scrollView addSubview:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = nil;
    if (tableView.tag == 20)
    {
        array = self.dataDic[@"guess_youlike"];
    }
    else
    {
        array = self.dataDic[@"recommend_game_list"];
    }
    return array.count > 10 ? 10 : array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyMainSearchSectionView * sectionView = [[MyMainSearchSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    sectionView.showTitle.text = tableView.tag == 20 ? self.dataDic[@"title2"] : self.dataDic[@"title1"];
    sectionView.showTitle_left.constant = 10;
    sectionView.deleteBtn.hidden = YES;
    sectionView.showTitle_top.constant = 15;
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyHotSearchListCell";
    MyHotSearchListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.cellItem = indexPath.row;
    if (tableView.tag == 20)
    {
        cell.dataDic = self.dataDic[@"guess_youlike"][indexPath.row];
    }
    else
    {
        cell.dataDic = self.dataDic[@"recommend_game_list"][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = nil;
    if (tableView.tag == 20)
    {
        array = self.dataDic[@"guess_youlike"];
    }
    else
    {
        array = self.dataDic[@"recommend_game_list"];
    }
    NSDictionary * dic = array[indexPath.row];
    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.title  = dic[@"game_name"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    //埋点
    [MyAOPManager relateStatistic:tableView.tag == 20 ? @"ClickHotSeachGame" : @"ClickSupposeYouWantToSearch" Info:@{@"gameName":dic[@"game_name"], @"type":dic[@"tagsName"]}];
}

@end
