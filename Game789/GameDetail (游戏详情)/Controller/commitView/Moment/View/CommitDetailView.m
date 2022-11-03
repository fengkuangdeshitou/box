//
//  CommitDetailView.m
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "CommitDetailView.h"
#import "CommitDetailCell.h"
#import "GameCommitMoreController.h"
#import "GameCommitViewController.h"
#import "GameCommitDetailController.h"
#import "UserPersonalCenterController.h"

#import "GameCommitApi.h"
#import "CommentApi.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "MyCommentListHeaderView.h"

@interface CommitDetailView ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) MyCommentListHeaderView * headerView;

@property (nonatomic, assign) NSInteger  pageNumber;

@end

@implementation CommitDetailView

- (instancetype)initWithFrame:(CGRect)frame TopicId:(NSString *)topicId
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.topicId = topicId;
        self.pageNumber = 1;
        [self getCommitApiRequest];
    }
    return self;
}

#pragma mark --获取评论数据--
- (void)getCommitApiRequest
{
    GameCommitApi *api = [[GameCommitApi alloc] init];
    //    WEAKSELF
    api.topic_id = self.topicId;
    api.pageNumber = self.pageNumber;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            self.commitArrays = api.data[@"list"];;
            self.topicId = self.topicId;
            
            NSDictionary *dic = request.data[@"paginated"];
            NSInteger total = [dic[@"total"] integerValue];
            (total == 0) ? (self.moreCommit.hidden = YES) : (self.moreCommit.hidden = NO);
            self.commitData(self.commitArrays, [NSString stringWithFormat:@"%ld", (long)total]);
            [self.currentVC setFooterViewState:self.tableView Data:dic FooterView:[self.currentVC creatFooterView]];
//            if (self.isFooterHidden)
//            {
//                if (self.commitArrays.count >= [dic[@"total"] integerValue])
//                {
//                    self.tableView.mj_footer.hidden = YES;
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
//                }
//                else
//                {
//                    self.tableView.mj_footer.hidden = NO;
//                }
//            }
//            else
//            {
//                [self.currentVC creatFooterView];
//            }
            
            if (self.isShowQuestion)
            {
                self.tableView.tableHeaderView = self.headerView;
                self.headerView.dataDic = self.dataDic;
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [self.tableView reloadData];
    }];
}

- (void)setCommitArrays:(NSMutableArray *)commitArrays
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < commitArrays.count; i ++)
    {
        Moment * moment = [[Moment alloc] initWithDictionary:commitArrays[i]];
        [array addObject:moment];
    }
    self.pageNumber == 1 ? _commitArrays = [NSMutableArray arrayWithArray:array] : [_commitArrays addObjectsFromArray:array];
    [self.tableView reloadData];
    _tableView.ly_emptyView.contentView.hidden = NO;
//    _tableView.ly_emptyView.y = 50;
    
    //底部控件
    if (self.isFooterHidden)
    {
        //创建刷新控件
        [self loadData];
    }
    else
    {
        self.tableView.tableFooterView = [self creatFooterView];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = BackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        LYEmptyView * ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"comment_no_data" titleStr:@"暂无评论，抢个沙发哦~" detailStr:@""];
        ly_emptyView.contentView.hidden = YES;
        _tableView.ly_emptyView = ly_emptyView;
        [self addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight=0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (MyCommentListHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyCommentListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    }
    return _headerView;
}

- (UIView *)creatFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    
    WEAKSELF
    UIButton * moreButton = [UIControl creatButtonWithFrame:CGRectMake(footerView.center.x - 80, 0, 160, 30) backgroundColor:[UIColor whiteColor] title:@"点击查看更多评论".localized titleFont:[UIFont systemFontOfSize:13] actionBlock:^(UIControl *control)
    {
        //短视频隐藏评论的view
        [self hiddenPopView:YES];
        
        GameCommitMoreController *detailVC = [[GameCommitMoreController alloc] init];
        detailVC.topicId = self.topicId;
        detailVC.game_name = self.game_name.length > 0 ? self.game_name : @"评论列表".localized;
        detailVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.currentVC.navigationController pushViewController:detailVC animated:YES];
    }];
    [moreButton setTitleColor:[UIColor colorWithHexString:@"#FF8A1C"] forState:0];
    [footerView addSubview:moreButton];
    self.moreCommit = moreButton;
    
    return footerView;
}

