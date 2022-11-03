//
//  TradingNoticeViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingNoticeViewController.h"
#import "MyPromptDetailsCell.h"

@interface TradingNoticeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView_y;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsView1_height;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView2_height;

@property (nonatomic, strong) NSArray * dataArray1;
@property (nonatomic, strong) NSArray * dataArray2;

@end

@implementation TradingNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"交易须知";
    self.navBar.titleLabelColor = [UIColor whiteColor];
    self.navBar.barBackgroundColor = [UIColor colorWithHexString:@"#FAA520"];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#FAA520"];
    [self.navBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back-1"]];
    self.navBar.lineView.hidden = YES;
    
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.estimatedRowHeight = 40;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
     [_tableView1 addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.estimatedRowHeight = 40;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView2  addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
    self.scrollView_y.constant = kStatusBarAndNavigationBarHeight;
    
    if (IS_iPhone6_Plus || IS_IPhoneX_All)
    {
        self.tipsView_height.constant = 26.5;
        self.tipsView1_height.constant = 26.5;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_tableView1 removeObserver:self forKeyPath:@"contentSize"];
    [_tableView2 removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGSize size = _tableView1.contentSize;
    self.tableView1_height.constant = size.height;
    
    CGSize size2 = _tableView2.contentSize;
    self.tableView2_height.constant = size2.height;
    
    self.backView_height.constant = CGRectGetMaxY(self.tableView2.frame) + 20;
}


- (NSArray *)dataArray1
{
    if (!_dataArray1)
    {
        _dataArray1 = @[@"角色描述、截图已通过官方核验。因时间因素造成的变化（排行榜、称号、装备到期等），不视为信息失实。",
                             @"交易后角色直接转入您购买所使用的账号，登录游戏即可查收角色。",
                             @"交易过程仅限小号转移，不涉及账号交易或换绑操作，无需担心购买的号被找回。",
                             @"购买时显示累计金额为该小号在该游戏同一小号下多个区服的角色所有累计充值。",
                             @"交易完成后，不支持退货。",
                             @"交易完成的小号超过72小时后才可重新上架交易。",
                             @"所购买的小号不支持转游/转区操作。",
                             @"买家须知：因买家购买过程中操作失误产生的一切损失，由买家自行承担，平台概不负责。"];
    }
    return _dataArray1;
}

- (NSArray *)dataArray2
{
    if (!_dataArray2)
    {
        _dataArray2 = @[@"现金充值满6元才可交易，提交出售申请后，待售小号在游戏中所有区服的角色都将被冻结待售，无法登录。",
                        @"审核不成功或您选择下架商品，可重新登录游戏获得小号。",
                        @"出售时显示累计金额为该小号在该游戏同一小号下多个区服的角色所有累计充值。",
                        @"小号出售成功后，该小号在本游戏中所有区服的角色会一同售出，但不影响该小号在其他游戏中的角色。",
                        @"出售成功将收取5%的手续费（最低5元），剩余收益以平台币形式转至您的账号下。平台币不可提现，仅能用于游戏充值。",
                        @"交易完成后，不支持找回。",
                        @"提交的小号在审核通过之后，若7天之内未完成交易，则自动下架退回。",
                        @"当游戏发布停服公告或游戏问题临时下架后，该游戏的小号不论是否上架都将无法交易，且该游戏已经上架的小号将自动下架。",
                        @"卖家须保证所有提供信息属实，因虚假信息导致的纠纷，由卖家承担责任。",
                        @"卖家须知：因卖家出售过程中操作失误产生的一切损失，由卖家自行承担，平台概不负责。"];
    }
    return _dataArray2;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView1)
    {
        return self.dataArray1.count;
    }
    return self.dataArray2.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyPromptDetailsCell";
    MyPromptDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyPromptDetailsCell" owner:self options:nil].firstObject;
    }
    cell.showContent.text = tableView == self.tableView1 ? [self.dataArray1[indexPath.row] localized] : [self.dataArray2[indexPath.row] localized];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
}

@end
