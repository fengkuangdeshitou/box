//
//  GameCommitMoreViewController.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HGCommunityDetailVC.h"
#import "HGGameCommitListTableViewCell.h"
#import "HGCommunityDetailV.h"
#import "CommitReplyView.h"

#import "MyCommunityRequestApi.h"
@class MyCommunityDetailDataApi;
@class MyCommunityDetailListApi;
@class MyCommunityAppraisalApi;

@interface HGCommunityDetailVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, HGCommunityDetailVDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *writeCommitView;
@property (weak, nonatomic) IBOutlet UITextField *enterText;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_bottom;
@property (nonatomic, assign) BOOL isDesc;
//详情
@property (nonatomic, strong) NSDictionary * momentDic;
@property (nonatomic, strong) Moment * moment;
//列表
@property (nonatomic, strong) Comment * comment;

@property (nonatomic, strong) HGCommunityDetailV * headerView;
@property (nonatomic, assign) CGFloat keyboardHeight;
/**  1 发表评论 2 回复评论  */
@property (nonatomic, assign) NSInteger enterType;
@property (nonatomic, assign) BOOL isEntering;
@property (nonatomic, copy) NSString * reply_id;  //评论id

@end

@implementation HGCommunityDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getCommentDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.headerView.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerView.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [self.headerView.player vc_viewDidDisappear];
}

- (void)dealloc
{
    [self.headerView.player stop];
}