#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - MomentCellDelegate
// 点击用户头像
- (void)didClickProfile:(MomentCell *)cell
{
    NSLog(@"击用户头像");
    
    //短视频隐藏评论的view
    [self hiddenPopView:YES];
    
    [self pushPersonalCerter:cell.moment.user_id];
}

// 点赞
- (void)didLikeMoment:(MomentCell *)cell
{
    NSLog(@"点赞");
}

// 评论
- (void)didAddComment:(MomentCell *)cell
{
    NSLog(@"评论");
}

// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText detail:(Comment *)comment
{
    NSLog(@"点击高亮文字：%@",linkText);
    linkText = [linkText substringToIndex:linkText.length - 1];
//    linkText = [linkText stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * user_id = @"";
    if ([linkText isEqualToString:comment.user_nickname])
    {
        user_id = comment.user_id;
    }
    else if ([linkText isEqualToString:comment.reply_nickname])
    {
        user_id = comment.reply_user_id;
    }
    [self pushPersonalCerter:user_id];
}

- (void)pushPersonalCerter:(NSString *)user_id
{
    //短视频隐藏评论的view
    [self hiddenPopView:YES];

    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
    personal.user_id = user_id;
    personal.isHiddenBtn = YES;
    personal.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:personal animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commitArrays.count;
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
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.currentVC = self.currentVC;
    cell.moment = [self.commitArrays objectAtIndex:indexPath.section];
    cell.delegate = self;
    cell.hiddenCommitPopView = ^(BOOL isHidden) {
        if (isHidden && self.hiddenCommitPopView) {
            self.hiddenCommitPopView(isHidden);
        };
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    Moment *moment = [self.commitArrays objectAtIndex:indexPath.section];
    return moment.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //短视频隐藏评论的view
    [self hiddenPopView:YES];
    
    Moment * moment = self.commitArrays[indexPath.section];
    GameCommitDetailController * detail = [GameCommitDetailController new];
    detail.commit_id = moment.Id;
    detail.game_name = self.game_name.length == 0 ? @"评论详情".localized : self.game_name;
    detail.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.menuView.show = NO;
}

- (void)writeCommit
{
    //短视频隐藏评论的view
    [self hiddenPopView:YES];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (!userId && userId.length == 0)
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    GameCommitViewController *detailVC = [[GameCommitViewController alloc]init];
    detailVC.topicId = self.topicId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getCommitApiRequest];
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getCommitApiRequest];
        [tableView.mj_footer endRefreshing];
    }];
}

#pragma mark ——— 短视频的评论是否隐藏评论的View
- (void)hiddenPopView:(BOOL)isHidden
{
    if (self.hiddenCommitPopView)
    {
        self.hiddenCommitPopView(isHidden);
    }
}

#pragma mark - 重载系统的hitTest方法

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    MyGameDetailViewController *currentVC = (MyGameDetailViewController *)self.currentVC;
//
//    CGFloat offsetY = currentVC.scrollerView.contentOffset.y;
//    CGFloat targetY = 270 - 25 - kStatusBarAndNavigationBarHeight;
//
//    if (offsetY >= targetY)
//    {
//        currentVC.scrollerView.scrollEnabled = NO;
//        return self.tableView;
//    }
//    else
//    {
//        currentVC.scrollerView.scrollEnabled = YES;
//        return [super hitTest:point withEvent:event];
//    }
//}

@end
