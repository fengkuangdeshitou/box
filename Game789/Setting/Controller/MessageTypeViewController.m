//
//  MessageTypeViewController.m
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MessageTypeViewController.h"
#import "MessageCell.h"
#import "GetMgsListApi.h"
#import "SetReadMgsApi.h"
#import "GetSettingNewsMgsList.h"
#import "NoticeDetailViewController.h"
#import "MyShowTextViewController.h"
#import "MyReplyRebateDetailController.h"
#import "MessageOperateAPI.h"
#import "UserPersonalCenterController.h"
#import "HGCommunityDetailVC.h"
#import "GameCommitDetailController.h"
#import "MyAnswerViewController.h"

@interface MessageTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy , nonatomic) NSString * type;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MessageTypeViewController

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (instancetype)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.title = self.title;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCell class]) bundle:nil]
     forCellReuseIdentifier:@"MessageCell"];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"msg_no_data" titleStr:[NSString stringWithFormat:@"暂无%@~",self.title] detailStr:@""];
    self.tableView.ly_emptyView.contentView.hidden = YES;
    [self getMessageApiRequest:nil Hud:YES];
    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(ScreenWidth-60, kStatusBarHeight, 44, 44);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editTableView:) forControlEvents:UIControlEventTouchUpInside];
    editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [editButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.navBar addSubview:editButton];
    [self loadData];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getMessageApiRequest:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;

    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getMessageApiRequest:^(BOOL isSuccess) {
            [tableView.mj_footer endRefreshing];
        } Hud:NO];
    }];
}

#pragma mark - 获取消息列表
- (void)getMessageApiRequest:(RequestData)block Hud:(BOOL)isShow{
    GetMgsListApi *api = [[GetMgsListApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    api.messageType = self.type;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(GetMgsListApi *)api{
    if (api.success == 1){
        if (self.pageNumber == 1){
            self.dataSource = [NSMutableArray arrayWithArray:[GetSettingNewsMgsModel mj_objectArrayWithKeyValuesArray:api.data[@"message_list"]]];
        }else{
            [self.dataSource addObjectsFromArray:[GetSettingNewsMgsModel mj_objectArrayWithKeyValuesArray:api.data[@"message_list"]]];
        }
        NSDictionary *dic = api.data[@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        self.tableView.ly_emptyView.contentView.hidden = NO;
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showToast:api.error_desc];
    }
}

// 批量操作消息
- (void)editTableView:(UIButton *)editButton{
    [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消")
        .addActionDefaultTitle(@"一键已读")
        .addActionDefaultTitle(@"一键删除");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [self operationMessageWithType:self.type operationType:@"1"];
        }else if(buttonIndex == 2){
            [self operationMessageWithType:self.type operationType:@"2"];
        }
    }];
}

/// 一键已读、一键删除
/// @param type [‘system’, ‘comment’ , ‘qa’ , ‘topic’]
/// @param operate [1: 标记已读, 2: 删除]
- (void)operationMessageWithType:(NSString *)type operationType:(NSString *)operate{
    MessageOperateAPI * api = [[MessageOperateAPI alloc] init];
    api.isShow = YES;
    api.messageType = type;
    api.operateType = operate;
    WEAKSELF
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
        if (operate.integerValue == 1){
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReadMessageCompletion)]) {
                [self.delegate onReadMessageCompletion];
            }
            for (GetSettingNewsMgsModel * model in self.dataSource) {
                model.read_tag = @"1";
            }
            [weakSelf.tableView reloadData];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReadMessageCompletion)]) {
                [self.delegate onReadMessageCompletion];
            }
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    GetSettingNewsMgsModel * model = self.dataSource[indexPath.row];
    model.type = self.type;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetSettingNewsMgsModel * model = self.dataSource[indexPath.row];
    if (model.read_tag.integerValue != 1){
        [self setMgsRead:model operate_type:@"1"];
    }
    NSInteger messageType = model.message_type.integerValue;
    if (messageType > 3 && messageType < 8) {
        [self clickPushView:model];
    }else if(messageType == 1){
        [self viewNewsMessage:model];
    }else if(messageType == 2){
        [self jxt_showAlertWithTitle:@"温馨提示" message:model.content appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消".localized).
            addActionDefaultTitle(@"领取".localized);
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1) {
                [self receivingGoldCoins:model];
            }
        }];
    }else if(messageType == 3){
        [self pushRebateVc:model];
    }else if(messageType >= 11 && messageType <= 16){
        HGCommunityDetailVC * detail = [HGCommunityDetailVC new];
        detail.commit_id = model.link_value;
        [self.navigationController pushViewController:detail animated:YES];
    }else if(messageType == 8 || messageType == 9){
        GameCommitDetailController * detail = [GameCommitDetailController new];
        detail.commit_id = model.link_value;
        detail.game_name = model.game_name;
        [self.navigationController pushViewController:detail animated:YES];
    }else if(messageType == 10){
        MyAnswerViewController * answer = [MyAnswerViewController new];
        answer.question_id = model.link_value;
        answer.quesModel = [MyGetQuestionModel mj_objectWithKeyValues:[model mj_keyValues]];
        answer.answerSuccess = ^{
            
        };
        [self.navigationController pushViewController:answer animated:YES];
    }
}

