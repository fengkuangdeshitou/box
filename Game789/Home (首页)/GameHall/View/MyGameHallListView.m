//
//  MyGameHallListView.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGameHallListView.h"
#import "HomeListTableViewCell.h"
#import "MyHallGameTypeCell.h"
#import "GetGameHallListApi.h"
#import "GameRankingTableViewCell.h"
#import "GameDetailInfoController.h"
#import "MyGameHallSortSectionView.h"
#import "MyHallStepMaskGuideView.h"
#import "MyGameHallHeaderView.h"
#import "HGHomeProjectGamesCell.h"
#import "GameTableViewCell.h"
#import "GameModel.h"
#import "InternalTestingViewController.h"
#import "MyProjectGameController.h"

@interface MyGameHallListView () <GameRankingTableViewCellDelegate>

@property (nonatomic, strong) MyGameHallSortSectionView * sortSectionView;
@property (nonatomic, copy) NSString * sortType;
@property (nonatomic, strong) MyGameHallHeaderView *headerView;


@end

@implementation MyGameHallListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.pageNumber = 1;
        [self loadData];
        
        NSString * typeId = [YYToolModel getUserdefultforKey:@"HomeGameTypeClick"];
        if (typeId)
        {
            self.typeId = typeId;
            [YYToolModel deleteUserdefultforKey:@"HomeGameTypeClick"];
        }
    }
    return self;
}

- (void)setTypeArray:(NSArray *)typeArray
{
    _typeArray = typeArray;
    
    for (NSInteger i = 0; i < typeArray.count; i ++)
    {
        NSDictionary * dic = typeArray[i];
        if ([dic[@"game_classify_id"] isEqualToString:self.typeId])
        {
            self.typeSelectedIndex = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    
    [self.typeTableView reloadData];
}

- (void)setTypeId:(NSString *)typeId
{
    _typeId = typeId;
    
    for (NSInteger i = 0; i < self.typeArray.count; i ++)
    {
        NSDictionary * dic = self.typeArray[i];
        if ([dic[@"game_classify_id"] isEqualToString:typeId])
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self selectGameType:indexPath];
            self.typeSelectedIndex = indexPath;
            break;
        }
    }
//    [self.tableView.mj_header beginRefreshing];
//    [self.typeTableView reloadData];
    
//    [self gameTypeRequestList:nil Hud:NO];
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    //排行榜和新游榜
    if (type.integerValue == 2 || type.integerValue == 3)
    {
        self.typeTableView.width = 0;
        self.typeTableView.hidden = YES;
        self.tableView.x = 0;
        self.tableView.width = kScreenW;
    }
    else
    {
        [self addSubview:self.sortSectionView];
    }
}

//列表数据
- (void)gameTypeRequestList:(RequestData)block Hud:(BOOL)isShow
{
    //统计排行榜的游戏类型切换
    if (self.type.integerValue == 2)
    {
        [MyAOPManager relateStatistic:@"ClickTheLeaderboard" Info:@{@"game_species_type":self.game_species_type}];
    }
    else if (self.type.integerValue == 3)
    {
        [MyAOPManager relateStatistic:@"ClickTheNewGameList" Info:@{@"game_species_type":self.game_species_type}];
    }
    
    GetGameHallListApi *api = [[GetGameHallListApi alloc] init];
    api.pageNumber = 1;
    api.count = 10;
    api.isShow = isShow;
    api.search_info = self.searchInfo;
    api.game_classify_type = self.typeId;
    api.type = self.type;
    api.game_species_type = self.game_species_type;
    api.sortType = self.sortType;
    api.pageNumber = self.pageNumber;
    if (self.typeId.integerValue == -1 && self.game_species_type.integerValue != 1)
    {
        api.game_classify_type = @"";
    }
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleGameTypeListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleGameTypeListSuccess:(GetGameHallListApi *)api {
    if (api.success == 1)
    {
        [self gameMallParmasData:api.data];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc];
    }
}

