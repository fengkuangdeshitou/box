//
//  WelfareCentreViewController.m
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreViewController.h"
#import "WelfareCentreUserInfoCell.h"
#import "WelfareCentreFooterView.h"
#import "WelfareCentreHeaderView.h"
#import "WelfareCentreUserInfoHeaderView.h"
#import "WelfareCentreAPI.h"
#import "WelfareCentrePlaformCell.h"
#import "WelfareCentreFineCell.h"
#import "WelfareCentreActiveCell.h"
#import "WelfareCentreSubCell.h"
#import "WelfareCentreGifsCollectionViewCell.h"
#import "MyNoviceTaskController.h"
#import "MyAchievementTaskController.h"
#import "MyDailyTaskController.h"
#import "MyGoldMallViewController.h"
#import "WelfareVerifyCell.h"
#import "WelfareCentreCardCollectionViewCell.h"
#import "SaveMoneyCardViewController.h"
#import "MyInviteFriendsController.h"
#import "MyProjectGameController.h"
#import "MytryPlayViewController.h"
#import "MyTrumpetRecyclingController.h"
#import "MyTaskActivityGiftView.h"
#import "HGLoadDataFooterView.h"
#import "MyTaskStepMaskGuideView.h"
#import "InternalTestingViewController.h"

@interface WelfareCentreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSDictionary * data;
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) HGLoadDataFooterView * footerView;
@property(nonatomic,weak)IBOutlet UIView * contentView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * contentViewHeight;
@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation WelfareCentreViewController

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welfare_title_bg"]];
        _imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/375*158);
    }
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MyAOPManager relateStatistic:@"WelfareCentreViewAppear" Info:@{}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWelfareData) name:@"receiveGiftSuccess" object:nil];

    [self.view addSubview:self.imageView];
    [self.view bringSubviewToFront:self.contentView];
    [self.view bringSubviewToFront:self.collectionView];
    [self.view bringSubviewToFront:self.navBar];
    self.navBar.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreUserInfoCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreUserInfoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WelfareCentreFooterView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCentreHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreUserInfoHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCentreUserInfoHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentrePlaformCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentrePlaformCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareVerifyCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareVerifyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreFineCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreFineCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreActiveCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreActiveCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreSubCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreSubCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreGifsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreGifsCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreCardCollectionViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAction:) name:NSStringFromClass([self class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWelfareData) name:@"receiveVoucherSuccess" object:nil];
    
    //先加载缓存的数据
    NSDictionary * dic = [YYToolModel getCacheData:MiluWelfareCenterDataCache];
    if (dic && !self.isFirstLoad)
    {
        self.isFirstLoad = YES;
        self.data = dic;
        [self parmasData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestWelfareData];
}

#pragma mark ——— 单击指定双击刷新
- (void)scrollTopAction:(NSNotification *)noti
{
    [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top) animated:YES];
    
    NSNumber * number = noti.object;
    //双击刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([number boolValue])
        {
            [self requestWelfareData];
        }
    });
}

- (HGLoadDataFooterView *)footerView{
    if (!_footerView) {
        _footerView = (HGLoadDataFooterView *)[self creatFooterView];
    }
    _footerView.frame = CGRectMake(0, 30, ScreenWidth, 66);
    _footerView.backgroundColor = BackColor;
    return _footerView;
}

