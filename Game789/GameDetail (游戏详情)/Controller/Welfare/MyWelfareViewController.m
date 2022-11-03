//
//  MyWelfareViewController.m
//  Game789
//
//  Created by maiyou on 2021/3/10.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyWelfareViewController.h"
#import "HGShowWelfareCell.h"
#import "MyActivityGuideCell.h"
#import "HGShowGameGiftCell.h"
#import "MyGiftViewController.h"
#import "MyGameGiftDetailController.h"
#import "HGGameReceiveGiftView.h"
#import "GetGiftApi.h"
#import "MyGetVoucherListApi.h"
#import "MyActivityGuideController.h"
#import "MyActivityDetailController.h"
#import "UserPayGoldViewController.h"
#import "MyGameAllVouchersController.h"
#import "NoticeDetailViewController.h"

#import "MyVoucherListModel.h"

@interface MyWelfareViewController () <UITableViewDelegate,UITableViewDataSource, YNPageScrollMenuViewDelegate>

@property (nonatomic, weak) IBOutlet UIView * headerView;
@property (nonatomic, weak) IBOutlet UIView * footerView;
@property (weak, nonatomic) IBOutlet UIView * monthCardView;
@property (nonatomic, strong) NSArray * activityArray;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * giftData;
@property (nonatomic, strong) NSArray * voucherList;
@property (nonatomic, strong) UIView * sectionView;
@property (nonatomic, strong) HGGameReceiveGiftView * giftView;
@property (nonatomic, strong) UIView * activityHeaderView;
@property (nonatomic, assign) NSInteger menuSelectedIndex;
@property (nonatomic, assign) NSInteger giftSelectedIndex;

@property (nonatomic, assign) BOOL isCellBtnReceive;
@property (nonatomic,assign) BOOL isOpenRebate;
@property (nonatomic,assign) BOOL isOpenActivity;
@property (nonatomic,assign) BOOL isOpenGif;

@end

@implementation MyWelfareViewController

/// 领取代金券
/// @param btn 按钮
- (void)receivedVoucher:(UIButton *)btn
{
    MyVoucherListModel * model = self.voucherList[btn.tag-10];
    if (![YYToolModel isAlreadyLogin]) return;
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    if ([YYToolModel isBlankString:dic[@"mobile"]])
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
//            [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
//        });
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [MBProgressHUD showToast:@"请先绑定手机号"];
//        return;
//    }
//    if (model.is_received.boolValue) return;
    
    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
    api.voucher_id = model.Id;
    api.game_id = model.game_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
     {
         if (api.success == 1)
         {
             [MyAOPManager gameRelateStatistic:@"ClickToGetCashCoupon" GameInfo:self.dataDic[@"game_info"] Add:@{}];
             //如果没有可领取的该状态
             if (![request.data[@"hasSome"] boolValue])
             {
                 model.is_received = @"1";
                 btn.selected = YES;
                 
                 UILabel * label = [btn viewWithTag:2222];
                 label.text = @"已\n领\n取";
                 for (UILabel * label in btn.subviews)
                 {
                     label.textColor = UIColor.whiteColor;
                 }
             }
             else
             {
                 [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
             }
         }
         else
         {
             [MBProgressHUD showToast:api.error_desc toView:self.view];
         }
     } failureBlock:^(BaseRequest * _Nonnull request) {
         
     }];
}

