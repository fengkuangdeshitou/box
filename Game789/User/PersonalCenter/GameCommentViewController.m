//
//  GameCommentViewController.m
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameCommentViewController.h"
#import "GameCommentCell.h"
#import "GameCommentAPI.h"
#import "HGCommunityDetailVC.h"
#import "GameTopicCell.h"

@interface GameCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation GameCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    GameCommentAPI * api = [[GameCommentAPI alloc] init];
    api.user_id = self.user_id;
    api.type = self.type;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"list"])
            {
                Comment * comment = [[Comment alloc] initWithDictionary:dic];
                    [array addObject:comment];
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
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_comment_no_data" titleStr:@"您还没发表过点评哦" detailStr:@""];
        self.tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 100;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"topic"])
    {
        static NSString * identifier = @"GameTopicCell";
        GameTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameTopicCell" owner:self options:nil].firstObject;
        }
        cell.cellHeightChangeBlock = ^{
            [UIView performWithoutAnimation:^{
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
    else
    {
        static NSString * identifier = @"GameCommentCell";
        GameCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameCommentCell" owner:self options:nil].firstObject;
        }
        Comment * model = self.dataArray[indexPath.section];
        model.type = self.type;
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment * model = self.dataArray[indexPath.section];
    HGCommunityDetailVC * detail = [[HGCommunityDetailVC alloc] init];
    if ([self.type isEqualToString:@"topic"]) {
        detail.commit_id = model.Id;
    }else{
        detail.commit_id = model.foruminviteid;
    }
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
- (void)didClickProfile:(GameCommentCell *)cell
{
    NSLog(@"击用户头像");
    
    GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
//    detail.gameID = cell.moment.game_info[@"game_id"];
    [self.navigationController pushViewController:detail animated:YES];
}

// 查看全文/收起
- (void)didSelectFullText:(GameCommentCell *)cell
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
//    UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
//    personal.user_id = user_id;
//    personal.isHiddenBtn = YES;
//    [self.navigationController pushViewController:personal animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
