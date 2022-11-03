//
//  MyMoreTransactionView.m
//  Game789
//
//  Created by Maiyou on 2019/2/28.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyMoreTransactionView.h"
#import "TradingSearchGameController.h"
#import "ProductDetailsViewController.h"
#import "tradingViewCell.h"

@implementation MyMoreTransactionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyMoreTransactionView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, self.height - 46) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.gameName.text = self.dataDic[@"game_info"][@"game_name"];
    
    self.dataArray = [TradingListModel mj_objectArrayWithKeyValuesArray:self.dataDic[@"related_trades"]];
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataArray.count;
    if (count > 3)
    {
        return 3;
    }
    else
    {
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"tradingViewCell";
    tradingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"tradingViewCell" owner:self options:nil].firstObject;
    }
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TradingListModel * model = self.dataArray[indexPath.row];
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.currentVC.navigationController pushViewController:product animated:YES];
}

#pragma mark - 查看更多的该游戏交易
- (IBAction)viewMoreTransantionGame:(id)sender
{
    TradingSearchGameController * more = [TradingSearchGameController new];
    more.gameName = self.dataDic[@"game_info"][@"game_name"];
    [self.currentVC.navigationController pushViewController:more animated:YES];
}

@end
