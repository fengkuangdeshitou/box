//
//  MyTadayOpenServiceController.m
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTadayOpenServiceController.h"

#import "MyOpenServiceSectionView.h"
#import "MyOpenServiceHeaderView.h"

#import "KaiFuApiList.h"

@interface MyTadayOpenServiceController () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _isScrollDown;
}
@property (nonatomic, strong) MyOpenServiceHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString * selectedDate;
@property (nonatomic, assign) BOOL isScroll;

@end

@implementation MyTadayOpenServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    //默认选择的时间为空，表示当前列表数据为明天的开服数据
    self.selectedDate = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
//    [self kaiFuApiRequest];
}

#pragma mark - 获取数据
- (void)kaiFuApiRequest:(RequestData)block Hud:(BOOL)isShow
{
    KaiFuApiList *api = [[KaiFuApiList alloc] init];
    api.mainType = self.type;
    api.kf_start_time = @"";
    api.kaifu_date = self.selectedDate;
    api.count = self.type.intValue == 30 ? 10 : 1000;
    api.game_classify_id = self.game_classify_id;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(KaiFuApiList *)api
{
    if (api.success == 1)
    {
        NSArray * array = api.data[@"kaifu_list"];
        if (self.pageNumber == 1)
        {
            self.dataArray = [NSMutableArray arrayWithArray:array];
        }
        else
        {
            [self.dataArray addObjectsFromArray:array];
        }
        if (self.type.intValue != 30)
        {
            self.dataArray = [self groupArray:self.dataArray];
        }
        if (self.type.intValue == 10)
        {
            self.headerView.dataArray = self.dataArray;
        }
        else if (self.type.intValue == 20)
        {
            self.headerView.dateArray = api.data[@"kaifu_date_list"];
        }
        [self.tableView reloadData];
        self.tableView.ly_emptyView.contentView.hidden = NO;
        
        if (self.type.intValue == 10)
        {
            [self scrollToCurrentTime];
        }
        
        NSDictionary *pageDic = api.data[@"paginated"];
        self.hasNextPage = [pageDic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:pageDic FooterView:[self creatFooterView]];
    }
    else {
        [MBProgressHUD showToast:api.error_desc];
    }
}

/**  滚动到当前时间  */
- (void)scrollToCurrentTime
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isScroll)
        {
            NSString * currentTime = [NSDate getNowTimeTimestamp];
            for (NSInteger i = 0; i < self.dataArray.count; i ++)
            {
                if (i < self.dataArray.count - 1)
                {
                    NSString *timestamp = self.dataArray[i][0][@"kaifu_start_date"];
                    NSString *timestamp1 = self.dataArray[i + 1][0][@"kaifu_start_date"];
                    if (currentTime.floatValue > timestamp.floatValue && currentTime.floatValue < timestamp1.floatValue)
                    {
                        //时间的滚动
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
                        [self.headerView.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                        self.headerView.selectedTimeIndex = i + 1;
                        [self.headerView.collectionView reloadData];
                        
                        [self scrollToCollectionView:i + 1];
                        [self selectRowAtIndexPath:i + 1];
                        break;
                    }
                }
            }
        }
    });
}

- (void)scrollToCollectionView:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -- private method 原始数据分组
-(NSMutableArray<NSMutableArray *> *)groupArray:(NSMutableArray<NSDictionary *> *)needSortArray{
    NSMutableArray<NSMutableArray *> *result = [NSMutableArray new];
    if(needSortArray.count == 0){
        return result;
    }
    NSString *lastTimeStamp;
    NSMutableArray *itemArray;
    for (NSDictionary *dicitem in needSortArray) {
        NSString *timestamp = [dicitem valueForKey:@"kaifu_start_date"];
        if(lastTimeStamp == nil){
            lastTimeStamp = timestamp;
            itemArray = [NSMutableArray new];
            [result addObject:itemArray];
        }
        if([lastTimeStamp isEqualToString:timestamp]){
            [itemArray addObject:dicitem];
        }
        else{
            itemArray = [NSMutableArray new];
            [itemArray addObject:dicitem];
            [result addObject:itemArray];
        }
        lastTimeStamp = timestamp;
    }
    return result;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat viewTop = self.type.intValue == 30 ? 0 : 50;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTop, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - 44 - viewTop) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BackColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameTableViewCell"];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    _tableView.backgroundColor = BackColor;
    return _tableView;
}

