//
//  MyGameGiftListView.m
//  Game789
//
//  Created by Maiyou001 on 2022/5/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyGameGiftListView.h"
#import "HGShowGameGiftCell.h"
#import "MyGameGiftDetailController.h"

@interface MyGameGiftListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyGameGiftListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = BackColor;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"HGShowGameGiftCell" bundle:nil] forCellReuseIdentifier:@"HGShowGameGiftCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGiftSuccess:) name:@"receiveGiftSuccess" object:nil];
    }
    return self;
}

- (void)receiveGiftSuccess:(NSNotification *)notification{
    NSString * giftId = notification.object;
    for (int i=0;i<self.dataArray.count;i++) {
        NSDictionary * item = self.dataArray[i];
        if ([giftId isEqualToString:item[@"packid"]]) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:item];
            dict[@"is_received"] = @"1";
            [self.dataArray replaceObjectAtIndex:i withObject:dict];
            [self.tableView reloadData];
        }
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.ly_emptyView.contentView.hidden = NO;
    });
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"rebate_no_data" titleStr:@"暂无可用礼包~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    static NSString *reuseID = @"HGShowGameGiftCell";
    HGShowGameGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = self.dataArray[indexPath.row];
    cell.receiveGiftAction = ^(NSString * _Nonnull giftId) {
        if (weakSelf.receivedSuccessblock) {
            weakSelf.receivedSuccessblock();
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
    
    WEAKSELF
    MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
    detail.isReceived = ![dic[@"is_received"] boolValue];
    detail.gift_id = dic[@"packid"];
    detail.vc = YYToolModel.getCurrentVC;
    detail.receivedGiftCodeBlock = ^{
        if (weakSelf.receivedSuccessblock) {
            weakSelf.receivedSuccessblock();
        }
    };
    [YYToolModel.getCurrentVC.navigationController presentViewController:detail animated:YES completion:nil];
}

@end