- (void)gameMallParmasData:(NSDictionary *)data
{
    NSArray *array = [data objectForKey:@"game_list"];
    if (self.typeId.integerValue == -1 && self.game_species_type.integerValue == 1)
    {//只有bt和精选才显示
        array = data[@"game_cate"];
        self.tableView.tableHeaderView = self.headerView;
        self.commendArray = array;
        self.headerView.dataArray = data[@"banner_list"];
        self.bannerArray = data[@"banner_list"];
        
        //存储BT精选数据
        [YYToolModel saveCacheData:data forKey:MiluGameMallDataCache];
    }
    else
    {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.001)];
    }
    if (self.pageNumber == 1)
    {
        self.dataArray = [NSMutableArray arrayWithArray:array];
    }
    else
    {
        [self.dataArray addObjectsFromArray:array];
    }
    NSDictionary *dic = data[@"paginated"];
    self.hasNextPage = [dic[@"more"] boolValue];
    [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:[self.currentVC creatFooterView]];
    [self.tableView reloadData];
    _tableView.ly_emptyView.contentView.hidden = NO;
    //是否要滚动到顶部
    if (self.pageNumber == 1 && self.dataArray.count > 0 && self.typeSelectedIndex.row != 0 && self.type.intValue == 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (self.typeSelectedIndex.row == 0 && self.type.intValue == 0)
    {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
    //游戏大厅的引导页面
    [self showGuidePageView];
}

- (UITableView *)typeTableView
{
    if (!_typeTableView)
    {
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 64, self.height) style:UITableViewStyleGrouped];
        _typeTableView.delegate = self;
        _typeTableView.dataSource = self;
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _typeTableView.showsVerticalScrollIndicator = NO;
        _typeTableView.tableFooterView = [UIView new];
        _typeTableView.tableHeaderView = [UIView new];
        _typeTableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _typeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [self addSubview:_typeTableView];
        self.typeSelectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _typeTableView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(64, 0, kScreenW - 64, self.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        [self addSubview:_tableView];
        
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"game_no_data" titleStr:@"暂无此类游戏~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HGHomeProjectGamesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGHomeProjectGamesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameTableViewCell"];
    }
    return _tableView;
}

#pragma mark - 懒加载
- (MyGameHallHeaderView *)headerView
{
    if (!_headerView)
    {
        CGFloat width = kScreenW - 72;
        _headerView = [[MyGameHallHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, width * 233.5 / 266 + 8)];
    }
    return _headerView;
}