- (void)clickPushView:(GetSettingNewsMgsModel *)model{
    if ([YYToolModel isBlankString:model.link_value]){
        return;
    }else{
        if ([model.link_route isEqualToString:@"game_info"]){
            //游戏详情
            GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
            detailVC.gameID = model.link_value;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if ([model.link_route isEqualToString:@"news_info"]){
            //资讯详情
            NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
            detailVC.news_id = model.link_value;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if ([model.link_route isEqualToString:@"outer_web"]){
            //web 外部
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_value]];
        }else{
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.urlString = model.link_value;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (void)viewNewsMessage:(GetSettingNewsMgsModel *)model{
    MyShowTextViewController * showText = [MyShowTextViewController new];
    showText.showTitle = model.title;
    showText.showTime = model.message_time;
    showText.showContent = model.content;
    [self.navigationController pushViewController:showText animated:YES];
}

#pragma mark - 领取金币
- (void)receivingGoldCoins:(GetSettingNewsMgsModel *)model{
    ReceivingGoldCoinsAPI * api = [[ReceivingGoldCoinsAPI alloc] init];
    api.message_params = model.message_params;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request){
        if (request.success == 1){
            [YJProgressHUD showSuccess:@"领取成功" inview:self.view];
            [self setMgsRead:model operate_type:@"1"];
        }else{
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)pushRebateVc:(GetSettingNewsMgsModel *)model{
    //返利
    MyReplyRebateDetailController * detail = [MyReplyRebateDetailController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.rebate_id = model.message_params;
    [self.navigationController pushViewController:detail animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除".localized;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    [self jxt_showAlertWithTitle:@"确定要删除此消息?" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1)
        {
            [self setMgsRead:weakSelf.dataSource[indexPath.row] operate_type:@"2"];
        }
    }];
}

#pragma mark - 操作消息
- (void)setMgsRead:(GetSettingNewsMgsModel *)model operate_type:(NSString *)operate_type
{
    SetReadMgsApi *api = [[SetReadMgsApi alloc] init];
    WEAKSELF
    api.isShow = NO;
    api.pageNumber = self.pageNumber;
    api.message_id = model.message_mixid;
    api.operate_type = operate_type;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
        NSInteger index = [weakSelf.dataSource indexOfObject:model];
        if (operate_type.integerValue == 1){
            model.read_tag = @"1";
            if (self.delegate && [self.delegate respondsToSelector:@selector(onReadMessageCompletion)]) {
                [self.delegate onReadMessageCompletion];
            }
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            if (model.read_tag.integerValue != 1) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(onReadMessageCompletion)]) {
                    [self.delegate onReadMessageCompletion];
                }
            }
            [weakSelf.dataSource removeObjectAtIndex:index];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
