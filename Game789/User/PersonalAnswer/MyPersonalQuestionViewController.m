//
//  MyPersonalQuestionViewController.m
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyPersonalQuestionViewController.h"
#import "MyAnswerViewController.h"

#import "MyPersonalQuestionCell.h"

#import "MyPersonalQuestionApi.h"

@interface MyPersonalQuestionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyPersonalQuestionViewController

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

- (void)getMyQuestion:(RequestData)block Hud:(BOOL)isShow
{
    MyPersonalQuestionApi * api = [[MyPersonalQuestionApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.user_id = self.user_id;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            if (![request.data[@"list"] isKindOfClass:[NSNull class]])
            {
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * dic in request.data[@"list"])
                {
                    MyGetQuestionModel * model = [[MyGetQuestionModel alloc] initWithDictionary:dic];
                    [array addObject:model];
                }
                self.pageNumber == 1 ? self.dataArray = [NSMutableArray arrayWithArray:array] : [self.dataArray addObjectsFromArray:array];
            }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - hxBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 120;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"my_comment_no_data" titleStr:@"亲，还没有提问记录呢！" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        [self.view addSubview:_tableView];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyPersonalQuestionCell class]) bundle:nil]
         forCellReuseIdentifier:@"MyPersonalQuestionCell"];
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
    NSString * identifier = @"MyPersonalQuestionCell";
    MyPersonalQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.quesModel = self.dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGetQuestionModel * model = self.dataArray[indexPath.section];
    MyAnswerViewController * answer = [MyAnswerViewController new];
    answer.question_id = model.question_id;
    answer.quesModel = model;
    answer.isPersonal = YES;
    [self.navigationController pushViewController:answer animated:YES];
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
        [self getMyQuestion:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getMyQuestion:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
