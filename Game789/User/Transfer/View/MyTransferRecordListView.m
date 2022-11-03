//
//  MyTransferRecordListView.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferRecordListView.h"
#import "MyTransferDetailController.h"

#import "MyReplyRebateRecordCell.h"

#import "MyTransferListApi.h"
@class MyTransferRecordApi;
@class MyTransferDeleteRecordApi;

@implementation MyTransferRecordListView

- (void)setIsLoaded:(BOOL)isLoaded
{
    _isLoaded = isLoaded;
    if (_isLoaded)
    {
        [self loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header beginRefreshing];
        });
    }
}

- (void)getVoucherList:(RequestData)block
{
    MyTransferRecordApi * api = [[MyTransferRecordApi alloc] init];
    api.status = [NSString stringWithFormat:@"%ld", self.index > 1 ? self.index + 1 : self.index];
    api.pageNumber = self.pageNumber;
    api.count = 10;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (api.success == 1) {
            NSMutableArray * array = api.data[@"list"];
            if (self.pageNumber == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.dataArray addObjectsFromArray:array];
            }
            NSDictionary *dic = api.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            UIView * view = [self.currentVC creatFooterView];
            view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:view];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
        } else {
            [MBProgressHUD showToast:api.error_desc toView:self.currentVC.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"voucher_no_data" titleStr:[self noDataStr] detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"MyReplyRebateRecordCell" bundle:nil] forCellReuseIdentifier:@"MyReplyRebateRecordCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (NSString *)noDataStr
{
    if (self.index == 0)
    {
        return @"暂无转游记录";
    }
    else if (self.index == 1)
    {
        return @"暂无待审核记录";
    }
    else if (self.index == 2)
    {
        return @"暂无已驳回记录";
    }
    else
    {
        return @"暂无已完成记录";
    }
}

#pragma mark TableView代理方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1)
    {
        return YES;
    }
    return NO;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (self.index == 1)
        {
            [[YYToolModel getCurrentVC] jxt_showAlertWithTitle:@"确定要撤销该记录吗？" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1)
                {
                    NSString * str = self.dataArray[indexPath.section][@"id"];
                    MyTransferDeleteRecordApi * api = [[MyTransferDeleteRecordApi alloc] init];
                    api.detail_id = str;
                    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {

                        if (request.success == 1)
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataTradeStatus" object:nil];

                            [MBProgressHUD showToast:@"撤销成功"];
                            [self.dataArray removeObjectAtIndex:indexPath.row];
                            [tableView reloadData];
                        }
                        else
                        {
                            [MBProgressHUD showToast:request.error_desc];
                        }

                    } failureBlock:^(BaseRequest * _Nonnull request) {

                    }];
                }
            }];
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"撤销";
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyReplyRebateRecordCell";
    MyReplyRebateRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.transferDic = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    MyTransferDetailController * detail = [MyTransferDetailController new];
    detail.detail_id = self.dataArray[indexPath.section][@"id"];
    [self.currentVC.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance && !self.isLoading && self.hasNextPage) {
        self.isLoading = YES;
        [self.tableView.mj_footer beginRefreshing];
    } else {
        if (self.isLoading) {
            self.isLoading = NO;
        }
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getVoucherList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getVoucherList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        }];
    }];
}

@end
