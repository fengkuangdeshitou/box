//
//  ExclusiveContentViewController.m
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "ExclusiveContentViewController.h"
#import "ExclusiveImageTableViewCell.h"
#import "ExclusiveTableViewCell.h"
#import "SecureViewController.h"
#import "ModifyNameViewController.h"
#import "AuthAlertView.h"
#import "MyAttentionAlertView.h"
#import "BindVerifyViewController.h"
#import "MyTaskCenterApi.h"
#import "ExclusiveAPI.h"
#import "MyUserReturnGamesView.h"

@interface ExclusiveContentViewController ()<UITableViewDelegate,AuthAlertViewDelegate>

@property(nonatomic,strong)NSArray * firstArray;
@property(nonatomic,strong)NSArray * secondArray;
@property(nonatomic,strong)NSArray * thirdArray;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger day;
@property(nonatomic,copy)NSString * pack_ids;


@end

@implementation ExclusiveContentViewController

- (NSArray *)firstArray{
    return @[
             @{@"title":@"设置头像",@"desc":@"5金币",@"image":@"header0",@"bgc1":@"#DDEBFF",@"bgc2":@"#D8E0FF",@"rec1":@"#559CFF",@"rec2":@"#3A62FF",@"tc":@"#352CCC",@"dc":@"#726BF7"},
             @{@"title":@"设置昵称",@"desc":@"5金币",@"image":@"header1",@"bgc1":@"#E5E2FF",@"bgc2":@"#ECE9FD",@"rec1":@"#A191F4",@"rec2":@"#7E6EFF",@"tc":@"#5140D5",@"dc":@"#8477E8"},
             @{@"title":@"绑定手机",@"desc":@"5金币",@"image":@"header2",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"},
             @{@"title":@"实名认证",@"desc":@"25金币",@"image":@"header3",@"bgc1":@"#FEE9E5",@"bgc2":@"#FFE3E5",@"rec1":@"#FB775E",@"rec2":@"#FF505B",@"tc":@"#680E0E",@"dc":@"#B05F5F"},
             @  {@"title":self.model[@"day1_info"][@"douyin"]?@"关注抖音号":@"畅玩任一游戏",@"desc":@"10金币",@"image":@"header4",@"bgc1":@"#E4DBEE",@"bgc2":@"#E2DAF0",@"rec1":@"#9C50E6",@"rec2":@"#7218C9",@"tc":@"#5F209E",@"dc":@"#A073CB"},
             @{@"title":@"关注公众号",@"desc":@"10金币",@"image":@"header5",@"bgc1":@"#F1F7D6",@"bgc2":@"#E1EEDF",@"rec1":@"#70CC03",@"rec2":@"#449437",@"tc":@"#174B0B",@"dc":@"#5B7C54"},
    ];
}

- (NSArray *)secondArray{
    return @[
        @{@"title":@"签到",@"desc":@"6元代金券 满30元可用",@"image":@"header2",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"},
        @{@"title":@"登录游戏",@"desc":@"10元代金券 满98元可用",@"image":@"header2",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"},
        @{@"title":@"累计充值1元",@"desc":@"20元代金券 满128元可用",@"image":@"header6",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"}
    ];
}

- (NSArray *)thirdArray{
    return @[
             @{@"title":@"签到",@"desc":@"10元代金券 满30元可用",@"image":@"header2",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"},
             @{@"title":@"登录游戏",@"desc":@"20元代金券 满98元可用",@"image":@"header2",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"},
             @{@"title":@"累计充值10元",@"desc":@"30元代金券 满198元可用",@"image":@"header6",@"bgc1":@"#FFF2D7",@"bgc2":@"#FFE7AE",@"rec1":@"#FFD334",@"rec2":@"#F59A02",@"tc":@"#664508",@"dc":@"#A27A30"}
    ];
}

- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.index = self.view.tag-10;
    self.day = [model[@"day"] intValue]-1;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ExclusiveImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExclusiveImageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExclusiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExclusiveTableViewCell"];
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
//    self.tableView.contentInsetAdjustmentBehavior = 2;
}

- (NSArray *)getDataArray{
    return self.index == 0 ? self.firstArray : (self.index == 1 ? self.secondArray : self.thirdArray);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ExclusiveImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExclusiveImageTableViewCell" forIndexPath:indexPath];
        cell.number.text = self.index == 1 ? @"3元无门槛券" : @"6元无门槛券";
        cell.desc.text = self.index == 1 ? @"游戏充值直接抵扣3元  畅玩无忧" : @"游戏充值直接抵扣6元  畅玩无忧";
        if (self.index == 0) {
            cell.imageView.image = [UIImage imageNamed:[self.model[@"day1_info"][@"gift"] intValue] == 2 ? @"648充值卡2" : @"648充值卡"];
            cell.receiveView.hidden = true;
        }else if (self.index == 1){
            cell.receiveView.hidden = false;
            if (self.index > self.day) {
                [cell.action setImage:[UIImage imageNamed:@"未开始"] forState:UIControlStateNormal];
            }else{
                [cell.action setImage:[UIImage imageNamed:[self.model[@"day2_info"][@"balance"] intValue] == 1 ? @"receive" : @"noreceive"] forState:UIControlStateNormal];
            }
        }else{
            cell.receiveView.hidden = false;
            if (self.index > self.day) {
                [cell.action setImage:[UIImage imageNamed:@"未开始"] forState:UIControlStateNormal];
            }else{
                [cell.action setImage:[UIImage imageNamed:[self.model[@"day3_info"][@"balance"] intValue] == 1 ? @"receive" : @"noreceive"] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else{
        ExclusiveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExclusiveTableViewCell" forIndexPath:indexPath];
        cell.model = [self getDataArray][indexPath.row];
        if (indexPath.row == ([self getDataArray].count-1)) {
            cell.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
            cell.layer.cornerRadius = 5;
            cell.clipsToBounds = true;
        }else{
            cell.layer.cornerRadius = 0;
        }
        if (self.index == 0) {
            NSDictionary * item = self.model[@"day1_info"];
            if (indexPath.row == 0) {
                [self setTitleWithValue:[item[@"avatar"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 1){
                [self setTitleWithValue:[item[@"nickname"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 2){
                [self setTitleWithValue:[item[@"mobile"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 3){
                [self setTitleWithValue:[item[@"authentication"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 4){
                if (item[@"douyin"]) {
                    [self setTitleWithValue:[item[@"douyin"] intValue] forButton:cell.actionButton];
                }else{
                    [self setTitleWithValue:[item[@"login_game"] intValue] forButton:cell.actionButton];
                }
            }else if(indexPath.row == 5){
                [self setTitleWithValue:[item[@"weixin"] intValue] forButton:cell.actionButton];
                cell.hidden = [item[@"tipswx"] isBlankString];
            }
        }else if(self.index == 1){
            NSDictionary * item = self.model[@"day2_info"];
            if (indexPath.row == 0) {
                [self setTitleWithValue:[item[@"sign"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 1){
                [self setTitleWithValue:[item[@"login_game"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 2){
                [self setTitleWithValue:[item[@"recharge"] intValue] forButton:cell.actionButton];
            }
        }else if(self.index == 2){
            NSDictionary * item = self.model[@"day3_info"];
            if (indexPath.row == 0) {
                [self setTitleWithValue:[item[@"sign"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 1){
                [self setTitleWithValue:[item[@"login_game"] intValue] forButton:cell.actionButton];
            }else if(indexPath.row == 2){
                [self setTitleWithValue:[item[@"recharge"] intValue] forButton:cell.actionButton];
            }
            NSLog(@"title=%@",cell.actionButton.titleLabel.text);
        }
        [cell.actionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)buttonAction:(UIButton *)btn{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    if (self.index > self.day) {
        [MBProgressHUD showToast:@"活动未开始" toView:self.view];
        return;
    }
    NSString * title = btn.titleLabel.text;
    if ([title isEqualToString:@"已完成"]) {
        return;
    }
    ExclusiveTableViewCell * cell = (ExclusiveTableViewCell *)[[[btn superview] superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UIViewController * vc = [YYToolModel getCurrentVC];
    if (self.index == 0) {
        NSArray * typeArray = @[@"avatar",@"nickname",@"mobile",@"authentication",@"playGame",@"weixin"];
        if (indexPath.row == 0) {
            if ([title isEqualToString:@"去完成"]) {
                SecureViewController * secure = [SecureViewController new];
                secure.hidesBottomBarWhenPushed = YES;
                [vc.navigationController pushViewController:secure animated:YES];
            }else{
                [self receiceRequest:typeArray[indexPath.row]];
            }
        }else if (indexPath.row == 1) {
            if ([title isEqualToString:@"去完成"]) {
                ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
                bindVC.title = @"昵称".localized;
                bindVC.hidesBottomBarWhenPushed = YES;
                [vc.navigationController pushViewController:bindVC animated:YES];
            }else{
                [self receiceRequest:typeArray[indexPath.row]];
            }
        }else if (indexPath.row == 2) {
            if ([title isEqualToString:@"去完成"]) {
                [self pushBindMobileVC:vc];
            }else{
                [self receiceRequest:typeArray[indexPath.row]];
            }
        }else if (indexPath.row == 3) {
            if ([title isEqualToString:@"去完成"]) {
                [AuthAlertView showAuthAlertViewWithDelegate:self];
            }else{
                [self receiceRequest:typeArray[indexPath.row]];
            }
        }else if (indexPath.row == 4) {
            if (self.model[@"day1_info"][@"douyin"]) {
                if ([title isEqualToString:@"去完成"]) {
                    [NSUserDefaults.standardUserDefaults setValue:self.model[@"day1_info"][@"tips"] forKey:@"douyin-tips"];
                    [self showAttentionView:false];
                }else{
                    [self receiceRequest:@"douyin"];
                }
            }else{
                [NSUserDefaults.standardUserDefaults removeObjectForKey:@"douyin-tips"];
                if ([title isEqualToString:@"去完成"]) {
                    [vc jxt_showAlertWithTitle:@"温馨提示" message:@"畅玩任何一款游戏均可领取金币" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                        alertMaker.addActionCancelTitle(@"知道了");
                    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                        
                    }];
                }else{
                    [self receiceRequest:typeArray[indexPath.row]];
                }
            }
        }else if (indexPath.row == 5) {
            if ([title isEqualToString:@"去完成"]) {
                [self showAttentionView:YES];
            }else{
                [self receiceRequest:typeArray[indexPath.row]];
            }
        }
    }else if(self.index == 1){
        if (indexPath.row == 0) {
            if ([title isEqualToString:@"去完成"]) {
                MyTaskViewController * task = [[MyTaskViewController alloc] init];
                [vc.navigationController pushViewController:task animated:true];
            }else{
                [self excusiveReceiveWithType:@"3"];
            }
        }else if (indexPath.row == 1) {
            if ([title isEqualToString:@"去完成"]) {
                [self showTipView:@"畅玩任何一款游戏均可领取金币"];
            }else{
                [self excusiveReceiveWithType:@"4"];
            }
        }else if (indexPath.row == 2) {
            if ([title isEqualToString:@"去完成"]) {
                [self showTipView:@"仅计算现金/平台币充值游戏"];
            }else{
                [self excusiveReceiveWithType:@"5"];
            }
        }
    }else{
        if (indexPath.row == 0) {
            if ([title isEqualToString:@"去完成"]) {
                MyTaskViewController * task = [[MyTaskViewController alloc] init];
                [vc.navigationController pushViewController:task animated:true];
            }else{
                [self excusiveReceiveWithType:@"7"];
            }
        }else if (indexPath.row == 1) {
            if ([title isEqualToString:@"去完成"]) {
                [self showTipView:@"畅玩任何一款游戏均可领取金币"];
            }else{
                [self excusiveReceiveWithType:@"8"];
            }
        }else if (indexPath.row == 2) {
            if ([title isEqualToString:@"去完成"]) {
                [self showTipView:@"仅计算现金/平台币充值游戏"];
            }else{
                [self excusiveReceiveWithType:@"9"];
            }
        }
    }
}

- (void)showTipView:(NSString *)string
{
    UIViewController * vc = [YYToolModel getCurrentVC];
    [vc jxt_showAlertWithTitle:@"温馨提示" message:string appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"知道了");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (![YYToolModel isAlreadyLogin]) {
            return;
        }
        if (self.index > self.day) {
            [MBProgressHUD showToast:@"活动未开始" toView:self.view];
            return;
        }
        if (self.index == 0 && [self.model[@"day1_info"][@"gift"] intValue] == 1) {
            MyUserReturnGamesView * gameView = [[MyUserReturnGamesView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            typeof(gameView) __weak weakView = gameView;
            weakView.newExclusive = true;
            gameView.dataArray = [MyUserReturnGamesModel mj_objectArrayWithKeyValuesArray:self.model[@"gift_list"]];
            [UIApplication.sharedApplication.keyWindow addSubview:gameView];
            gameView.receivedSuccess = ^(NSString * _Nonnull pack_ids) {
                self.pack_ids = pack_ids;
                [weakView removeFromSuperview];
                [self excusiveReceiveWithType:@"1"];
            };
        }else if (self.index == 1 && [self.model[@"day2_info"][@"balance"] intValue] == 1){
            [self excusiveReceiveWithType:@"2"];
        }else if (self.index == 2 && [self.model[@"day3_info"][@"balance"] intValue] == 1){
            [self excusiveReceiveWithType:@"6"];
        }
    }
}

- (void)onAuthSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exclusiveReceiveSuccess" object:nil];
}

- (void)excusiveReceiveWithType:(NSString *)type{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    ExclusiveReceiveAPI * api = [[ExclusiveReceiveAPI alloc] init];
    api.type1 = type;
    api.isShow = true;
    if ([type isEqualToString:@"1"]) {
        api.pack_ids = self.pack_ids;
    }
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            [YJProgressHUD showSuccess:@"领取成功" inview:[UIApplication sharedApplication].keyWindow];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exclusiveReceiveSuccess" object:nil];
        }else{
            [MBProgressHUD showToast:request.error_desc toView:[UIApplication sharedApplication].keyWindow];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:[UIApplication sharedApplication].keyWindow];
    }];
}

#pragma mark ——— 关注微信公众号和抖音
- (void)showAttentionView:(BOOL)isWx
{
    MyAttentionAlertView * attentionView = [[MyAttentionAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    attentionView.is_ua8x = [[DeviceInfo.shareInstance getFileContent:@"TUUChannel"] isEqualToString:@"ua8x"];
    NSDictionary * item = self.model[@"day1_info"];
    attentionView.tips = isWx ? item[@"tipswx"] : item[@"tips"];
    attentionView.isWx = isWx;
    attentionView.exchangeCodeBlock = ^(BOOL isWx) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exclusiveReceiveSuccess" object:nil];
    };
    [[YYToolModel getCurrentVC].view addSubview:attentionView];
}

#pragma mark ——— 绑定手机号
- (void)pushBindMobileVC:(UIViewController *)vc
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    NSString *moblie = dic[@"mobile"];

    if (!moblie || moblie.length == 0) {
        BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
        [vc.navigationController pushViewController:bindVC animated:YES];
    }else{
        [vc jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionDefaultTitle(@"解绑当前手机号").
            addActionDefaultTitle(@"更换当前手机号").
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            MYLog(@"==============%ld", (long)buttonIndex);
            if (buttonIndex == 0 || buttonIndex == 1)
            {
                BindVerifyViewController *verifyVC = [[BindVerifyViewController alloc]init];
                verifyVC.bandMobile = moblie;
                verifyVC.isRebind = (buttonIndex == 0 ? NO : YES);
                [vc.navigationController pushViewController:verifyVC animated:YES];
            }
        }];
    }
}
#pragma mark ——— 点击领取
- (void)receiceRequest:(NSString *)name
{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    MyFinishTaskGetCoinsApi * api = [MyFinishTaskGetCoinsApi new];
    api.isShow = YES;
    api.name = name;
    api.novice = @"1";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exclusiveReceiveSuccess" object:nil];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)setTitleWithValue:(int)value forButton:(UIButton *)btn{
    if (self.index > self.day) {
        [btn setImage:[UIImage imageNamed:@"未开始"] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn.layer.sublayers.firstObject removeFromSuperlayer];
    }else{
        if (value == 0) {
            [btn setTitle:@"去完成" forState:UIControlStateNormal];
            [btn setImage:[UIImage new] forState:UIControlStateNormal];
        }else if (value == 1){
            [btn setTitle:@"领取" forState:UIControlStateNormal];
            [btn setImage:[UIImage new] forState:UIControlStateNormal];
        }else if (value == 2) {
            [btn setImage:[UIImage imageNamed:@"noreceive"] forState:UIControlStateNormal];
            [btn setTitle:@"已完成" forState:UIControlStateNormal];
            [btn.layer.sublayers.firstObject removeFromSuperlayer];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : [self getDataArray].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.index == 0 ? 110 : 90;
    }else{
        if (self.index == 0 && indexPath.row == 5)
        {
            NSDictionary * item = self.model[@"day1_info"];
            return [item[@"tipswx"] isBlankString] ? 0.001 : 80;
        }
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    header.backgroundColor = UIColor.whiteColor;
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, header.height)];
    title.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    title.textColor = [UIColor colorWithHexString:@"#282828"];
    if (self.index == 0) {
        title.text = section == 0 ? @"新人入门充值卡" : @"免费领充值";
    }else if (self.index == 1){
        title.text = section == 0 ? @"3元首充限时送" : @"做任务 抵现金";
    }else{
        title.text = section == 0 ? @"6元首充限时送" : @"做任务 抵现金";
    }
    [header addSubview:title];
    return header;
}
   
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 || self.index > 0 ? 0.001 : 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    footer.clipsToBounds = true;
    UILabel * bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footer.width, footer.height)];
    bottomLabel.text = @"*金币可用于游戏充值，比例为10（金币）：1（元）";
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = UIColor.whiteColor;
    bottomLabel.textAlignment = 1;
    [footer addSubview:bottomLabel];
    return footer;
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
