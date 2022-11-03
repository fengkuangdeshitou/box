//
//  MyTaskViewController.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTaskViewController.h"
#import "MyCheckedDateController.h"
#import "UserCoinsHistoryViewController.h"
#import "MyNoviceTaskController.h"
#import "MyDailyTaskController.h"
#import "MyAchievementTaskController.h"
#import "MyGoldMallViewController.h"
#import "SignCollectionViewCell.h"
#import "HGNavbarSearchView.h"
#import "MyTaskActivityGiftView.h"
#import "MyTaskShowDetailCell.h"
#import "DPScrollNumberLabel.h"
#import "BPPCalendar.h"
#import "MySignedRuleView.h"

#import "MyTaskCenterApi.h"
#import "MyLimitedBuyingController.h"

@class MyTaskCenterSignedApi;

@interface MyTaskViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *showGoldenCoin;
@property (weak, nonatomic) IBOutlet UIButton *signedBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *tomorrow;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowLabel;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *completedArray;
@property (nonatomic, strong) NSArray *signedArray;
@property (nonatomic, strong) NSDictionary *signInfo;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) DPScrollNumberLabel *scrollNumberLabel;
//@property (nonatomic,strong) BPPCalendar *calendarView;

@end

@implementation MyTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getTaskCenterData];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.title = @"任务赚金";
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    self.navBar.lineView.hidden = YES;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SignCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SignCollectionViewCell class])];
    
    self.scrollView.delegate = self;
    
    //进入任务中心事件统计
    [MyAOPManager relateStatistic:@"TaskCenterViewAppear" Info:@{}];
    
    [self.recordBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    self.topView_top.constant = 54 + kStatusBarHeight;
    [self.view layoutIfNeeded];
    
//    _collectionView.delegate   = self;
//    _collectionView.dataSource = self;
//    _collectionView.hidden     = YES;
//    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"MyTaskShowDetailCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyTaskShowDetailCell"];
    
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
   
//    BPPCalendar *calendarView = [[BPPCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, self.backView.height)];
//    [self.backView addSubview:calendarView];
//    self.calendarView = calendarView;
}

/// 限时抢购
/// @param sender 按钮
- (IBAction)snapUpAction:(id)sender
{
    [MyAOPManager relateStatistic:@"ClickTimeLimitedBenefits" Info:@{}];
    
    MyGoldMallViewController * limit = [[MyGoldMallViewController alloc] init];
    limit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:limit animated:YES];
    
//    MyLimitedBuyingController * limit = [[MyLimitedBuyingController alloc] init];
//    limit.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:limit animated:YES];
}

- (DPScrollNumberLabel *)scrollNumberLabel
{
    if (!_scrollNumberLabel)
    {
        _scrollNumberLabel = [[DPScrollNumberLabel alloc] initWithNumber:[NSNumber numberWithInt:0] font:[UIFont systemFontOfSize:45 weight:UIFontWeightMedium] textColor:ColorWhite signSetting:SignSettingUnsigned];
        _scrollNumberLabel.frame = self.showGoldenCoin.bounds;
        [self.showGoldenCoin addSubview:_scrollNumberLabel];
    }
    return _scrollNumberLabel;
}

- (IBAction)recordBtnClick:(id)sender
{
    [MyAOPManager relateStatistic:@"ClickGoldCoinsStore" Info:@{}];
    
    UserCoinsHistoryViewController * history = [[UserCoinsHistoryViewController alloc]init];
    history.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:history animated:YES];
}

