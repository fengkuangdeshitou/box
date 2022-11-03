//
//  PublishedCommentController.m
//  Game789
//
//  Created by Maiyou on 2018/11/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "PublishedCommentController.h"
#import "GameCommitDetailController.h"
#import "UserPersonalCenterController.h"

#import "PersonalCenterApi.h"

#import "MomentCell.h"
#import "GameCommitListTableViewCell.h"

@class GetMyCommentApi;

@interface PublishedCommentController () <UITableViewDelegate, UITableViewDataSource, MomentCellDelegate>
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PublishedCommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self loadData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)getMyCommentData:(RequestData)block Hud:(BOOL)isShow
{
    GetMyCommentApi * api = [[GetMyCommentApi alloc] init];
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
                if ([dic[@"reply_user_id"] isEqualToString:@""])
                {
                    Moment * moment = [[Moment alloc] initWithDictionary:dic];
                    [array addObject:moment];
                }
                else
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = BackColor;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_comment_no_data" titleStr:@"您还没发表过点评哦" detailStr:@""];
        self.tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.section] isKindOfClass:[Moment class]])
    {
        // 使用缓存行高，避免计算多次
        Moment *moment = [self.dataArray objectAtIndex:indexPath.section];
        return moment.rowHeight;
    }
    else
    {
        Comment * comment = self.dataArray[indexPath.section];
        return comment.rowHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 10 : 0.01;
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
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
//    view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.section] isKindOfClass:[Moment class]])
    {
        static NSString *identifier = @"MomentCell";
        MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.currentVC = self;
        cell.isPersonal = YES;
        cell.moment = [self.dataArray objectAtIndex:indexPath.section];
        cell.delegate = self;
        return cell;
    }
    else
    {
        static NSString * identifier = @"cell";
        GameCommitListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameCommitListTableViewCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.isShowComment = YES;
        cell.comment = self.dataArray[indexPath.section];
        cell.currentVC = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * Id = @"";
    NSString * game_name = @"";
    if ([self.dataArray[indexPath.section] isKindOfClass:[Moment class]])
    {
        Moment * moment = self.dataArray[indexPath.section];
        Id = moment.Id;
        game_name =  moment.game_info[@"game_name"];
    }
    else
    {
        Comment * comment = self.dataArray[indexPath.section];
        Id = comment.comment_id;
        game_name = comment.game_info[@"game_name"];
    }
    GameCommitDetailController * detail = [[GameCommitDetailController alloc] init];
    detail.commit_id = Id;
    detail.game_name = game_name;
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

#pragma mark - MomentCellDelegate
// 点击用户头像
- (void)didClickProfile:(MomentCell *)cell
{
    NSLog(@"击用户头像");
    
    GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
    detail.gameID = cell.moment.game_info[@"game_id"];
    [self.navigationController pushViewController:detail animated:YES];
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
    
    linkText = [linkText stringByReplacingOccurrencesOfString:@":" withString:@""];
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
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
    personal.user_id = user_id;
    personal.isHiddenBtn = YES;
    [self.navigationController pushViewController:personal animated:YES];
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