/// 单个代金券按钮
/// @param data 按钮
- (UIView *)voucherWithData:(MyVoucherListModel *)data
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.voucherList.count <= 3 ? (ScreenWidth-30)/3-10 : (ScreenWidth-45)/3-10, 50);
    [button setBackgroundImage:[UIImage imageNamed:data.type.integerValue == 1 ? @"voucher_normal" : @"voucher_vip_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:data.type.integerValue == 1 ? @"voucher_selected" : @"voucher_vip_selected"] forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = false;
    button.selected = [data.is_received boolValue];
    [button addTarget:self action:@selector(receivedVoucher:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = NO;
    
    UIColor * textColor = data.is_received.boolValue ? UIColor.whiteColor : [UIColor colorWithHexString:@"#111111"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = data.is_received.boolValue ? @"已\n领\n取" : @"领\n取";
    label.textColor = data.type.integerValue == 1 ? UIColor.whiteColor : textColor;
    label.font = [UIFont systemFontOfSize:10];
    label.numberOfLines = 0;
    label.textAlignment = 1;
    label.tag = 2222;
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(button);
        make.width.mas_equalTo(button).multipliedBy(0.22);
    }];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descLabel.textColor = data.type.integerValue == 1 ? UIColor.whiteColor : textColor;
    descLabel.textAlignment = 1;
    NSString * type = data.use_type;
    if ([type isEqualToString:@"direct"]) {
        descLabel.text = [NSString stringWithFormat:@"仅限%@元档可用", data.amount];
    }else{
        int meet_amount = [[data.meet_amount stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        if (meet_amount == 0) {
            descLabel.text = @"任意金额可用";
        }else{
            descLabel.text = [NSString stringWithFormat:@"满%@元可用", data.meet_amount];
        }
    }
    descLabel.font = [UIFont systemFontOfSize:9];
    [button addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(label.mas_left);
            make.bottom.mas_equalTo(-9);
            make.height.mas_equalTo(9);
    }];

    NSString * amountString = data.amount;
    CGFloat fontRatio = 0.03;//基线偏移比率
    NSString * amount = [amountString componentsSeparatedByString:@"."].firstObject;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",amountString]];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName : data.type.integerValue == 1 ? UIColor.whiteColor : textColor} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22 weight:UIFontWeightMedium]} range:NSMakeRange(1, amount.length)];
    [attributedString addAttributes:@{NSBaselineOffsetAttributeName:@(fontRatio * (22-10))} range:NSMakeRange(0, 1)];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.textColor = data.type.integerValue == 1 ? UIColor.whiteColor : textColor;
    priceLabel.textAlignment = 1;
    priceLabel.attributedText = attributedString;
    [button addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(label.mas_left);
        make.bottom.mas_equalTo(descLabel.mas_top);
    }];
    
    return button;
}

/// 月卡
/// @param sender 手势
- (IBAction)moreVoucherAction:(UITapGestureRecognizer *)sender
{
    if ([YYToolModel isAlreadyLogin])
    {
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = 0;
        payVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
}

- (void)refreshGift:(NSNotification *)notification{
    self.dataDic = notification.object;
    self.giftData = [NSMutableArray array];
    self.dataArray = [[NSMutableArray alloc] init];
    NSMutableArray * type1Array = [NSMutableArray array];
    NSMutableArray * type2Array = [NSMutableArray array];
    NSMutableArray * type3Array = [NSMutableArray array];
    NSMutableArray * type4Array = [NSMutableArray array];
    NSArray * giftArray = [_dataDic[@"game_info"][@"gift_bag_list"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [@([obj1[@"gift_type"] integerValue]) compare:@([obj2[@"gift_type"] integerValue])];
    }];
    for (int i=0;i<giftArray.count;i++) {
        NSDictionary * dic = giftArray[i];
       if ([dic[@"gift_type"] intValue] == 1)
       {
           [type1Array addObject:dic];
           
       }
       else if ([dic[@"gift_type"] intValue] == 2){
           [type2Array addObject:dic];
           
       }
       else if ([dic[@"gift_type"] intValue] == 3){
           [type3Array addObject:dic];
           
       }
       else if ([dic[@"gift_type"] intValue] == 4){
           [type4Array addObject:dic];
           
       }
    }
    if (type1Array.count > 0) [self.giftData addObject:type1Array];
    if (type2Array.count > 0) [self.giftData addObject:type2Array];
    if (type3Array.count > 0) [self.giftData addObject:type3Array];
    if (type4Array.count > 0) [self.giftData addObject:type4Array];
    
    if (self.giftData.count > 0)
    {
        self.dataArray = [NSMutableArray arrayWithArray:self.giftData[self.menuSelectedIndex]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGift:) name:@"refreshGift" object:nil];
    NSInteger gameType = [self.dataDic[@"game_info"][@"game_species_type"] integerValue];
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dic in self.dataDic[@"voucherslist"])
    {
        MyVoucherListModel * voucherModel = [[MyVoucherListModel alloc] initWithDictionary:dic];
        [array addObject:voucherModel];
    }
    self.voucherList = array;
    if (self.voucherList.count > 0) {
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        if (self.voucherList.count > 3) {
            scrollView.frame = CGRectMake(15, 15, ScreenWidth-45, 50);
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ScreenWidth-30, 15, 15, scrollView.height);
            [button setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreVouchersClick) forControlEvents:UIControlEventTouchUpInside];
            [self.headerView addSubview:button];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreVouchersClick)];
            [scrollView addGestureRecognizer:tap];
        }
        else
        {
            scrollView.frame = CGRectMake(15, 15, ScreenWidth-30, 50);
        }
        scrollView.showsHorizontalScrollIndicator = false;
        [self.headerView addSubview:scrollView];
        
        for (int i=0; i<self.voucherList.count; i++)
        {
            UIView * view = [self voucherWithData:self.voucherList[i]];
            view.tag = i+10;
            view.frame = CGRectMake((view.width+10)*i, 0, view.width, view.height);
            view.backgroundColor = BackColor;
            [scrollView addSubview:view];
        }
        scrollView.contentSize = CGSizeMake(self.voucherList.count * (ScreenWidth-45)/3, 0);
        
        self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 70);
        self.monthCardView.hidden = YES;
    }
    else
    {
        if (gameType == 1)
        {
            self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 62);
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, 0, 1);
            self.monthCardView.hidden = YES;
        }
    }
    self.headerView.backgroundColor = BackColor;
    self.tableView.tableHeaderView = self.headerView;
    
    self.giftData = [NSMutableArray array];
    NSMutableArray * type1Array = [NSMutableArray array];
    NSMutableArray * type2Array = [NSMutableArray array];
    NSMutableArray * type3Array = [NSMutableArray array];
    NSMutableArray * type4Array = [NSMutableArray array];
    NSArray * giftArray = [_dataDic[@"game_info"][@"gift_bag_list"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [@([obj1[@"gift_type"] integerValue]) compare:@([obj2[@"gift_type"] integerValue])];
    }];
    for (int i=0;i<giftArray.count;i++) {
        NSDictionary * dic = giftArray[i];
       if ([dic[@"gift_type"] intValue] == 1)
       {
           [type1Array addObject:dic];
           if (![self.titleArray containsObject:@"免费礼包"])
           {
               [self.titleArray addObject:@"免费礼包"];
           }
       }
       else if ([dic[@"gift_type"] intValue] == 2){
           [type2Array addObject:dic];
           if (![self.titleArray containsObject:@"充值礼包"])
           {
               [self.titleArray addObject:@"充值礼包"];
           }
       }
       else if ([dic[@"gift_type"] intValue] == 3){
           [type3Array addObject:dic];
           if (![self.titleArray containsObject:@"限时礼包"])
           {
               [self.titleArray addObject:@"限时礼包"];
           }
       }
       else if ([dic[@"gift_type"] intValue] == 4){
           [type4Array addObject:dic];
           if (![self.titleArray containsObject:@"会员礼包"])
           {
               [self.titleArray addObject:@"会员礼包"];
           }
       }
    }
    if (type1Array.count > 0) [self.giftData addObject:type1Array];
    if (type2Array.count > 0) [self.giftData addObject:type2Array];
    if (type3Array.count > 0) [self.giftData addObject:type3Array];
    if (type4Array.count > 0) [self.giftData addObject:type4Array];
    
    if (self.giftData.count > 0)
    {
        self.dataArray = [NSMutableArray arrayWithArray:self.giftData[0]];
    }
    
    self.activityArray = self.dataDic[@"activity_list"];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.backgroundColor = BackColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyActivityGuideCell" bundle:nil] forCellReuseIdentifier:@"MyActivityGuideCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGShowWelfareCell" bundle:nil] forCellReuseIdentifier:@"HGShowWelfareCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGShowGameGiftCell" bundle:nil] forCellReuseIdentifier:@"HGShowGameGiftCell"];
    [self.tableView reloadData];
}