#pragma mark - 懒加载
- (MyGameHallSortSectionView *)sortSectionView
{
    if (!_sortSectionView)
    {
        WEAKSELF
         _sortSectionView = [[MyGameHallSortSectionView alloc] initWithFrame:CGRectMake(64, 0, self.tableView.width, 52)];
        _sortSectionView.sortValueChangedAction = ^(NSString * _Nonnull value) {
            weakSelf.sortType = value;
            weakSelf.pageNumber = 1;
            [weakSelf gameTypeRequestList:nil Hud:YES];
        };
        _sortSectionView.hidden = YES;
    }
    return _sortSectionView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.typeTableView) {
        return 1;
    }else{
        if (self.typeSelectedIndex.row == 0 && self.game_species_type.integerValue == 1  && self.type.intValue == 0){
            return self.dataArray.count;
        }else{
            return self.dataArray.count;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.typeTableView)
    {
        return self.typeArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.typeTableView)
    {
        return 54;
    }
    else if (self.typeSelectedIndex.row == 0 && self.game_species_type.integerValue == 1  && tableView == self.tableView && self.type.intValue == 0)
    {
        return 305 + 38;
    }else{
        if (self.type.integerValue == 0) {
            GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
            return model.hallCellHeight+25;
        }else{
            return 110;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.typeTableView)
    {
        return 0.001;
    }
    return section == 0 ? 10 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableView == self.typeTableView ? 0.001 : 10;
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
    if (tableView == self.typeTableView)
    {
        static NSString *reuseID = @"cell";
        MyHallGameTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MyHallGameTypeCell" owner:self options:nil].firstObject;
        }
        if (indexPath == self.typeSelectedIndex)
        {
            cell.lineImageView.hidden = NO;
            cell.showTitle.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
            cell.showTitle.textColor = [UIColor colorWithHexString:@"#FFC000"];
            cell.showTitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        }
        else
        {
            cell.lineImageView.hidden = YES;
            cell.showTitle.backgroundColor = [UIColor whiteColor];
            cell.showTitle.textColor = [UIColor colorWithHexString:@"#999999"];
            cell.showTitle.font = [UIFont systemFontOfSize:13];
        }
        cell.showTitle.text = self.typeArray[indexPath.row][@"game_classify_name"];
        
        if (self.typeSelectedIndex.row == 0 && indexPath.row == 1) {
            [self clipRectCorner:UIRectCornerTopRight view:cell.showTitle];
        }else if(self.typeSelectedIndex.row == self.typeArray.count-1 && indexPath.row == self.typeArray.count-2){
            [self clipRectCorner:UIRectCornerBottomRight view:cell.showTitle];
        }else if(indexPath.row == self.typeSelectedIndex.row-1){
            [self clipRectCorner:UIRectCornerBottomRight view:cell.showTitle];
        }else if(indexPath.row == self.typeSelectedIndex.row+1){
            [self clipRectCorner:UIRectCornerTopRight view:cell.showTitle];
        }
        
        return cell;
    }
    else
    {
        if (self.typeSelectedIndex.row == 0 && self.game_species_type.integerValue == 1 && self.type.intValue == 0)
        {
            static NSString *cellIndentifer = @"HGHomeProjectGamesCell";
            HGHomeProjectGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
            cell.currentVC = self.currentVC;
            cell.type = @"banner";
            cell.dataDic = self.dataArray[indexPath.section];
            return cell;
        }
        else
        {
            static NSString * identifity = @"GameTableViewCell";
            GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
            }
            cell.currentVC = self.currentVC;
            cell.indexPath = indexPath;
            cell.listType = self.type;
            if (self.type.integerValue == 0)
            {
                cell.logoImageViewWidth.constant = 64;
                cell.logoImageViewRadius = 15;
            }
            NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.section];
            [cell setModelDic:dic];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
            [YYToolModel clipRectCorner:UIRectCornerAllCorners radius:13 view:cell.radiusView];
            if (![self.sortType isEqualToString:@"new"] && indexPath.section < 3)
            {//一周新游top
                cell.rankImageView.hidden = NO;
                cell.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"top_game_rank_%ld", indexPath.section + 1]];
            }
            else
            {
                cell.rankImageView.hidden = YES;
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"==%ld",(long)indexPath.row);
    if (tableView == self.typeTableView )
    {
        [self selectGameType:indexPath];
    }
    else
    {
        if (self.typeSelectedIndex.row == 0 && self.type.intValue == 0 && self.game_species_type.integerValue == 1)
        {
            NSDictionary * dic = self.dataArray[indexPath.section];
            if (dic[@"specialId"]) {
                NSInteger type = [dic[@"type"] integerValue];
                if (type == 6) {
                    InternalTestingViewController * detail = [[InternalTestingViewController alloc] init];
                    detail.Id = dic[@"specialId"];
                    detail.hidesBottomBarWhenPushed = true;
                    [YYToolModel.getCurrentVC.navigationController pushViewController:detail animated:YES];
                    return;
                }
                
                MyProjectGameController * project = [MyProjectGameController new];
                project.hidesBottomBarWhenPushed = YES;
                project.project_id = dic[@"specialId"];
                project.project_title = dic[@"title"];
                project.type = [NSString stringWithFormat:@"%ld",type];
        //        project.dataDic = dic;
                [YYToolModel.getCurrentVC.navigationController pushViewController:project animated:YES];
            }else{
                for (int i = 0; i < self.typeArray.count; i ++)
                {
                    NSDictionary * typeDic = self.typeArray[i];
                    if ([typeDic[@"game_classify_id"] integerValue] == [dic[@"game_classify_id"] integerValue]) {
                        NSIndexPath * typeIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [self selectGameType:typeIndexPath];
                        break;
                    }
                }
            }
            
        }
        else
        {
            [self gameContentTableCellBtn:self.dataArray[indexPath.section]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView && (self.typeSelectedIndex.row != 0 || self.type.intValue != 0))
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
}

- (void)clipRectCorner:(UIRectCorner)corner view:(UIView *)view{
    CGRect rect = CGRectMake(0, 0, 64, 54);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}

- (void)selectGameType:(NSIndexPath *)indexPath
{
    if (self.typeSelectedIndex != indexPath)
    {
        self.typeSelectedIndex = indexPath;
        [self.typeTableView reloadData];
        
        
        NSDictionary * dic = self.typeArray[indexPath.row];
        self.typeId = dic[@"game_classify_id"];
        if (self.typeSelectedIndex.row == 0 && self.typeId.integerValue == -1 && self.game_species_type.integerValue == 1)
        {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (self.commendArray.count > 0)
            {
                //请求完成之后修改顶部排序view
                [self changeSortViewFrame];
                self.dataArray = [NSMutableArray arrayWithArray:self.commendArray];
                self.tableView.tableHeaderView = self.headerView;
                self.headerView.dataArray = self.bannerArray;
                [self.tableView reloadData];
                
                self.tableView.contentOffset = CGPointMake(0, 0);
            }
            else
            {
                self.pageNumber = 1;
                [self gameTypeRequestList:^(BOOL isSuccess) {
                    //请求完成之后修改顶部排序view
                    [self changeSortViewFrame];
                } Hud:YES];
            }
        }
        else
        {
//            [self.tableView.mj_footer resetNoMoreData];
            self.pageNumber = 1;
            [self gameTypeRequestList:^(BOOL isSuccess) {
                //请求完成之后修改顶部排序view
                [self changeSortViewFrame];
            } Hud:YES];
        }
        //统计点击类型
        [MyAOPManager relateStatistic:@"ClickGameCategory" Info:@{@"game_species_type":self.game_species_type, @"game_classify_name":dic[@"game_classify_name"]}];
    }
}

- (void)changeSortViewFrame
{
    [UIView animateWithDuration:0.05 animations:^{
        if ([self.typeId integerValue] == -1)
        {
            self.tableView.y = 0;
            self.tableView.height = self.height;
            self.sortSectionView.hidden = YES;
        }
        else
        {
            self.tableView.y = 52;
            self.tableView.height = self.height - 52;
            self.sortSectionView.hidden = NO;
        }
    }];
}

#pragma mark - 前三名点击查看详情
- (void)rankTopClcik:(NSInteger)index
{
    NSDictionary * dic = self.dataArray[index];
    [self gameContentTableCellBtn:dic];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic
{
    if (dic)
    {
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic[@"game_id"];
        detailVC.title  = dic[@"game_name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self gameTypeRequestList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self gameTypeRequestList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

#pragma mark - 游戏大厅引导图
- (void)showGuidePageView
{
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"HallGuidePageView"];
    if (userCenter != NULL || ![[YYToolModel getCurrentVC] isKindOfClass:[NSClassFromString(@"MyNewGameHallController") class]])
    {
        return;
    }
    [YYToolModel saveUserdefultValue:@"1" forKey:@"HallGuidePageView"];
    
    NSMutableArray * array = [NSMutableArray array];
    CGRect frame = CGRectMake((kScreenW - 85) / 2, kStatusBarHeight, 85, 44);
    WKStepMaskModel * model1 = [WKStepMaskModel creatModelWithFrame:frame cornerRadius:0 step:0];
    [array addObject:model1];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    MyHallGameTypeCell * cell = (MyHallGameTypeCell *)[self.typeTableView cellForRowAtIndexPath:indexPath];
    
    WKStepMaskModel * model = [WKStepMaskModel creatModelWithView:cell.showTitle cornerRadius:0 step:1];
    [array addObject:model];
    
    MyHallStepMaskGuideView * guideView = [[MyHallStepMaskGuideView alloc] initWithModels:array];
    [guideView showInView:[UIApplication sharedApplication].keyWindow isShow:YES];
}

@end
