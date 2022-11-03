//
//  MyGoldExchangeViewController.m
//  Game789
//
//  Created by maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGoldExchangeViewController.h"
#import "MyGoldExchangeCell.h"
#import "GoldMallRequestAPI.h"
#import "GoldExchangeAlertView.h"

@interface MyGoldExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GoldExchangeAlertViewDelegate>

@property(nonatomic,strong) NSArray * dataArray;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * tableViewTop;
@property(nonatomic,strong)IBOutlet UITableViewCell * headerCell;
@property(nonatomic,strong)IBOutlet UILabel * userNameLabel;
@property(nonatomic,strong)IBOutlet UILabel * goldNumberLabel;
@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong)UILabel * numberLabel;
@property(nonatomic,strong)NSMutableArray * gemeListArray;
@property(nonatomic,strong)NSDictionary * selectedGame;

@end

@implementation MyGoldExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBar.title = @"金币兑换".localized;
    self.gemeListArray = [[NSMutableArray alloc] init];
    self.tableViewTop.constant = kStatusBarAndNavigationBarHeight;
    self.dataArray = @[
        @{@"title":@"请选择兑换的游戏",@"placeholder":@"",@"desc":@"兑换比例10:1，不限制游戏类型与金额。需提前在游戏内创建角色。"},
        @{@"title":@"代金券",@"placeholder":@"请输入要兑换代金券的金额",@"desc":@""}
    ];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyGoldExchangeCell" bundle:nil] forCellReuseIdentifier:@"MyGoldExchangeCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.userNameLabel.text = [NSString stringWithFormat:@"账号:%@",self.userInfo[@"username"]];
    self.goldNumberLabel.text = self.userInfo[@"balance"];
    [self loadGameList];
}

/// 加载最近玩过的游戏
- (void)loadGameList{
    [SwpNetworking swpPOST:@"GamesPlayedList" parameters:@{@"member_id":[YYToolModel getUserdefultforKey:USERID]} swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
        NSArray * gameList = resultObject[@"data"][@"list"];
        for (NSDictionary * game in gameList) {
            [self.gemeListArray addObject:game];
        }
    } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
        
    } ShowHud:NO];
}

/// textfield文字改变通知
/// @param notification 通知
- (void)textfieldTextDidChange:(NSNotification *)notification{
    UITextField * textField = notification.object;
    self.numberLabel.text = [NSString stringWithFormat:@"花费金币:%.0f",[textField.text floatValue] * 10];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:self.numberLabel.text];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, string.length)];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF5E00"],NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]} range:NSMakeRange(5, string.length-5)];
    self.numberLabel.attributedText = string;
}

/// 限制textfield小数点后一位
/// @param textField textField
/// @param range range
/// @param string string
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 1;//小数点后需要限制的个数
    for (int i = (int)(futureString.length - 1); i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

/// 立即兑换
/// @param sender 按钮
- (IBAction)exchangeVoucher:(UIButton *)sender{
    if (self.selectedGame == nil) {
        [MBProgressHUD showToast:@"请选择需要兑换的游戏" toView:self.view];
        return;
    }
    NSString * inputGoldNumber = [self.numberLabel.text componentsSeparatedByString:@":"].lastObject;
    if (inputGoldNumber.length == 0) {
        [MBProgressHUD showToast:@"请输入需要兑换代金券的金额" toView:self.view];
        return;
    }
    if ([inputGoldNumber floatValue] > [self.goldNumberLabel.text floatValue]) {
        [MBProgressHUD showToast:@"金币数量不足" toView:self.view];
        return;
    }
    
    [GoldExchangeAlertView showGoldExchangeAlertViewWithNumber:[NSString stringWithFormat:@"%.0f",[inputGoldNumber floatValue]] delegate:self];
    
}

#pragma mark - GoldExchangeAlertViewDelegate

- (void)goldExchangeAlertViewDidEcchange{
    NSString * inputGoldNumber = [self.numberLabel.text componentsSeparatedByString:@":"].lastObject;
    GoldMallRequestAPI * api = [[GoldMallRequestAPI alloc] init];
    api.voucherType = @"2";
    api.gameid = self.selectedGame[@"gameid"];
    api.amount = [NSString stringWithFormat:@"%.1f",[inputGoldNumber floatValue]/10];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary * data = request.data;
            self.goldNumberLabel.text = data[@"balance"];
            [YJProgressHUD showSuccess:@"兑换成功" inview:self.view];
        }else{
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }];
}

/// 游戏选择代理
/// @param textField 输入框
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        [self.view endEditing:YES];
        if (self.gemeListArray.count == 0) {
            [MBProgressHUD showToast:@"暂无可兑换的游戏" toView:self.view];
            return NO;
        }
        NSMutableArray * dataArray = [[NSMutableArray alloc] init];
        for (int i=0;i<self.gemeListArray.count;i++) {
            NSDictionary * obj = self.gemeListArray[i];
            [dataArray addObject:obj[@"name"]];
        }
        [BRStringPickerView showStringPickerWithTitle:@"请选择兑换的游戏" dataSource:dataArray defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue, NSInteger index) {
            self.selectedGame = self.gemeListArray[index];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.headerCell;
    }else{
        MyGoldExchangeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoldExchangeCell" forIndexPath:indexPath];
        NSDictionary * item = self.dataArray[indexPath.row];
        cell.titleLabel.text = item[@"title"];
        cell.textField.placeholder = item[@"placeholder"];
        cell.descLabel.text = item[@"desc"];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row + 10;
        if (indexPath.row == 1) {
            self.numberLabel = cell.numberLabel;
            cell.numberLabel.text = [NSString stringWithFormat:@"花费金币:%@",self.numberLabel.text];
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.textField.delegate = self;
            cell.descImageView.hidden = YES;
        }else{
            cell.numberLabel.text = @"";
            cell.textField.text = self.selectedGame[@"name"];
            cell.descImageView.hidden = NO;
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 52 : 145;
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
