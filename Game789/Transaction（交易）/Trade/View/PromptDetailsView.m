//
//  PromptDetailsView.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "PromptDetailsView.h"
#import "MyPromptDetailsCell.h"

@implementation PromptDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"PromptDetailsView" owner:self options:nil].firstObject;
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.frame = frame;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 40;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.agreeButton setImage:MYGetImage(@"trading_agress_selected") forState:UIControlStateSelected];
        [self.agreeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    }
    return self;
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    if (IS_iPhone6_Plus || IS_IPhoneX_All)
    {
        self.backView_top.constant = self.backView.y + 10;
        self.indicationImage_height.constant = 25;
    }
    
    if (type.integerValue == 1)
    {
        self.showTitle.text = @"买家必读".localized;
        self.showDetail.text = @"为了您的消费权益，请仔细阅读".localized;
        
        self.processName.text = @"购买流程".localized;
        self.process1.text = @"选择商品".localized;
        self.process2.text = @"购买商品".localized;
        self.process3.text = @"下载游戏".localized;
        self.process4.text = @"登录游戏".localized;
        self.tipName.text = @"买家须知".localized;
        
        self.detailArray = @[@"角色描述、截图已通过官方核验。因时间因素造成的变化（排行榜、称号、装备到期等），不视为信息失实。",
                             @"交易后角色直接转入您购买所使用的账号，登录游戏即可查收角色。",
                             @"交易过程仅限小号转移，不涉及账号交易或换绑操作，无需担心购买的号被找回。",
                             @"购买时显示累计金额为该小号在该游戏同一小号下多个区服的角色所有累计充值。",
                             @"交易完成后，不支持退货。",
                             @"交易完成的小号超过72小时后才可重新上架交易。",
                             @"所购买的小号不支持转游/转区操作。",
                             @"购买的账号再回收仅计算购买后充值的部分",
                             @"买家须知：因买家购买过程中操作失误产生的一切损失，由买家自行承担，平台概不负责。"];
        
        [self.agreeButton setTitle:@"我已阅读".localized forState:0];
        [self.sureButton setTitle:@"确认购买".localized forState:0];
    }
    else if (type.integerValue == 2)
    {
        self.showTitle.text = @"交易细则".localized;
        self.showDetail.text = @"为了您的消费权益，请仔细阅读".localized;
        
        self.processName.text = @"出售流程".localized;
        self.process1.text = @"上传商品".localized;
        self.process2.text = @"审核冻结".localized;
        self.process3.text = @"买家购买".localized;
        self.process4.text = @"出售成功".localized;
        self.tipName.text = @"卖家须知".localized;
        
        self.detailArray = @[
    @"现金充值满6元才可交易，提交出售申请后，待售小号在游戏中所有区服的角色都将被冻结待售，无法登录。",
    @"审核不成功或您选择下架商品，可重新登录游戏获得小号。",
    @"出售时显示累计金额为该小号在该游戏同一小号下多个区服的角色所有累计充值。",
    @"小号出售成功后，该小号在本游戏中所有区服的角色会一同售出，但不影响该小号在其他游戏中的角色。",
    @"出售成功将收取5%的手续费（最低5元），剩余收益以平台币形式转至您的账号下。平台币不可提现，仅能用于游戏充值。",
    @"交易完成后，不支持找回。",
    @"提交的小号在审核通过之后，若7天之内未完成交易，则自动下架退回。",
    @"当游戏发布停服公告或游戏问题临时下架后，该游戏的小号不论是否上架都将无法交易，且该游戏已经上架的小号将自动下架。",
    @"卖家须保证所有提供信息属实，因虚假信息导致的纠纷，由卖家承担责任。",
    @"卖家须知：因卖家出售过程中操作失误产生的一切损失，由卖家自行承担，平台概不负责。"];
        
        [self.agreeButton setTitle:@"我已阅读".localized forState:0];
        [self.sureButton setTitle:@"我记住了".localized forState:0];
    }
    [self.tableView reloadData];
}

#pragma mark TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MyPromptDetailsCell";
    MyPromptDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyPromptDetailsCell" owner:self options:nil].firstObject;
    }
    cell.showContent.text = [self.detailArray[indexPath.row] localized];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"==%ld",(long)indexPath.row);
}

- (IBAction)closeButtonAction:(id)sender
{
    [self dismissAnimation];
}

#pragma mark - 同意阅读
- (IBAction)agreeButtonAction:(id)sender
{
    if (!self.agreeButton.selected)
    {
        self.agreeButton.selected = YES;
        self.sureButton.backgroundColor = MAIN_COLOR;
//        [self.sureButton gradientButtonWithSize:self.sureButton.frame.size colorArray:@[(id)MYColor(255, 138, 28), (id)MYColor(255, 205, 90)] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        self.sureButton.enabled = YES;
    }
    else
    {
        self.agreeButton.selected = NO;
        self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#DEDEEA"];
//        [self.sureButton gradientButtonWithSize:self.sureButton.frame.size colorArray:@[(id)[UIColor colorWithHexString:@"#DEDEEA"], (id)[UIColor colorWithHexString:@"#DEDEEA"]] percentageArray:@[@(0.5),@(0.5)] gradientType:GradientFromLeftTopToRightBottom];
        self.sureButton.enabled = NO;
    }
}

#pragma mark - 确定
- (IBAction)sureButtonAction:(id)sender
{
    self.agree(YES);
    [self dismissAnimation];
}

@end