#pragma mark ——— 点击显示更多代金券
- (void)moreVouchersClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTipBarView" object:nil];
    NSDictionary * game_info = self.dataDic[@"game_info"];
    
    MyGameAllVouchersController * voucher = [MyGameAllVouchersController new];
    voucher.dataDic = self.dataDic;
    voucher.dataArray = self.voucherList;
    voucher.game_species_type = [game_info[@"game_species_type"] integerValue];
    voucher.receivedVoucherAction = ^(NSArray * _Nonnull array, MyVoucherListModel * _Nonnull model1) {
        self.voucherList = array;
        for (int i = 0; i < array.count; i ++)
        {
            MyVoucherListModel * model = array[i];
//            NSLog(@"====%@",model.is_received);
            if (model.Id.integerValue == model1.Id.integerValue)
            {
                UIButton * button = [self.headerView viewWithTag:i + 10];
                if (button)
                {
                    button.selected = [model.is_received boolValue];
                }
                if (model.is_received)
                {
                    UILabel * label = [button viewWithTag:2222];
                    label.text = @"已\n领\n取";
                }
                for (UILabel * label in button.subviews)
                {
                    if ([label isKindOfClass:[UILabel class]])
                    {
                        label.textColor = UIColor.whiteColor;
                    }
                }
            }
        }
//        [MyAOPManager gameRelateStatistic:@"ClickToGetAReplacementCoupon" GameInfo:game_info Add:@{@"ab_test1":[NSString stringWithFormat:@"%@", self.dataDic[@"ab_test_game_detail_welfare"]]}];
    };
    [self presentViewController:voucher animated:YES completion:^{
        
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

/// 游戏活动Header
- (UIView *)activityHeaderView
{
    if (!_activityHeaderView)
    {
        _activityHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 56)];
        _activityHeaderView.backgroundColor = BackColor;
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, _activityHeaderView.height)];
        titleLabel.text = @"活动攻略";
        titleLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [_activityHeaderView addSubview:titleLabel];
        
        UIButton * history = [UIButton buttonWithType:UIButtonTypeCustom];
        history.frame = CGRectMake(ScreenWidth-75, 0, 60, _activityHeaderView.height);
        [history setTitle:@"查看更多" forState:UIControlStateNormal];
        [history setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [history setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
        history.titleLabel.font = [UIFont systemFontOfSize:12];
        [history layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [history addTarget:self action:@selector(historyActivity) forControlEvents:UIControlEventTouchUpInside];
        [_activityHeaderView addSubview:history];
    }
    return _activityHeaderView;
}

/// 历史活动
- (void)historyActivity
{
    [MyAOPManager gameRelateStatistic:@"ClickToViewHistoricalGameActivity" GameInfo:self.dataDic[@"game_info"] Add:@{}];
    
    MyActivityGuideController * guide = [MyActivityGuideController new];
    guide.game_id = self.dataDic[@"game_info"][@"game_id"];;
    guide.gameInfo = self.dataDic[@"game_info"];
//    guide.introduction_count = [self.dataDic[@"introduction_count"] intValue];
    [self.navigationController pushViewController:guide animated:YES];
}

- (NSNumber *)xy_noDataViewCenterYOffset
{
    return [NSNumber numberWithFloat:-self.view.height / 4];
}

#pragma mark - 懒加载
- (UIView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 69)];
        _sectionView.backgroundColor = BackColor;
        
        if (self.titleArray.count > 0)
        {
            YNPageConfigration *style_config_1 = [YNPageConfigration defaultConfig];
            style_config_1.itemFont = [UIFont systemFontOfSize:14];
            style_config_1.selectedItemFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
            style_config_1.selectedItemColor = [UIColor colorWithHexString:@"#282828"];
            style_config_1.normalItemColor = [UIColor colorWithHexString:@"#666666"];
            style_config_1.lineHeight = 3;
            style_config_1.lineColor = MAIN_COLOR;
            style_config_1.lineCorner = 1;
            style_config_1.lineBottomMargin = 5;
            style_config_1.scrollMenu = YES;
            style_config_1.lineLeftAndRightMargin = 25;
            style_config_1.aligmentModeCenter = NO;
            
            YNPageScrollMenuView *menuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(15, 15, 200, 44) titles:self.titleArray.mutableCopy configration:style_config_1 delegate:self currentIndex:0];
            menuView.backgroundColor = UIColor.clearColor;
            [_sectionView addSubview:menuView];
            
            UIButton * myGift = [UIControl creatButtonWithFrame:CGRectMake(kScreenW - 15 - 90, 0, 90, menuView.height) backgroundColor:[UIColor clearColor] title:@"我的礼包" titleFont:[UIFont systemFontOfSize:12] actionBlock:^(UIControl *control) {
                if ([YYToolModel isAlreadyLogin])
                {
                    [self.navigationController pushViewController:[MyGiftViewController new] animated:YES];
                }
            }];
            [myGift setTitleColor:FontColor99 forState:0];
            [myGift setImage:MYGetImage(@"home_more_icon") forState:0];
            [myGift layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
            [menuView addSubview:myGift];
        }
        
    }
    return _sectionView;
}