- (void)requestWelfareData
{
    WelfareCentreAPI * api = [[WelfareCentreAPI alloc] init];
    api.isShow = !self.data;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.data = [api.data deleteAllNullValue];
        
        [YYToolModel saveCacheData:api.data forKey:MiluWelfareCenterDataCache];
        
        [self parmasData];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)parmasData
{
    [self.collectionView reloadData];
    self.contentViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
//    [self showGuidePageView];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WelfareCentreUserInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreUserInfoCell" forIndexPath:indexPath];
        cell.data = self.data[@"task"][indexPath.row];
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row <= 1) {
            WelfareCentreCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreCardCollectionViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = indexPath.row == 0 ? @"会员中心" : @"省钱卡";
            cell.descLabel.text = indexPath.row == 0 ? @"送平台币 享特权" : @"开通立返全额";
            cell.content.text = indexPath.row == 0 ? self.data[@"vipTips"] : self.data[@"monthCardTips"];
            cell.icon.image = [UIImage imageNamed:indexPath.row == 0 ? @"welfare_huiyuan" : @"welfare_shenqianka"];
            return cell;
        }else{
            WelfareCentrePlaformCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentrePlaformCell" forIndexPath:indexPath];
            cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"welfare_plaform_%ld",indexPath.row]];
            cell.titleLabel.text = indexPath.row == 2 ? @"小号回收".localized : @"邀请好友".localized;
            cell.descLabel.text = indexPath.row == 2 ? @"回血5%".localized : @"送金币".localized;
            return cell;
        }
    }else if(indexPath.section == 2){
        WelfareCentreFineCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreFineCell" forIndexPath:indexPath];
        cell.data = self.data[@"goodsWelfare"][indexPath.row];
        return cell;
    }else if(indexPath.section == 3){
        WelfareCentreSubCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreSubCell" forIndexPath:indexPath];
        cell.dataArray = self.data[@"special"][@"items"];
        return cell;
    }else if(indexPath.section == 4){
        WelfareCentreGifsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreGifsCollectionViewCell" forIndexPath:indexPath];
        cell.data = self.data[@"gift"][@"items"][indexPath.row];
        return cell;
    }else{
        WelfareCentreActiveCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreActiveCell" forIndexPath:indexPath];
        cell.data = self.data[@"active"][indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary * item = self.data[@"task"][indexPath.row];
        if ([item[@"name"] isEqualToString:@"novice"]) {
            [MyAOPManager relateStatistic:@"ClickNewTaskOfWelfareCentrePage" Info:@{}];
            MyNoviceTaskController * task = [[MyNoviceTaskController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if ([item[@"name"] isEqualToString:@"welfare"]) {
            [MyAOPManager relateStatistic:@"ClickAchievementTaskOfWelfareCentrePage" Info:@{}];
            MyAchievementTaskController * task = [[MyAchievementTaskController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if ([item[@"name"] isEqualToString:@"today"]) {
            [MyAOPManager relateStatistic:@"ClickDailyTaskOfWelfareCentrePage" Info:@{}];
            MyDailyTaskController * task = [[MyDailyTaskController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if ([item[@"name"] isEqualToString:@"shop"]) {
            [MyAOPManager relateStatistic:@"ClickGoldMallOfWelfareCentrePage" Info:@{}];
            MyGoldMallViewController * task = [[MyGoldMallViewController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [MyAOPManager relateStatistic:@"ClickMemberCenterOfWelfareCentrePage" Info:@{}];
            SaveMoneyCardViewController * card = [[SaveMoneyCardViewController alloc] init];
            card.selectedIndex = 1;
            [self.navigationController pushViewController:card animated:true];
        }else if (indexPath.row == 1) {
            [MyAOPManager relateStatistic:@"clickMoneySavingCardOfWelfareCentrePage" Info:@{}];
            SaveMoneyCardViewController * card = [[SaveMoneyCardViewController alloc] init];
            card.selectedIndex = 0;
            [self.navigationController pushViewController:card animated:true];
        }else if (indexPath.row == 2) {
            [MyAOPManager  relateStatistic:@"ClickRecyclingAccountOfWelfareCentrePage" Info:@{}];
            MyTrumpetRecyclingController * task = [[MyTrumpetRecyclingController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if (indexPath.row == 3) {
            [MyAOPManager relateStatistic:@"clickInviteFriendsOfWelfareCentrePage" Info:@{}];
            MyInviteFriendsController * card = [[MyInviteFriendsController alloc] init];
            [self.navigationController pushViewController:card animated:true];
        }
    }else if(indexPath.section == 2){
        NSDictionary * item = self.data[@"goodsWelfare"][indexPath.row];
        if ([item[@"name"] isEqualToString:@"trypaly"]) {
            [MyAOPManager relateStatistic:@"ClickDemoOfWelfareCentrePage" Info:@{}];
            MytryPlayViewController * task = [[MytryPlayViewController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if ([item[@"name"] isEqualToString:@"alt"]) {
            [MyAOPManager relateStatistic:@"ClickRecyclingAccountOfWelfareCentrePage" Info:@{}];
            MyTrumpetRecyclingController * task = [[MyTrumpetRecyclingController alloc] init];
            [self.navigationController pushViewController:task animated:true];
        }else if ([item[@"name"] isEqualToString:@"gift"]) {
            [MyAOPManager relateStatistic:@"Click3YuanGiftBagOfWelfareCentrePage" Info:@{}];
            WebViewController * web = [[WebViewController alloc] init];
            web.urlString = item[@"url"];
            [self.navigationController pushViewController:web animated:YES];
        }else if ([item[@"name"] isEqualToString:@"activeGift"]) {
            MyTaskActivityGiftView * giftView = [[MyTaskActivityGiftView alloc] initWithFrame:self.view.bounds];
            giftView.exchangeGiftBlock = ^{
//                [self getTaskCenterData];
            };
            [self.view addSubview:giftView];
        }
    }else if(indexPath.section == 4){
        NSDictionary * item = self.data[@"gift"][@"items"][indexPath.row];
        [MyAOPManager relateStatistic:@"ClickPrivilegeGiftBagOfWelfareCentrePage" Info:@{@"gameName":item[@"game_name"]}];
        GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
        detail.gameID = item[@"game_id"];
        [self.navigationController pushViewController:detail animated:YES];
    }else if(indexPath.section == 5){
        NSDictionary * item = self.data[@"active"][indexPath.row];
        [MyAOPManager relateStatistic:@"ClickPopularActivitiesOfWelfareCentrePage" Info:@{@"gameName":item[@"title"]}];
        if ([item[@"type"] isEqualToString:@"special"]) {
            if ([item[@"style"] intValue] == 6) {
                InternalTestingViewController * detail = [[InternalTestingViewController alloc] init];
                detail.Id = item[@"id"];
                detail.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:detail animated:YES];
                return;
            }
            MyProjectGameController * project = [[MyProjectGameController alloc] init];
            project.project_id = item[@"id"];
            [self.navigationController pushViewController:project animated:YES];
        }else{
            WebViewController * web = [[WebViewController alloc] init];
            web.urlString = item[@"url"];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.data == nil ? 0 : 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger count = [self.data[@"task"] count];
        return count;
    }else if(section == 1){
        return 4;
    }else if(section == 2){
        return [self.data[@"goodsWelfare"] count];
    }else if(section == 3){
        return [self.data[@"special"][@"items"] count] > 0 ? 1 : 0;
    }else if(section == 4){
        return [self.data[@"gift"][@"items"] count]?:0;
    }else{
        return [self.data[@"active"] count];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((ScreenWidth-70)/2, 64);
    }else if(indexPath.section == 1){
        if (indexPath.row <= 1) {
            return CGSizeMake((ScreenWidth-60), 104);
        }else{
            return CGSizeMake((ScreenWidth-70)/2, 67);
        }
    }else if (indexPath.section == 2) {
        return CGSizeMake(ScreenWidth-60, 60);
    }else if (indexPath.section == 3) {
        return CGSizeMake(ScreenWidth-60, 120);
    }else if (indexPath.section == 4) {
        return CGSizeMake(ScreenWidth-30, 140);
    }else{
        return CGSizeMake(ScreenWidth-30, 210);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section <= 2) {
        return 10;
    }else if(section == 3 || section == 6){
        return 15;
    }else if(section == 5){
        return 10;
    }else{
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return section == 1 ? 10 : 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        WelfareCentreFooterView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WelfareCentreFooterView" forIndexPath:indexPath];
        [self clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:13 view:footer.radiusView];
        WEAKSELF
        footer.authVerifySuccess = ^{
            [weakSelf requestWelfareData];
        };
        footer.verifyView.hidden = indexPath.section != 0;
        if (indexPath.section == 5) {
            self.footerView.hidden = false;
            [footer addSubview:self.footerView];
        }else{
            self.footerView.hidden = true;
        }
        return footer;
    }else{
        if (indexPath.section == 0) {
            WelfareCentreUserInfoHeaderView * userInfo = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCentreUserInfoHeaderView" forIndexPath:indexPath];
            userInfo.data = self.data[@"userInfo"];
            userInfo.layer.cornerRadius = 13;
            userInfo.layer.masksToBounds = YES;
            userInfo.tag = 1000;
            return userInfo;
        }else{
            WelfareCentreHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WelfareCentreHeaderView" forIndexPath:indexPath];
            [self clipRectCorner:UIRectCornerTopRight | UIRectCornerTopLeft radius:13 view:header.radiusView];
            header.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"welfare_section_title_%ld",indexPath.section]];
            [header.moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
            header.moreButton.tag = indexPath.section * 10;
            if (indexPath.section == 3 || indexPath.section == 4) {
                header.moreButton.hidden = false;
            }else{
                header.moreButton.hidden = true;
            }
            return header;
        }
    }
}

- (void)moreAction:(UIButton *)btn{
    if (btn.tag == 30) {
        MyProjectGameController * obj = [[MyProjectGameController alloc] init];
        obj.project_id = self.data[@"special"][@"id"];
//        obj.project_id = @"special:test";
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        MyProjectGameController * obj = [[MyProjectGameController alloc] init];
        obj.project_id = self.data[@"gift"][@"id"];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
//    [dict setValue:[dic[@"isRealNameAuth"] intValue] == 0 ? @"1" : @"0" forKey:@"isRealNameAuth"];
//    [YYToolModel saveUserdefultValue:dict forKey:@"member_info"];
//    [self.collectionView reloadData];
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0){
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        return CGSizeMake(ScreenWidth-30, [dic[@"isRealNameAuth"] boolValue] ? 34 : (34 + 10 + (ScreenWidth - 30) / 345 * 60));
    }else if (section < 3) {
        return CGSizeMake(ScreenWidth-30, 34);
    }else if (section == 3){
        if ([self.data[@"special"][@"items"] count] > 0) {
            return CGSizeMake(ScreenWidth-30, 34);
        }else{
            return CGSizeMake(ScreenWidth-30, 0);
        }
    }else if (section == 4){
        if ([self.data[@"gift"][@"items"] count] > 0) {
            return CGSizeMake(ScreenWidth-30, 30);
        }else{
            return CGSizeMake(ScreenWidth-30, 0);
        }
    }else if (section == 5){
        if ([self.data[@"active"] count] > 0) {
            return CGSizeMake(ScreenWidth-30, 30+66);
        }else{
            return CGSizeMake(ScreenWidth-30, 30+66);
        }
    }else{
        return CGSizeMake(ScreenWidth-30, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth-30, 80);
    }else if (section == 3){
        if ([self.data[@"special"][@"items"] count] > 0) {
            return CGSizeMake(ScreenWidth-30, 55);
        }else{
            return CGSizeMake(ScreenWidth-30, 0);
        }
    }else if (section == 4){
        if ([self.data[@"gift"][@"items"] count] > 0) {
            return CGSizeMake(ScreenWidth-30, 55);
        }else{
            return CGSizeMake(ScreenWidth-30, 0);
        }
    }else if (section == 5){
        if ([self.data[@"active"] count] > 0){
            return CGSizeMake(ScreenWidth-30, 55);
        }else{
            return CGSizeMake(ScreenWidth-30, 0);
        }
    }else{
        return CGSizeMake(ScreenWidth-30, 55);
    }
}

- (void)clipRectCorner:(UIRectCorner)corner radius:(CGFloat)radius view:(UIView *)view{
    CGRect rect = CGRectMake(0, 0, ScreenWidth-30, view.height);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.contentView.y = -scrollView.contentOffset.y;
    self.imageView.y = -scrollView.contentOffset.y-scrollView.contentInset.top-StatusBarHeight;
    if (scrollView.contentOffset.y < scrollView.contentInset.top && scrollView.contentOffset.y < 0)
    {
        self.navBar.barBackgroundColor =  [MAIN_COLOR colorWithAlphaComponent:(scrollView.contentOffset.y+scrollView.contentInset.top)/fabs(scrollView.contentOffset.y)];
        self.navBar.title = @"福利中心";
        self.navBar.titleLable.textColor = [UIColor.whiteColor colorWithAlphaComponent:(scrollView.contentOffset.y+scrollView.contentInset.top)/fabs(scrollView.contentOffset.y)];
    }
    
//    if (scrollView.contentOffset.y >= 44)
//    {
//        self.navBar.backgroundColor = MAIN_COLOR;
//        self.navBar.title = @"福利中心";
//        self.navBar.titleLable.textColor = [UIColor.whiteColor colorWithAlphaComponent:(scrollView.contentOffset.y + 74)/44];
//    }
//    else
//    {
//        self.navBar.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:(scrollView.contentOffset.y + 74)/44];
//        self.navBar.title = @"福利中心";
//        self.navBar.titleLable.textColor = [UIColor.whiteColor colorWithAlphaComponent:(scrollView.contentOffset.y + 74)/44];
//    }
}

#pragma mark - 任务引导图
- (void)showGuidePageView
{
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"TskGuidePageView"];
    if (userCenter != NULL)
    {
        return;
    }
    [YYToolModel saveUserdefultValue:@"1" forKey:@"TskGuidePageView"];
    
    NSMutableArray * array = [NSMutableArray array];
    WKStepMaskModel * model1 = [WKStepMaskModel creatModelWithFrame:CGRectMake(kScreenW - 30 - 79, self.collectionView.contentInset.top+StatusBarHeight + 23.5, 79, 33.5) cornerRadius:0 step:0];
    [array addObject:model1];
    
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    CGFloat authheight = [dic[@"isRealNameAuth"] boolValue] ? 35 : 35 + 10 + (ScreenWidth - 30) / 345 * 60;
    NSInteger count = [self.data[@"task"] count];
    CGFloat taskheight = count%2 == 0 ? count/2*74 : (count+1)/2*74;
    WKStepMaskModel * model = [WKStepMaskModel creatModelWithFrame:CGRectMake(15, 74+80+authheight+taskheight+35, 175, 55) cornerRadius:0 step:1];
//    WKStepMaskModel * model = [WKStepMaskModel creatModelWithView:headerView.icon cornerRadius:0 step:1];
    [array addObject:model];
    
    MyTaskStepMaskGuideView * guideView1 = [[MyTaskStepMaskGuideView alloc] initWithModels:array];
    [guideView1 showInView:[UIApplication sharedApplication].keyWindow isShow:YES];
}

@end
