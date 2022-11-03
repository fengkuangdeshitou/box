//
//  MyAnswerViewController.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyAnswerViewController.h"

#import "MyAnswerTableViewCell.h"
#import "MyAnswerHeaderView.h"
#import "MyAnswerNoticeView.h"
#import "MySubmitConsultView.h"

#import "MyGetQuestionApi.h"

@interface MyAnswerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomIcon;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_height;
@property (nonatomic, strong) MyAnswerHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyAnswerViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getAnswerData:nil Hud:YES];
    
    [self loadData];
}

- (void)prepareBasic
{
    self.navBar.title = self.quesModel.game_name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNumber = 1;
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithImage:[UIImage imageNamed:@"my_task_help1"]];
    self.navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [self.navBar setOnClickRightButton:^{
        MyAnswerNoticeView * noticeView = [[MyAnswerNoticeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [weakSelf.view addSubview:noticeView];
    }];
    [self.view addSubview:self.tableView];
    
    if (self.quesModel.played.integerValue == 1)
    {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerQuestionAction)];
        [self.bottomView addGestureRecognizer:tap];
        
        self.bottomText.text = @"这个游戏我玩过，我来说说！";
        self.bottomIcon.image = MYGetImage(@"lhh_home_pen");
    }
    
    //从个人中心点击或者当前发表的问题为自己
    if (self.isPersonal)
    {
        self.backView_height = 0;
        self.backView.hidden = YES;
    }
}

- (void)getAnswerData:(RequestData)block Hud:(BOOL)isShow
{
    MyGetAnswerApi * api = [[MyGetAnswerApi alloc] init];
    api.questionId = self.question_id;
    api.pageNumber = self.pageNumber;
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
            self.headerView.showCount.text = request.data[@"paginated"][@"total"];
            [self.tableView reloadData];
            _tableView.ly_emptyView.contentView.hidden = NO;
            
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
        CGFloat bottomView_height = self.isPersonal ? 0 : 50;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH  - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin - bottomView_height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"等待大神回复中..." detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
        _tableView.backgroundColor = UIColor.whiteColor;
        
        MyAnswerHeaderView * headerView = [[MyAnswerHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 151)];
        self.headerView = headerView;
        headerView.quesModel = self.quesModel;
        headerView.currentView = self;
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyAnswerTableViewCell";
    MyAnswerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyAnswerTableViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.answerModel = self.dataArray[indexPath.row];
    cell.currentView = self;
    return cell;
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

- (void)answerQuestionAction
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    
    MySubmitConsultView * consultView = [[MySubmitConsultView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    consultView.isConsultDetail = YES;
    consultView.questionId = self.question_id;
    consultView.submitText = ^(BOOL isQuestion) {
        [self getAnswerData:nil Hud:YES];
        self.answerSuccess();
    };
    [self.view addSubview:consultView];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getAnswerData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getAnswerData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
