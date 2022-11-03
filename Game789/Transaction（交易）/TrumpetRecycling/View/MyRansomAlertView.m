//
//  MyRansomAlertView.m
//  Game789
//
//  Created by yangyongMac on 2020/2/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRansomAlertView.h"
#import "MyPromptDetailsCell.h"

@implementation MyRansomAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyRansomAlertView" owner:self options:nil].firstObject;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.frame = frame;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 40;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.agreeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    }
    return self;
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    if (type.integerValue == 1)
    {
        self.showTitle.text = @"确认回收小号".localized;
//        self.showDetail.text = @"为了您的消费权益，请仔细阅读".localized;
        self.tipName.text = @"回收须知".localized;
        
        _detailArray = @[@"累计充值满100元以上小号，可按实际充值5%金额回收金币。".localized,
               @"回收后72小时内可赎回，逾期不可赎回。".localized,
          @"赎回小号仅支持现金赎回，需额外支付该小号充值金额的3%作为赎回手续费；赎回后可直接选择相应的小号登录游戏！（例：若小号充值满100元，回收后获得50金币。若用户需要赎回，则需支付5+3=8元）。".localized,
         @"游戏关服超过3个月的游戏不支持回收功能，例：9月13日关服，最迟回收日期为12月13日，超过日期后将不可回收。".localized,
        @"充值仅计算2019年6月1日后小号实际充值部分（金币与免费代金券充值不计算在内）。".localized,
             @"如有任何疑问，可联系客服咨询!".localized];
        
        [self.agreeButton setTitle:@"我已阅读".localized forState:0];
        [self.sureButton setTitle:@"确认回收".localized forState:0];
    }
    else if (type.integerValue == 2)
    {
        self.showTitle.text = @"确认赎回小号".localized;
//        self.showDetail.text = @"为了您的消费权益，请仔细阅读".localized;
        
        self.tipName.text = @"赎回须知".localized;
        
        _detailArray = @[@"回收后72小时内可赎回，逾期不可赎回。".localized,
          @"赎回小号仅支持现金赎回，需额外支付该小号充值金额的3%作为赎回手续费；赎回后可直接选择相应的小号登录游戏！（例：若小号充值满100元，回收后获得50金币。若用户需要赎回，则需支付5+3=8元）。".localized,
             @"如有任何疑问，可联系客服咨询!".localized];
        
        [self.agreeButton setTitle:@"我已阅读".localized forState:0];
        [self.sureButton setTitle:@"确认赎回".localized forState:0];
        
        self.tableView_height.constant = 150;
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
    if(!cell)
    {
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
    [self removeFromSuperview];
}

#pragma mark - 同意阅读
- (IBAction)agreeButtonAction:(id)sender
{
    if (!self.agreeButton.selected)
    {
        self.agreeButton.selected = YES;
//        [self.sureButton gradientButtonWithSize:self.sureButton.frame.size colorArray:@[(id)MYColor(255, 138, 28), (id)MYColor(255, 205, 90)] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        self.sureButton.backgroundColor = MAIN_COLOR;
    }
    else
    {
        self.agreeButton.selected = NO;
//        [self.sureButton gradientButtonWithSize:self.sureButton.frame.size colorArray:@[(id)[UIColor colorWithHexString:@"#DEDEEA"], (id)[UIColor colorWithHexString:@"#DEDEEA"]] percentageArray:@[@(0.5),@(0.5)] gradientType:GradientFromLeftTopToRightBottom];
        self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#DEDEEA"];
    }
}

#pragma mark - 确定
- (IBAction)sureButtonAction:(id)sender
{
    if (self.agreeButton.selected)
    {
        self.agree(YES);
        [self removeFromSuperview];
    }
    else
    {
        [MBProgressHUD showToast:@"请先选择同意“我已阅读”"];
    }
}

- (IBAction)cancleButtonAction:(id)sender
{
    [self removeFromSuperview];
}

@end
