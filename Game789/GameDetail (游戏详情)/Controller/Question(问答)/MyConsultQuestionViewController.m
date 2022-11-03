//
//  MyConsultQuestionViewController.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyConsultQuestionViewController.h"
#import "MyAnswerViewController.h"

#import "MyQuestionAndAnswerCell.h"
#import "MySubmitConsultView.h"
#import "MyAnswerNoticeView.h"

#import "MyGetQuestionApi.h"
#import "MyGetQuestionModel.h"

@interface MyConsultQuestionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *playedGame;
@property (weak, nonatomic) IBOutlet UILabel *questionCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyConsultQuestionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self addData];
    
    [self getQuestionData:nil Hud:YES];
    
    [self loadData];
}

- (void)prepareBasic
{
    self.navBar.title = @"游戏问答";
    self.view.backgroundColor = FontColorF6;
    self.pageNumber = 1;
    
    _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"有问题？问问玩过的人吧！" detailStr:@""];
    _tableView.ly_emptyView.contentView.hidden = YES;
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithImage:[UIImage imageNamed:@"my_task_help1"]];
    self.navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [self.navBar setOnClickRightButton:^{
        MyAnswerNoticeView * noticeView = [[MyAnswerNoticeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [weakSelf.view addSubview:noticeView];
    }];
    
    self.topView_top.constant = kStatusBarAndNavigationBarHeight;
}

- (void)addData
{
    [self.gameIcon sd_setImageWithURL:[NSURL URLWithString:self.gameInfo[@"game_image"][@"thumb"]]];
    
    self.gameName.text = self.gameInfo[@"game_name"];
    
    self.playedGame.text = [NSString stringWithFormat:@"%@%@%@", @"有".localized, self.gameInfo[@"played_count"], @"人玩过该游戏".localized];
    
    self.questionCount.text = [NSString stringWithFormat:@"%@%@%@，%@%@%@", @"共".localized, self.gameInfo[@"question_count"], @"条问题".localized, @"收到".localized, self.gameInfo[@"answer_count"], @"个回答".localized];
    
    BOOL isNameRemark = [YYToolModel isBlankString:self.gameInfo[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", self.gameInfo[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

- (void)getQuestionData:(RequestData)block Hud:(BOOL)isShow
{
    MyGetQuestionApi * api = [[MyGetQuestionApi alloc] init];
    api.gameId = self.gameId;
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
    {
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
            _tableView.ly_emptyView.contentView.hidden = NO;
            
            NSDictionary *dic = request.data[@"paginated"];
            self.hasNextPage = [dic[@"more"] boolValue];
            [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGetQuestionModel * model = self.dataArray[indexPath.row];
    if ([model.answers[@"count"] integerValue] == 0) {
        return 85;
    }else if ([model.answers[@"count"] integerValue] == 1) {
        return 110;
    }
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyQuestionAndAnswerCell";
    MyQuestionAndAnswerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyQuestionAndAnswerCell" owner:self options:nil].firstObject;
    }
    cell.quesModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGetQuestionModel * model = self.dataArray[indexPath.row];
    NSString * user_id = [YYToolModel getUserdefultforKey:USERID];
    BOOL isSelf = NO;
    if ([user_id isEqualToString:model.user_id]) {
        isSelf = YES;
    }
    model.game_name = self.gameInfo[@"game_name"];
    MyAnswerViewController * answer = [MyAnswerViewController new];
    answer.isPersonal = isSelf;
    answer.question_id = model.question_id;
    answer.quesModel = model;
    answer.answerSuccess = ^{
        [self getQuestionData:nil Hud:YES];
    };
    [self.navigationController pushViewController:answer animated:YES];
}

- (IBAction)consultQuestionClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    MySubmitConsultView * consultView = [[MySubmitConsultView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    consultView.playedGameCount = self.gameInfo[@"played_count"];
    consultView.isConsultDetail = NO;
    consultView.gameId = self.gameId;
    consultView.submitText = ^(BOOL isQuestion) {
        [self getQuestionData:nil Hud:YES];
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
        [self getQuestionData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getQuestionData:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

@end
