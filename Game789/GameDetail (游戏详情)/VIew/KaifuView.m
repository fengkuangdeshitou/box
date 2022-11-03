//
//  KaifuView.m
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "KaifuView.h"
#import "KaifuCell.h"
#import "HGLoadDataFooterView.h"

@implementation KaifuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setKaifuArray:(NSArray *)kaifuArray
{
    _kaifuArray = kaifuArray;
    
//    if (kaifuArray.count > 3)
//    {
//        self.tableView.tableFooterView = [self creatFooterView];
//    }
    [self.tableView reloadData];
}

- (UIView *)creatFooterView
{
    HGLoadDataFooterView * footerView = [[HGLoadDataFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 66)];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.showText.text = @"别撩啦！已经到底啦^_−☆";
    return footerView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～暂无开服数据" detailStr:@""];
        _tableView.ly_emptyView.contentViewY = 50;
        [self addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenW, 25)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"注：仅供参考，以游戏内开服为准！";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#99A6A0"];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kaifuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    KaifuCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"KaifuCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.remindButton.tag = indexPath.row;
    cell.kaifuDic = self.kaifuArray[indexPath.row];
    cell.game_info = self.game_info;
    return cell;
}

@end
