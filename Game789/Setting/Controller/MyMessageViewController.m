//
//  MyMessageViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "MyMessageViewController.h"
#import "GetSettingNewsMgsList.h"
#import "GetSettingNewsMgsCell.h"
#import "FileUtils.h"
#import "SetReadMgsApi.h"
#import "MessageHeaderView.h"
#import "NoticeDetailViewController.h"
#import "WebViewController.h"
#import "LYEmptyViewHeader.h"
#import "MyShowTextViewController.h"
#import "MyReplyRebateDetailController.h"
#import "MessageTypeViewController.h"
#import "MessageOperateAPI.h"
#import "YHActionSheet.h"
#import "WebViewController.h"
#import "MyChatViewController.h"
#import "SaveMoneyCardViewController.h"
#import "MyBuyVipViewController.h"
#import "ProductDetailsViewController.h"
@interface MyMessageViewController () <UITableViewDelegate,UITableViewDataSource,MessageTypeViewControllerDelegate>

@property (strong, nonatomic) MessageHeaderView * tableHeaderView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MyMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = @"我的消息";

    UIButton * editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(ScreenWidth-60, kStatusBarHeight, 44, 44);
    [editButton setTitle:@"编辑".localized forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editTableView:) forControlEvents:UIControlEventTouchUpInside];
    editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [editButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.navBar addSubview:editButton];
    
    [self getMessageApiRequest:nil Hud:YES];
    [self loadData];
}

- (void)onReadMessageCompletion{
    GetSettingNewsMgsList *api = [[GetSettingNewsMgsList alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = NO;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1){
            self.tableHeaderView.dataDictionary = api.data[@"cate_message"];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)editTableView:(UIButton *)editButton{
    [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消")
        .addActionDefaultTitle(@"一键已读")
        .addActionDefaultTitle(@"一键删除");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [self operationMessageWithOperationType:@"1"];
        }else if(buttonIndex == 2){
            [self operationMessageWithOperationType:@"2"];
        }
        NSLog(@"aaa=%ld",buttonIndex);
    }];
}

