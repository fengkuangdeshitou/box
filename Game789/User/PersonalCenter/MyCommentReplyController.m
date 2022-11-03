//
//  MyCommentReplyController.m
//  Game789
//
//  Created by Maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyCommentReplyController.h"
#import "GameCommitDetailController.h"

#import "MyCommentReplyCell.h"

#import "PersonalCenterApi.h"
@class GetMyCommentApi;
@class GetMyReplyApi;

@interface MyCommentReplyController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyCommentReplyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getMyCommentData:(RequestData)block Hud:(BOOL)isShow
{
    GetMyReplyApi * api = [[GetMyReplyApi alloc] init];
    api.user_id = self.user_id;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"list"])
            {
                if (![dic[@"reply_user_id"] isEqualToString:@""])
                {
                    Comment * comment = [[Comment alloc] initWithDictionary:dic];
                    [array addObject:comment];
                }
            }
            self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:array] : [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            self.tableView.ly_emptyView.contentView.hidden = NO;
            self.tableView.ly_emptyView.y = 50;
            [self loadData];
            
            NSDictionary *dic = request.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_comment_no_data" titleStr:@"您还没发表过点评哦" detailStr:@""];
        self.tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"MyCommentReplyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
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
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"cell";
    MyCommentReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.comment = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment * comment = self.dataArray[indexPath.section];
    GameCommitDetailController * detail = [[GameCommitDetailController alloc] init];
    detail.commit_id = comment.Id;
    detail.game_name = comment.game_info[@"game_name"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
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

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getMyCommentData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getMyCommentData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
