//
//  GameCommitMoreViewController.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GameCommitDetailController.h"
#import "GameCommitApi.h"
#import "GameCommitListTableViewCell.h"
#import "CommitDetailHeaderView.h"
#import "CommitReplyView.h"

#import "Comment.h"
#import "CommentApi.h"

@class GetCommentDetailApi;
@class GetCommentListApi;
@class LikeCommentApi;

@interface GameCommitDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *writeCommitView;
@property (weak, nonatomic) IBOutlet MyLikeButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;

//详情
@property (nonatomic, strong) Moment * moment;
//列表
@property (nonatomic, strong) Comment * comment;

@end

@implementation GameCommitDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getCommentList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark - 基本配置
- (void)prepareBasic
{
    self.navBar.title = self.game_name;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.likeButton.animateStyle = YYViewAnimateEffectStyleFlash;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCommitAction:)];
    [self.writeCommitView addGestureRecognizer:tap];
}

#pragma mark - 获取评论详情
- (void)getCommentDetail
{
    GetCommentDetailApi * api = [[GetCommentDetailApi alloc] init];
    api.Id = self.commit_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.moment = [[Moment alloc] initWithDictionary:request.data];
            self.likeCount.text = self.moment.like_count;
            self.moment.me_like.intValue == 0 ? [self.likeButton setImage:[UIImage imageNamed:@"lhh_home_zanblack"] forState:0] : [self.likeButton setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:0];
            self.commentCount.text = self.moment.reply_count;
            
            _tableView.tableHeaderView = [self creatHeaderView];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - 获取评论的评论列表
- (void)getCommentList
{
    GetCommentListApi * api = [[GetCommentListApi alloc] init];
    api.comment_id = self.commit_id;
    api.pageNumber = self.pageNumber;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"comment_list"])
            {
                Comment * comment = [[Comment alloc] initWithDictionary:dic];
                [array addObject:comment];
            }
            self.pageNumber == 1 ? self.dataSource = [NSMutableArray arrayWithArray:array] : [self.dataSource addObjectsFromArray:array];
            
            [self getCommentDetail];
            [self.tableView reloadData];
            
            NSDictionary *dic = request.data[@"paginated"];
            if (self.dataSource.count >= [dic[@"total"] integerValue])
            {
                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;

    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getCommentList];
        [tableView.mj_header endRefreshing];
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getCommentList];
        [tableView.mj_footer endRefreshing];
    }];
}

- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight-kTabbarSafeBottomMargin - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 110;
        _tableView.backgroundColor = BackColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"msg_no_data" titleStr:@"暂无评论~" detailStr:@""];
        [self.view addSubview:_tableView];
        [self loadData];
    }
    return _tableView;
}

- (UIView *)creatHeaderView
{
    CommitDetailHeaderView * headerView = [[CommitDetailHeaderView alloc] init];
    headerView.currentVC = self;
    headerView.moment = self.moment;
    
    _tableView.ly_emptyView.y = headerView.view_height + 50;
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    GameCommitListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GameCommitListTableViewCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self;
    cell.isShowComment = NO;
    cell.isComments = YES;
    cell.moment = self.moment;
    cell.comment = self.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Comment * comment = self.dataSource[indexPath.section];
    [self showReplyView:comment.user_nickname ReplyID:comment.Id];
    
}

#pragma mark - 评论
- (void)startCommitAction:(UITapGestureRecognizer *)tap
{
    [self showReplyView:@"" ReplyID:@""];
}

- (void)showReplyView:(NSString * )placeHolderName ReplyID:(NSString *)reply_id
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    CommitReplyView * replyView = [[CommitReplyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight)];
    replyView.commentSuccess = ^(NSString *content) {
        [self getCommentList];
    };
    if (placeHolderName.length > 0)
    {
        replyView.reply_placeHolder = placeHolderName;
    }
    replyView.comment_id = self.moment.Id;
    replyView.reply_id   = reply_id;
    [self.view addSubview:replyView];
}

#pragma mark - 点赞
- (IBAction)likeAction:(id)sender
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if (_moment.me_like.intValue == 0)
    {
        UIButton * button = (UIButton *)sender;
        LikeCommentApi * api = [[LikeCommentApi alloc] init];
        api.Id = _moment.Id;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                _likeCount.text = [NSString stringWithFormat:@"%d", _moment.like_count.intValue + 1];
                _moment.me_like = @"1";
                [button setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:0];
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

@end