#pragma mark - 基本配置
- (void)prepareBasic
{
    self.navBar.title = @"论坛详情";
    self.reply_id = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithImage:MYGetImage(@"sangedian_icon")];
    [self.navBar setOnClickRightButton:^{
        [weakSelf alertSheetView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)alertSheetView
{
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat durition = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    _keyboardHeight = [notification keyBoardHeight] - kTabbarSafeBottomMargin;
    [UIView animateWithDuration:durition animations:^{
        [self updateTextViewFrame];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat durition = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    _keyboardHeight = 0;
    [UIView animateWithDuration:durition animations:^{
        [self updateTextViewFrame];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.enterType = 0;
}

- (void)updateTextViewFrame
{
    if (self.enterType == 1)
    {
        self.bottomView_bottom.constant = -_keyboardHeight;
    }
    else if (self.enterType == 2)
    {
        
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.enterType = 1;
    
    return YES;
}

- (IBAction)textFieldEditingChanged:(id)sender
{
    [self updateTextViewFrame];
}

#pragma mark - 获取评论详情
- (void)getCommentDetail
{
    MyCommunityDetailDataApi * api = [[MyCommunityDetailDataApi alloc] init];
    api.isShow = YES;
    api.detailId = self.commit_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary *dic = request.data[@"foruminvit"];
            self.moment = [[Moment alloc] initWithDictionary:dic];
            self.momentDic = dic;
            self.tableView.tableHeaderView = [self creatHeaderView];
            
            [self getCommentList:nil Hud:YES];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - 获取评论的评论列表
- (void)getCommentList:(RequestData)block Hud:(BOOL)isShow
{
    MyCommunityDetailListApi * api = [[MyCommunityDetailListApi alloc] init];
    api.isShow = isShow;
    api.pageNumber = self.pageNumber;
    api.detailId = self.commit_id;
    api.sort = self.isDesc ? @"desc" : @"asc";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1) {
            NSDictionary * dataDic = request.data;
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in dataDic[@"list"])
            {
                Comment * comment = [[Comment alloc] initWithDictionary:dic];
                [array addObject:comment];
            }

            self.pageNumber == 1 ? self.dataSource = [NSMutableArray arrayWithArray:array] : [self.dataSource addObjectsFromArray:array];
            [self setFooterViewState:self.tableView Data:dataDic[@"paginated"] FooterView:[self creatFooterView]];
            self.hasNextPage = [dataDic[@"paginated"][@"more"] boolValue];
            self.tableView.hidden = NO;
            [self.tableView reloadData];

            if (self.dataSource.count == 0)
            {
                self.tableView.contentSize = CGSizeMake(kScreenW, self.headerView.view_height - self.tableView.height > 0 ? self.headerView.view_height + 300 : self.tableView.height + 300);
                
                if (self.headerView.view_height > self.tableView.height / 2)
                {
                    self.tableView.ly_emptyView.contentView.ly_centerY = self.headerView.view_height - self.tableView.height / 2 + 250;
                }
                else
                {
                    self.tableView.ly_emptyView.contentView.ly_centerY = self.headerView.view_height - self.tableView.height / 2 + 250;
                }
            }
            self.tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;

    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getCommentList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getCommentList:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH-kStatusBarAndNavigationBarHeight-kTabbarSafeBottomMargin - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 110;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        [self.view insertSubview:_tableView belowSubview:self.bottomView];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"comment_no_data" titleStr:@"该话题暂无评论" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.hidden = YES;
    }
    return _tableView;
}

- (NSNumber *)xy_noDataViewCenterYOffset
{
    if (self.headerView.view_height > self.tableView.height / 2)
    {
        return [NSNumber numberWithFloat:self.headerView.view_height - self.tableView.height / 2 + 200];
    }
    return [NSNumber numberWithFloat:self.headerView.view_height - self.tableView.height / 2 + 200];
}

- (UIView *)creatHeaderView
{
    HGCommunityDetailV * headerView = [[HGCommunityDetailV alloc] init];
    headerView.currentVC = self;
    headerView.moment = self.moment;
    headerView.momentDic = self.momentDic;
    headerView.delegate = self;
    headerView.frame = CGRectMake(0, 0, kScreenW, headerView.view_height);
    headerView.selectSortAction = ^(BOOL isDesc) {
        self.isDesc = isDesc;
        [self getCommentList:nil Hud:NO];
    };
    self.headerView = headerView;
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    HGGameCommitListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HGGameCommitListTableViewCell" owner:self options:nil].firstObject;
    }
    cell.currentVC = self;
    cell.comment = self.dataSource[indexPath.row];
    
    
//    NSDictionary *dic = self.dataSource[indexPath.row];
//    cell.commentDic = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.enterType != 1)
    {
        self.enterType = 2;

        Comment *comment = self.dataSource[indexPath.row];
        self.reply_id = comment.Id;
        [self showReplyView:comment.user[@"nickname"] ReplyID:comment.Id];
    }
}

#pragma mark - UITableViewDelegate
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


- (void)showReplyView:(NSString * )placeHolderName ReplyID:(NSString *)reply_id
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    
    CommitReplyView * replyView = [[CommitReplyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight)];
    replyView.commentSuccess = ^(NSString *content) {
        [self getCommentList:nil Hud:NO];
    };
    if (placeHolderName.length > 0)
    {
        replyView.reply_placeHolder = placeHolderName;
    }
    replyView.comment_id = self.commit_id;
    replyView.reply_id   = reply_id;
    replyView.isCommunity = YES;
    [self.view addSubview:replyView];
}

- (IBAction)submitBtnClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    NSString * content = [self.enterText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (content.length < 5)
    {
        [MBProgressHUD showToast:@"回复评论字数不少于5个" toView:self.view];
        return;
    }
    MyCommunityAppraisalApi * api = [[MyCommunityAppraisalApi alloc] init];
    api.isShow = YES;
    api.detailId = self.commit_id;
    api.replyid = self.reply_id;
    api.content = content;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self.enterText resignFirstResponder];
            self.enterText.text = @"";
            [YJProgressHUD showSuccess:@"发表成功，后台审核中" inview:self.view];
            [self getCommentList:nil Hud:NO];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)onLikeChange:(Moment *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityDetailDidChangeLikeStatus:)]) {
        [self.delegate communityDetailDidChangeLikeStatus:model];
    }
}

- (void)onDisLikeChange:(Moment *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityDetailDidChangeDisLikeStatus:)]) {
        [self.delegate communityDetailDidChangeDisLikeStatus:model];
    }
}

@end