- (void)getTaskCenterData
{
    MyTaskCenterApi * api = [[MyTaskCenterApi alloc] init];
    api.isShow = !self.isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.isShow = YES;
            NSDictionary * userInfo = request.data;
//            self.showGoldenCoin.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[userInfo[@"balance"] integerValue]]];
            [self.scrollNumberLabel changeToNumber:[NSNumber numberWithInteger:[userInfo[@"balance"] integerValue]] animated:YES];
            self.signInfo = userInfo;
            //签到时间
            NSArray * signData = request.data[@"signData"];
            self.signedArray = signData;
//            self.calenda rView.signedDateArray = self.signedArray;
//            self.calendarView.calendarCollectView.height = height;
            //当前签到状态
            [self.signedBtn setTitle:request.data[@"btnText"] forState:0];

            if ([request.data[@"todaySigned"] boolValue])
            {
                self.tomorrow.hidden = false;
                self.tomorrowLabel.text = request.data[@"nextReward"];
                self.signedBtn.backgroundColor = [UIColor colorWithHexString:@"#D1D1D1"];
            }
            else
            {
                self.signedBtn.backgroundColor = [UIColor colorWithHexString:@"#FFC000"];
            }
            //显示会员金币加成
//            //整理任务的完成进度
//            NSMutableArray * array = [NSMutableArray array];
//            NSDictionary * task_info = request.data[@"task_info"];
//            for (int i = 0; i < self.titleArray.count; i ++)
//            {
//                switch (i) {
//                    case 0:
//                        [array addObject:task_info[@"novice"]];
//                        break;
//                    case 1:
//                        [array addObject:task_info[@"day"]];
//                        break;
//                    case 2:
//                        [array addObject:task_info[@"achievement"]];
//                        break;
//                    case 3:
//                        [array addObject:@{@"completed":[NSNumber numberWithInteger:[task_info[@"tryplay"][@"is_has_some"] integerValue]]}];
//                        break;
//                    case 4:
//                        [array addObject:task_info[@"active"]];
//                        break;
//
//                    default:
//                        break;
//                }
//            }
//            self.completedArray = array;
//            self.collectionView.hidden = NO;
            [self.collectionView reloadData];
            [self rightAction:self.rightBtn];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (NSString *)showVipMemberName:(NSInteger)level_vip
{
    NSString * str = @"";
    switch (level_vip) {
        case 1:
            str = @"子爵会员";
            break;
        case 2:
            str = @"伯爵会员";
            break;
        case 3:
            str = @"公爵会员";
            break;
        case 4:
            str = @"国王会员";
            break;
        case 5:
            str = @"皇帝会员";
            break;
            
        default:
            break;
    }
    return str;
}

#pragma mark - 懒加载
//- (NSArray *)titleArray
//{
//    if (!_titleArray)
//    {
//        _titleArray = @[@{@"title":@"新手任务", @"desc":@"1分钟 10元首充拿到手", @"image":@"task_title_icon1", @"vc":@"MyNoviceTaskController"},
//                        @{@"title":@"每日任务", @"desc":@"每日动动手，金币一直有", @"image":@"task_title_icon2", @"vc":@"MyDailyTaskController"},
//                        @{@"title":@"成就任务", @"desc":@"值得更多超值福利", @"image":@"task_title_icon3", @"vc":@"MyAchievementTaskController"},
//                        @{@"title":@"试玩任务", @"desc":@"下载试玩任务，轻松赚金币", @"image":@"task_title_icon4", @"vc":@"MytryPlayViewController"},
//                        @{@"title":@"活动礼包", @"desc":@"输入兑换码，领取活动礼包", @"image":@"task_title_icon5", @"vc":@""}];
//    }
//    return _titleArray;
//}

//#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
///**  分区个数  */
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
///** 每个分区item的个数  */
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.titleArray.count;
//}
//
///**  创建cell  */
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIndentifer = @"MyTaskShowDetailCell";
//    MyTaskShowDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
//    cell.dataDic = self.titleArray[indexPath.row];
//    cell.taskDic = self.completedArray[indexPath.row];
//    return cell;
//}
//
///**  cell的大小  */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((collectionView.width - 10) / 2, 105);
//}
//
///**  每个分区的内边距（上左下右） */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
///**  分区内cell之间的最小行间距  */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
///**  分区内cell之间的最小列间距  */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
///**
// 点击某个cell
// */
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"点击了第%ld分item", (long)indexPath.item);
//
//    NSString * statistic = @"";
//    if (indexPath.row == 4)
//    {
//        statistic = @"ClickActivityPackage";
//
//        MyTaskActivityGiftView * giftView = [[MyTaskActivityGiftView alloc] initWithFrame:self.view.bounds];
//        giftView.exchangeGiftBlock = ^{
//            [self getTaskCenterData];
//        };
//        [self.view addSubview:giftView];
//    }
//    else
//    {
//        if (indexPath.row == 0)
//        {
//            statistic = @"ClickNewTask";
//        }
//        else if (indexPath.row == 1)
//        {
//            statistic = @"ClickDailyTask";
//        }
//        else if (indexPath.row == 2)
//        {
//            statistic = @"ClickAchievementTask";
//        }
//        else if (indexPath.row == 3)
//        {
//            statistic = @"ClickTrialTask";
//        }
//        [MyAOPManager userInfoRelateStatistic:statistic];
//
//        NSString * className = self.titleArray[indexPath.row][@"vc"];
//        Class class = NSClassFromString(className);
//        if ([className isEqualToString:@"MyNoviceTaskController"])
//        {
//            MyNoviceTaskController * novice = [MyNoviceTaskController new];
//            novice.hidesBottomBarWhenPushed = YES;
//            novice.is_ua8x = [self.signInfo[@"is_ua8x"] boolValue];
//            [self.navigationController pushViewController:novice animated:YES];
//        }
//        else if (class && className)
//        {
//            BaseViewController *ctrl = class.new;
//            ctrl.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//    }
//}

