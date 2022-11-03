//
//  MyReplyRebateDetailController.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyReplyRebateDetailController.h"
#import "MySubmitReplyReabteController.h"
#import "MyCustomerServiceController.h"

#import "MyRebateDetailGiftCodeCell.h"
#import "MyReplyRebateCodeFooterView.h"

#import "ReturnDetailApi.h"

@interface MyReplyRebateDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *bottomNotice;
@property (nonatomic,strong) MyReplyRebateCodeFooterView *footerView;

@end

@implementation MyReplyRebateDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"申请详情";
    self.navBar.titleLabelColor = UIColor.whiteColor;
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = YES;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    self.containerView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
         _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self listDetailRequest];
}

- (void)listDetailRequest
{
    ReturnDetailApi *api = [[ReturnDetailApi alloc] init];
    api.isShow = YES;
    api.rebateid = self.rebate_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.containerView.hidden = NO;
        [self handleReturnGuideApiListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleReturnGuideApiListSuccess:(ReturnDetailApi *)api {
    if (api.success == 1)
    {
        if (![api.data isKindOfClass:[NSNull class]])
        {
            [self updataData:api.data];
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)updataData:(NSDictionary *)dic
{
    self.dataDic = dic;
    
    self.gameName.text = dic[@"game_name"];
    
    self.showAccount.text = dic[@"game_account"];
    
    self.showTime.text = [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dic[@"recharge_time"] doubleValue]];
    
    self.showService.text = dic[@"server_name"];
    
    self.showRoleName.text = dic[@"role_name"];
    
    self.showRoleId.text = dic[@"role_id"];
    
    self.showMark.text = dic[@"handle_remark"];
    
    self.showMoney.text = dic[@"recharge_amount"];
    
    if ([dic[@"handle_time"] doubleValue] > 0)
    {
        self.handleTime.text = [NSDate dateWithFormat:@"yyyy-MM-dd HH:mm" WithTS:[dic[@"handle_time"] doubleValue]];
    }
    
    if ([dic[@"status"] integerValue] == -1)
    {
        self.submitBtn_width.constant = (kScreenW - 15 * 3) / 2;
    }
    else
    {
        self.submitBtn.hidden = YES;
        self.submitBtn_left.constant = 0;
        self.submitBtn_width.constant = 0;
    }
    
    NSArray * array = dic[@"codes"];
    if ([array count] > 0)
    {
        NSInteger count = array.count > 3 ? (3 + 1) : array.count;
        self.tableView_height.constant = count * 40;
        self.tableView_top.constant = 10;
        [self.tableView reloadData];
        self.tableView.tableFooterView = array.count > 3 ? self.footerView : [UIView new];
    }
    else
    {
        self.codeTitle_top.constant = 0;
        self.codeTitle.hidden = YES;
        self.tableView_height.constant = 0;
        self.tableView_top.constant = 0;
    }
    
    [self.containerView layoutIfNeeded];
    self.containerView_height.constant = CGRectGetMaxY(self.bottomNotice.frame) + 20;
    self.scrollView.contentSize = CGSizeMake(kScreenW, CGRectGetMaxY(self.bottomNotice.frame) + 20);
}

- (MyReplyRebateCodeFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[MyReplyRebateCodeFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
        _footerView.dataArray = self.dataDic[@"codes"];
    }
    return _footerView;
}

- (IBAction)contactServiceBtnClick:(id)sender
{
    MyCustomerServiceController *webVC = [[MyCustomerServiceController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)submitBtnClick:(id)sender
{
    MySubmitReplyReabteController * submit = [MySubmitReplyReabteController new];
    submit.detailDic = self.dataDic;
    [self.navigationController pushViewController:submit animated:YES];
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.dataDic[@"codes"] count];
    return count > 3 ? 3 : count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyRebateDetailGiftCodeCell";
    MyRebateDetailGiftCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyRebateDetailGiftCodeCell" owner:self options:nil].firstObject;
    }
    cell.showCode.text = self.dataDic[@"codes"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld", (long)indexPath.row);
    
}

@end
