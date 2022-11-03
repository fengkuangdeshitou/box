//
//  MyGameDownLoadView.m
//  Game789
//
//  Created by Maiyou on 2019/1/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGameDownLoadView.h"
#import "DownLoadManageCell.h"

@implementation MyGameDownLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.tableView];
        self.frame = frame;
        
        //当没有分包下载时,监控分包状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDownLoadData) name:@"StartDownloadIpa" object:nil];
    }
    return self;
}

- (void)reloadDownLoadData
{
    self.cacheDataList = [NSMutableArray array];
    [self.cacheDataList addObjectsFromArray:[YCDownloadManager downloadList]];
    [self.cacheDataList addObjectsFromArray:[YCDownloadManager finishList]];
    [self.tableView reloadData];
    self.tableView.ly_emptyView.contentView.hidden = NO;
}

#pragma mark - 懒加载
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray)
    {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"download_no_data" titleStr:@"暂未下载任何游戏" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cacheDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"DownLoadManageCell";
    DownLoadManageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DownLoadManageCell" owner:self options:nil].firstObject;
    }
    cell.isEdit = self.isEdit;
    cell.deleteButton.tag = indexPath.row;
    cell.item = self.cacheDataList[indexPath.row];
    cell.downLoadStatusChanged = ^(YCDownloadStatus downloadStatus) {
        if (downloadStatus == YCDownloadStatusFinished) {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView reloadData];
    };
    cell.deleteLoadData = ^(NSInteger index) {
        [self deleteDataWithIndex:index];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectedArray containsObject:self.cacheDataList[indexPath.row]] && self.isEdit)
    {
        [self.selectedArray addObject:self.cacheDataList[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedArray containsObject:self.cacheDataList[indexPath.row]]  && self.isEdit)
    {
        [self.selectedArray removeObject:self.cacheDataList[indexPath.row]];
    }
}

- (void)deleteDataWithIndex:(NSInteger)index
{
    [self.currentVC jxt_showAlertWithTitle:@"提示" message:@"删除任务将同时删除已下载的本地文件，确定删除吗?" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [YCDownloadManager stopDownloadWithItem:self.cacheDataList[index]];
            [self.cacheDataList removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}


@end