/// 查看更多Footer
/// @param section section
- (UIView *)creatSectionFooterViewWithSection:(NSInteger)section
{
    UIView * sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, section == 10 ? 25 : 15)];
    sectionFooterView.backgroundColor = BackColor;
    
    UIButton * actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = sectionFooterView.bounds;
    if (section == 10) {
        [actionButton setTitle:self.isOpenActivity ? @"收起" : @"查看全部" forState:UIControlStateNormal];
        [actionButton setImage:[UIImage imageNamed:self.isOpenActivity ? @"game_detail_more_up" : @"game_detail_more_down"] forState:UIControlStateNormal];
    }else{
        [actionButton setTitle:self.isOpenGif ? @"收起" : @"查看全部" forState:UIControlStateNormal];
        [actionButton setImage:[UIImage imageNamed:self.isOpenGif ? @"game_detail_more_up" : @"game_detail_more_down"] forState:UIControlStateNormal];
    }
    [actionButton setTitleColor:[UIColor colorWithHexString:@"#FFC000"] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:13];
    actionButton.tag = section;
    [actionButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
//    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    [actionButton addTarget:self action:@selector(statusChange:) forControlEvents:UIControlEventTouchUpInside];
    [sectionFooterView addSubview:actionButton];
    return sectionFooterView;
}

