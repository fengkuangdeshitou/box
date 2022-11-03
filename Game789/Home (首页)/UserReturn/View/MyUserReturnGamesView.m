//
//  MyUserReturnGamesView.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnGamesView.h"

@interface MyUserReturnGamesView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *indexPaths;

@end

@implementation MyUserReturnGamesView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyUserReturnGamesView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 74;
        [self.tableView registerNib:[UINib nibWithNibName:@"MyUserReturnGameInfoCell" bundle:nil] forCellReuseIdentifier:@"MyUserReturnGameInfoCell"];
    }
    return self;
}

- (NSMutableArray *)indexPaths
{
    if (!_indexPaths)
    {
        _indexPaths = [[NSMutableArray alloc] init];
    }
    return _indexPaths;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

- (void)setNewExclusive:(BOOL)newExclusive{
    _newExclusive = newExclusive;
    if (newExclusive) {
        self.nameLabel.text = @"648充值";
        self.descHeight.constant = 0;
        self.imageContentHeight.constant = 0;
        self.imageContentTop.constant = 0;
        self.imageContentBottom.constant = 0;
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyUserReturnGameInfoCell";
    MyUserReturnGameInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.gamesModel = self.dataArray[indexPath.section];
    cell.selectedStatus.selected = [self.indexPaths containsObject:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyUserReturnGamesModel * gamesModel = self.dataArray[indexPath.section];
    if (![gamesModel.is_received boolValue])
    {
        if (![self.indexPaths containsObject:indexPath])
        {
            MyUserReturnGameInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectedStatus.selected = YES;
            
            [self.indexPaths addObject:indexPath];
        }
        else
        {
            MyUserReturnGameInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectedStatus.selected = NO;
            
            [self.indexPaths removeObject:indexPath];
        }
    }
}

- (IBAction)receivedBtnClick:(id)sender
{
    if (self.indexPaths.count == 0)
    {
        [MBProgressHUD showToast:@"请选择要领取的游戏礼包！" toView:self];
        return;
    }
    NSMutableArray * array = [NSMutableArray array];
    for (NSIndexPath * indexPath in self.indexPaths)
    {
        MyUserReturnGamesModel * gamesModel = self.dataArray[indexPath.section];
        [array addObject:gamesModel.packid];
    }
    NSString * pack_ids = [array componentsJoinedByString:@","];
    
    if (self.receivedSuccess) {
        self.receivedSuccess(pack_ids);
    }
}

@end