- (IBAction)signBtnClick:(UIButton *)sender
{
    if ([DeviceInfo shareInstance].isOpenYouthMode)
    {
        [MBProgressHUD showToast:@"当前为青少年模式暂不能访问！" toView:[YYToolModel getCurrentVC].view];
        return;
    }
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    if (![dic[@"mobile"] isBlankString])
    {
        if ([self.signInfo[@"todaySigned"] boolValue])
        {
//            [self viewSignedStatus:NO Dic:self.signInfo];
        }
        else
        {
            [self signRequest];
        }
    }
    else
    {
        sender.userInteractionEnabled = false;
        [MBProgressHUD showToast:@"请先绑定手机号才能签到!" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = true;
            BindMobileViewController * band = [BindMobileViewController new];
            band.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:band animated:YES];
        });
    }
}

- (void)signRequest
{
    MyTaskCenterSignedApi * api = [[MyTaskCenterSignedApi alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if(self.signBlock){
                self.signBlock();
            }
            [self getTaskCenterData];
//            self.signedArray = request.data[@"sign_date_list"];
////            [self viewSignedStatus:YES Dic:request.data];
////            self.calendarView.signedDateArray = self.signedArray;
//
//            [self.scrollNumberLabel changeToNumber:[NSNumber numberWithInteger:self.scrollNumberLabel.currentNumber.integerValue + [request.data[@"today_sign_get_balance"] integerValue]] animated:YES];
//            [self.signedBtn setTitle:@"已签到" forState:0];
//            self.signedBtn.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
//            self.signedBtn.enabled = NO;
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)viewSignedStatus:(BOOL)status Dic:(NSDictionary *)dic
{
    if (self.isPush)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayRefreshCurrentPage" object:nil];
    }
    
    MyCheckedDateController * date = [MyCheckedDateController new];
    date.hidesBottomBarWhenPushed = YES;
    date.signedDateArray = self.signedArray;
    date.isSigned = status;
    date.dataDic = dic;
    date.getCoin = self.signInfo[@"user_info"][@"today_sign_get_balance"];
    [self.navigationController pushViewController:date animated:YES];
}


#pragma mark ——— 加入会员
- (IBAction)joinMembershipClick:(id)sender
{
    SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
    payVC.selectedIndex = 1;
    payVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
}

#pragma mark ——— 查看签到规则
- (IBAction)viewCheckedRuleClick:(id)sender
{
    MySignedRuleView * ruleView = [[MySignedRuleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:ruleView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView == scrollView)
    {
        if (scrollView.contentOffset.y > 20)
        {
            self.navBar.backgroundColor = MAIN_COLOR;
        }
        else
        {
            self.navBar.backgroundColor = UIColor.clearColor;
        }
    }
}

- (IBAction)leftAction:(UIButton *)sender{
    sender.hidden = true;
    self.rightBtn.hidden = false;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
}

- (IBAction)rightAction:(UIButton *)sender{
    sender.hidden = true;
    self.leftBtn.hidden = false;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.signedArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:true];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SignCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SignCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.signedArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.signedArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-25*2-15*2)/7, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        if (self.collectionView.contentOffset.x == 0) {
            [self leftAction:self.leftBtn];
        }else{
            [self rightAction:self.rightBtn];
        }
    }
}


@end