/// 查看更多打开或者关闭
/// @param btn 按钮
- (void)statusChange:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.tag == 10) {
        self.isOpenActivity = !self.isOpenActivity;
    }else{
        self.isOpenGif = !self.isOpenGif;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        static NSString *reuseID = @"cell";
        MyActivityGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MyActivityGuideCell" owner:self options:nil].firstObject;
        }
        cell.currentVC = self;
        cell.bottomViewHeight.constant = 10;
        cell.dataDic = self.activityArray[indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *reuseID = @"HGShowGameGiftCell";
        HGShowGameGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.dataDic = self.dataArray[indexPath.row];
        cell.receiveGiftAction = ^(NSString * _Nonnull giftId) {
//            self.isCellBtnReceive = YES;
//            self.giftSelectedIndex = indexPath.row;
//            [self receiveGift:giftId];
            if (self.downloadGameBlock) {
                self.downloadGameBlock();
            }
        };
        return cell;
    }else{
        static NSString *reuseID = @"HGShowWelfareCell";
        HGShowWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        NSString * content = self.dataDic[@"game_info"][@"game_feature_list"][1][@"content"];
        cell.showTitle.text = @"返利";
        cell.showContent.attributedText = [HGShowWelfareCell setTextSpace:5 Text:content];
        cell.hidden = [content isBlankString];
        cell.isRebate = YES;
        cell.moreBtn.selected = self.isOpenRebate;
        cell.isAutoRebate = [self.dataDic[@"game_info"][@"allow_rebate"] boolValue];
        cell.lineView.hidden = YES;
        CGFloat height = [HGShowWelfareCell getTextHeightWithStr:content withWidth:kScreenW - 30 - 13 * 2 withLineSpacing:5 withFont:14];
        if (height <= 178)
        {
            cell.moreBtn.hidden = YES;
        }
        cell.viewMoreContent = ^{
            self.isOpenRebate = !self.isOpenRebate;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    if (indexPath.section == 0)
    {
        NSDictionary * dic = self.activityArray[indexPath.row];
//        if ([dic[@"type"] integerValue] == 2)
//        {
//            NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
//            detailVC.news_id = dic[@"news_id"];
//            detailVC.gameInfo = self.dataDic[@"game_info"];
//            [self.navigationController pushViewController:detailVC animated:YES];
//        }
//        else
//        {
            MyActivityDetailController *detailVC = [[MyActivityDetailController alloc] init];
            detailVC.news_id = dic[@"news_id"];
            detailVC.type = dic[@"type"];
            detailVC.gameInfo = self.dataDic[@"game_info"];
            [self.navigationController pushViewController:detailVC animated:YES];
//        }
        
        [MyAOPManager gameRelateStatistic:@"ClickToViewGameActivity_New" GameInfo:self.dataDic[@"game_info"] Add:@{}];
    }
    else if (indexPath.section == 1)
    {
        NSDictionary * dic = self.dataArray[indexPath.row];
        
        MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
        detail.isReceived = YES;
        detail.gift_id = dic[@"packid"];
        detail.vc = YYToolModel.getCurrentVC;
        [self presentViewController:detail animated:YES completion:nil];
    }
}

/// 礼包弹框
/// @param indexPath indexPath
- (void)receiveSuccessAlert:(NSIndexPath *)indexPath
{
    HGGameReceiveGiftView * giftView = [[HGGameReceiveGiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    giftView.dataDic = self.dataArray[indexPath.row];
    giftView.receiveGiftAction = ^{
        self.giftSelectedIndex = indexPath.row;
        [self receiveGift:self.dataArray[indexPath.row][@"id"]];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:giftView];
    self.giftView = giftView;
}

#pragma mark — YNPageScrollMenuViewDelegate
- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index
{
    self.menuSelectedIndex = index;
    self.dataArray = self.giftData[index];
    [self.tableView reloadData];
}

- (void)receiveGift:(NSString *)giftId
{
    if (![YYToolModel islogin])
    {
        LoginViewController *VC = [[LoginViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    GetGiftApi *api = [[GetGiftApi alloc] init];
    api.gift_id = giftId;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGiftSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleGiftSuccess:(GetGiftApi *)api
{
    if (api.success == 1)
    {
        NSString * code = [NSString stringWithFormat:@"礼包码为：%@", api.data[@"data"]];
        [self jxt_showAlertWithTitle:@"领取成功" message:code appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionDefaultTitle(@"取消".localized).
            addActionDestructiveTitle(@"复制".localized);
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = api.data[@"data"];
                [MBProgressHUD showToast:@"已复制到粘贴板"];
            }
        }];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        if (self.isOpenActivity) {
            return self.activityArray.count;
        }else{
            return self.activityArray.count > 3 ? 3 : self.activityArray.count;
        }
    }else if (section == 1) {
        if (self.isOpenGif) {
            return self.dataArray.count;
        }else{
            return self.dataArray.count > 3 ? 3 : self.dataArray.count;
        }
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activityArray.count > 0 ? self.activityHeaderView : [UIView new];
    }else if (section == 1) {
        return self.titleArray.count > 0 ? self.sectionView : [UIView new];
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activityArray.count > 0 ? 56 : 0.001;
    }else if (section == 1) {
        return self.titleArray.count > 0 ? 65 : 0.001;
    }else{
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activityArray.count > 3 ? 25 : 0.001;
    }else if (section == 1) {
        return self.dataArray.count > 3 ? 15 : 0.001;
    }else{
        return 66;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activityArray.count > 3 ? [self creatSectionFooterViewWithSection:section+10] : [UIView new];
    }else if (section == 1){
        return self.dataArray.count > 3 ? [self creatSectionFooterViewWithSection:section+10] : [UIView new];
    }else{
        UIView * view = [self creatFooterView];
        view.backgroundColor = BackColor;
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 77;
    }else if (indexPath.section == 1){
        return UITableViewAutomaticDimension;
    }else{
        NSString * content = self.dataDic[@"game_info"][@"game_feature_list"][indexPath.row][@"content"];
        if ([content isBlankString])
        {
            return 0.001;
        }
        CGFloat height = [HGShowWelfareCell getTextHeightWithStr:content withWidth:kScreenW - 30 - 13 * 2 withLineSpacing:5 withFont:14];
        if (height <= 178)
        {
            return UITableViewAutomaticDimension;
        }else{
            return self.isOpenRebate ? UITableViewAutomaticDimension : 178;
        }
    }
}

@end