- (MyOpenServiceHeaderView *)headerView
{
    if (!_headerView)
    {
        WEAKSELF
        _headerView = [[MyOpenServiceHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        _headerView.type = self.type;
        _headerView.collectionSelectedIndex = ^(NSInteger index, NSString * _Nonnull date) {
            if (weakSelf.type.intValue == 20)
            {
                weakSelf.selectedDate = date;
                [weakSelf kaiFuApiRequest:nil Hud:YES];
            }
            else
            {
                [weakSelf scrollToCollectionView:index];
            }
        };
        [self.view addSubview:self.headerView];
    }
    return _headerView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.type.intValue == 30 ? 1 : self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.type.intValue == 30 ? self.dataArray.count : [self.dataArray[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.type.intValue == 30)
    {
        return [UIView new];
    }
    else
    {
        MyOpenServiceSectionView * sectionView = [[MyOpenServiceSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        NSString * time = [NSDate dateWithFormat:@"HH:mm" WithTS:[self.dataArray[section][0][@"kaifu_start_date"] doubleValue]];
        sectionView.showTime.text = time;
        return sectionView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.type.intValue == 30 ? 0.001 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.type.intValue == 30 ? 120 : 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"GameTableViewCell";
    GameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.kaifuType = self.type;
    if (self.type.intValue == 30)
    {
        cell.radiusView.layer.cornerRadius = 13;
        cell.radiusView_top.constant = 10;
        [cell setModelDic:self.dataArray[indexPath.row]];
    }
    else
    {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSArray * rowsArray = self.dataArray[section];
        if (row == 0)
        {
            if (row == rowsArray.count - 1)
            {
                [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight radius:0 view:cell.radiusView];
            }
            else
            {
                [YYToolModel clipRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:13 view:cell.radiusView];
            }
        }
        else if (row == rowsArray.count - 1)
        {
            [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:13 view:cell.radiusView];
        }
        else
        {
            [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight radius:0 view:cell.radiusView];
        }
        [cell setModelDic:rowsArray[row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.type.intValue == 30 ? self.dataArray[indexPath.row] : self.dataArray[indexPath.section][indexPath.row];
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = dic[@"game_id"];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前 tableView 滚动的方向向上，CollectionView 是用户拖拽而产生滚动的（主要是判断 tableView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
    if (!_isScrollDown && self.isScroll)
    {
        [self selectRowAtIndexPath:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前 CollectionView 滚动的方向向下，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
    if (_isScrollDown && self.isScroll)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 标记一下 tableView 的滚动方向，是向上还是向下
    static float lastOffsetY = 0;
    _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
    lastOffsetY = scrollView.contentOffset.y;
    
    
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

// 当拖动 CollectionView 的时候，处理 TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    if (self.type.intValue == 10)
    {
//        NSIndexPath * indexPath1 = [NSIndexPath indexPathForRow:self.headerView.selectedTimeIndex inSection:0];
//        MyHotGameClassifyCell * cell1 = (MyHotGameClassifyCell *)[self.headerView.collectionView cellForItemAtIndexPath:indexPath1];
//        cell1.showName.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//        cell1.showName.textColor = FontColor66;
//
//        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        MyHotGameClassifyCell * cell = (MyHotGameClassifyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        cell.showName.backgroundColor = MAIN_COLOR;
//        cell.showName.textColor = UIColor.whiteColor;
        MYLog(@"===============%ld", (long)index);
        if (index >= self.dataArray.count) {
            return;
        }
        [UIView animateWithDuration:0.1 animations:^{
            [self.headerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isScroll = YES;
            self.headerView.selectedTimeIndex = index;
            [self.headerView.collectionView reloadData];
        });
    }
}

#pragma mark - 刷新控件
- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self kaiFuApiRequest:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    if (self.type.intValue == 30)
    {
        // 上拉刷新
        tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNumber ++;
            [self kaiFuApiRequest:^(BOOL isSuccess) {
                [tableView.mj_footer endRefreshing];
            } Hud:NO];
        }];
    }
}

@end