/// 一键已读、一键删除
/// @param operate [1: 标记已读, 2: 删除]
- (void)operationMessageWithOperationType:(NSString *)operate{
    MessageOperateAPI * api = [[MessageOperateAPI alloc] init];
    api.isShow = YES;
    api.messageType = @"system";
    api.operateType = operate;
    WEAKSELF
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
        if (operate.integerValue == 1){
            for (GetSettingNewsMgsModel * model in self.dataSource) {
                model.read_tag = @"1";
            }
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
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
- (void)getMessageApiRequest:(RequestData)block Hud:(BOOL)isShow
{
    GetSettingNewsMgsList *api = [[GetSettingNewsMgsList alloc] init];
    api.pageNumber = self.pageNumber;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

- (void)handleNoticeSuccess:(GetSettingNewsMgsList *)api
{
    if (api.success == 1)
    {
        if (self.pageNumber == 1)
        {
            self.dataSource = [NSMutableArray arrayWithArray:[GetSettingNewsMgsModel mj_objectArrayWithKeyValuesArray:api.data[@"system_message"][@"message_list"]]];
        }
        else
        {
            [self.dataSource addObjectsFromArray:[GetSettingNewsMgsModel mj_objectArrayWithKeyValuesArray:api.data[@"system_message"][@"message_list"]]];
        }
        self.tableHeaderView.dataDictionary = api.data[@"cate_message"];
        NSDictionary *dic = api.data[@"system_message"][@"paginated"];
        self.hasNextPage = [dic[@"more"] boolValue];
        [self setFooterViewState:self.tableView Data:dic FooterView:[self creatFooterView]];
        self.tableView.ly_emptyView.contentView.hidden = NO;
        self.tableView.ly_emptyView.contentViewOffset = 100;
        [self.tableView reloadData];
    }else{
        [MBProgressHUD showToast:api.error_desc];
    }
}

#pragma mark - 操作消息
- (void)setMgsRead:(GetSettingNewsMgsModel *)model operate_type:(NSString *)operate_type{
    SetReadMgsApi *api = [[SetReadMgsApi alloc] init];
    WEAKSELF
    if (operate_type.intValue == 2) {
        api.isShow = YES;
    }
    api.pageNumber = self.pageNumber;
    api.message_id = model.message_mixid;
    api.operate_type = operate_type;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
        if (operate_type.integerValue == 1){
            [self getMessageApiRequest:nil Hud:NO];
        }else{
            NSInteger index = [weakSelf.dataSource indexOfObject:model];
            [weakSelf.dataSource removeObjectAtIndex:index];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"GetSettingNewsMgsCell";
    GetSettingNewsMgsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.newsModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GetSettingNewsMgsModel * model = self.dataSource[indexPath.row];
    
    switch (model.message_type.intValue) {
        case 0:
            [self clickPushView:model];
            break;
        case 1:
            [self viewNewsMessage:model];
            break;
        case 2:
        {
            [self jxt_showAlertWithTitle:@"温馨提示" message:model.content appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionCancelTitle(@"取消".localized).
                addActionDefaultTitle(@"领取".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1) {
                    [self receivingGoldCoins:model];
                }
            }];
            break;
        }
        case 3:
            {
                [self pushRebateVc:model];
            }
            break;
        case 4://对话框
            {
                MyChatViewController * chat = [MyChatViewController new];
                chat.message_id = model.message_id;
                [self.navigationController pushViewController:chat animated:YES];
                
                if (model.read_tag.integerValue != 1){
                    [self setMgsRead:model operate_type:@"1"];
                }
            }
            break;
        case 5://会员
            {
                SaveMoneyCardViewController * card = [SaveMoneyCardViewController new];
                card.selectedIndex = 1;
                [self.navigationController pushViewController:card animated:YES];
                
                if (model.read_tag.integerValue != 1){
                    [self setMgsRead:model operate_type:@"1"];
                }
            }
            break;
        case 6://至尊版续费
            {
                MyBuyVipViewController * buy = [[MyBuyVipViewController alloc] init];
                buy.dataDic = @{@"vipSignMenu":model.vipSignMenu, @"supremePayUrl":model.supremePayUrl};
                [self presentViewController:buy animated:YES completion:^{
                    
                }];
                
                if (model.read_tag.integerValue != 1){
                    [self setMgsRead:model operate_type:@"1"];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView){
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

- (void)pushRebateVc:(GetSettingNewsMgsModel *)model{
    //返利
    MyReplyRebateDetailController * detail = [MyReplyRebateDetailController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.rebate_id = model.message_params;
    [self.navigationController pushViewController:detail animated:YES];
    
    if (model.read_tag.integerValue != 1){
        [self setMgsRead:model operate_type:@"1"];
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
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if ([model.link_route isEqualToString:@"trade"]){
            //资讯详情
            ProductDetailsViewController *detailVC = [[ProductDetailsViewController alloc] init];
            detailVC.trade_id = model.link_value;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if ([model.link_route isEqualToString:@"outer_web"]){
            //web 外部
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_value]];
        }
        else
        {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.urlString = model.link_value;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
        if (model.read_tag.integerValue != 1){
            [self setMgsRead:model operate_type:@"1"];
        }
    }
}

- (void)viewNewsMessage:(GetSettingNewsMgsModel *)model{
    MyShowTextViewController * showText = [MyShowTextViewController new];
    showText.showTitle = model.title;
    showText.showTime = model.message_time;
    showText.showContent = model.content;
    [self.navigationController pushViewController:showText animated:YES];
    
    if (model.read_tag.integerValue != 1){
        [self setMgsRead:model operate_type:@"1"];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 23)];
    headerView.clipsToBounds = YES;
    headerView.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, headerView.height)];
    titleLabel.text = @"系统通知";
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self jxt_showAlertWithTitle:@"确定要删除此消息?" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1)
            {
                [self setMgsRead:weakSelf.dataSource[indexPath.row] operate_type:@"2"];
            }
        }];
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除".localized;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (MessageHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[MessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 74*2)];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 95;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GetSettingNewsMgsCell class]) bundle:nil]
         forCellReuseIdentifier:@"GetSettingNewsMgsCell"];
        
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"msg_no_data" titleStr:@"暂无系统消息~" detailStr:@""];
        _tableView.ly_emptyView.contentView.hidden = YES;
    }
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

#pragma mark - 领取金币
- (void)receivingGoldCoins:(GetSettingNewsMgsModel *)model{
    ReceivingGoldCoinsAPI * api = [[ReceivingGoldCoinsAPI alloc] init];
    api.message_params = model.message_params;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
    {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"领取成功" inview:self.view];
            [self setMgsRead:model operate_type:@"1"];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
