//
//  HGHomeScrollHeaderView.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHomeScrollHeaderView.h"
#import "GameDetailInfoController.h"
#import "UserPayGoldViewController.h"
#import "MyProjectGameController.h"
#import "HGHomeSectionNotifiCell.h"
#import "SaveMoneyCardViewController.h"
#import "TYCyclePagerView.h"
#import "HomeCycleCell.h"
#import "MyHomeCouponCenterController.h"
#import "TransactionViewController.h"
#import "MyOpenServiceListController.h"
#import "AwemeListController.h"
#import "MyTradeFliterViewController.h"
#import "NewExclusiveViewController.h"
#import "MyUserReturnController.h"
#import "InternalTestingViewController.h"

@interface HGHomeScrollHeaderView ()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView * cardView;
@property (weak, nonatomic) IBOutlet UIView *topGradientView;
@property (strong, nonatomic) TYCyclePagerView * scrollView;
@property (strong, nonatomic) NSArray * rebate_swiper_list;
@property (assign, nonatomic) BOOL flag;
@property (strong, nonatomic) NSArray * swiper;
@property (strong, nonatomic) CAGradientLayer * gradientLayer;
@property (strong, nonatomic) CAGradientLayer * gradientLayer1;
@property (assign, nonatomic) BOOL direction;

@end

@implementation HGHomeScrollHeaderView

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, kScreenW, self.topBackView.height);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
//        _gradientLayer.locations = @[@(0.0f),@(1.0f),@(0.0f)];
    }
    return _gradientLayer;
}

- (CAGradientLayer *)gradientLayer1{
    if (!_gradientLayer1) {
        _gradientLayer1 = [CAGradientLayer layer];
        _gradientLayer1.frame = CGRectMake(0, 0, kScreenW, self.topGradientView.height);
        _gradientLayer1.startPoint = CGPointMake(0, 0);
        _gradientLayer1.endPoint = CGPointMake(0, 1);
        _gradientLayer1.locations = @[@(0.0f),@(1.0f)];
    }
    return _gradientLayer1;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGHomeScrollHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        for (int i = 0; i < 3; i ++)
        {
            CAGradientLayer * gradientLayer2 = [CAGradientLayer layer];
            gradientLayer2.frame = CGRectMake(0, 0, kScreenW, self.topBackView.height);
            gradientLayer2.startPoint = CGPointMake(0, 0);
            gradientLayer2.endPoint  = CGPointMake(0, 1);
            gradientLayer2.locations = @[@(0.0f),@(1.0f)];
            gradientLayer2.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#F5F6F8"] colorWithAlphaComponent:0].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#F5F6F8"] colorWithAlphaComponent:1].CGColor];
            [self.topBackView.layer insertSublayer:gradientLayer2 atIndex:0];
        }
        
        self.gradientLayer1.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#3179CF"] colorWithAlphaComponent:1].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#3179CF"] colorWithAlphaComponent:0].CGColor];
        [self.topGradientView.layer insertSublayer:self.gradientLayer1 atIndex:0];
        
//        self.scrollView = [[TYCyclePagerView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, kScreenW/(375-30)*320)];
//        self.scrollView.autoScrollInterval = 3;
//        self.scrollView.delegate = self;
//        self.scrollView.dataSource = self;
//        [self.scrollView registerNib:[UINib nibWithNibName:@"HomeCycleCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCycleCell"];
//        self.scrollView.backgroundColor = [UIColor clearColor];
//        [self.cardView addSubview:self.scrollView];
//        [self.scrollView reloadData];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.backView.height) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.height = 78;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"MyHomeTopFunctionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyHomeTopFunctionCell"];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.backView addSubview:self.collectionView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagViewClick)];
        [self.headerImageView addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - NewPagedFlowViewDelegate

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    return self.swiper.count;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    HomeCycleCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"HomeCycleCell" forIndex:index];
    NSDictionary * item = self.swiper[index];
    NSString * type = item[@"type"];

    if([type isEqualToString:@"game_info"]){
        NSDictionary * data = item[@"gameinfo"];
        cell.data = data;
    }
    
    if ([self.swiper[index][@"type"] isEqualToString:@"game_info"]) {
        cell.showGradientLayer = YES;
        cell.infoView.hidden = NO;
    }else{
        cell.showGradientLayer = NO;
        cell.infoView.hidden = YES;
    }
    
    UIColor * color = [UIColor colorWithHexString:self.swiper[pagerView.curIndex][@"color"]];
    self.gradientLayer.colors = @[(__bridge id)color.CGColor,(__bridge id)[UIColor colorWithHexString:@"#f5f6f8"].CGColor];
    
    [cell.icon yy_setImageWithURL:[NSURL URLWithString:item[@"img"]] placeholder:MYGetImage(@"opening_notice_placeholder")];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenW-30, self.scrollView.height);
    layout.itemSpacing = 5;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.minimumAlpha = 0.94;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    // gameinfo
    NSDictionary * item = self.swiper[index];
    [self jumpForType:item];
}

#pragma mark - 图片的点击事件
- (void)imagViewClick
{
    NSDictionary * item = self.swiper[0];
    [self jumpForType:item];
}

- (void)jumpForType:(NSDictionary *)item
{
    NSString * type = item[@"type"];
    if ([type isEqualToString:@"game_info"]) {
        
        [MyAOPManager gameRelateStatistic:@"ClickHomeFeaturedBanner" GameInfo:item[@"gameinfo"] Add:@{}];
        
        GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
        detail.gameID = item[@"gameinfo"][@"game_id"];
        detail.hidesBottomBarWhenPushed = true;
        [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:true];
    }else if([type isEqualToString:@"special"]){
        if (item[@"title"])
        {
            [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:@{@"title":item[@"title"], @"clickIndex":@"home"}];
            
            [MyAOPManager relateStatistic:@"ClickHomeFeaturedBanner" Info:@{@"title":item[@"title"], @"clickIndex":@"home"}];
        }
        MyProjectGameController * project = [MyProjectGameController new];
        project.hidesBottomBarWhenPushed = YES;
        project.project_id = item[@"id"];
        [[YYToolModel getCurrentVC].navigationController pushViewController:project animated:YES];
    }else if([type isEqualToString:@"activity"]){
        
        [MyAOPManager relateStatistic:@"ClickHomeFeaturedBanner" Info:@{@"title":@"活动"}];
        
        if (![YYToolModel isAlreadyLogin]) return;
        NSString * url = [NSString stringWithFormat:@"%@?username=%@&token=%@", item[@"value"], [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.urlString = url;
        [[YYToolModel getCurrentVC].navigationController pushViewController:webVC animated:YES];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic[@"banner"];
    self.swiper = dataDic[@"swiper_920"];
    [self.scrollView reloadData];
    self.sectionTitleArray = dataDic[@"topItems"];
    
    CGFloat viewHeight = kScreenW * 920 / 750;
    if (self.sectionTitleArray.count < 6)
    {
        self.lineView_top.constant = 5;
        self.lineView.hidden = YES;
        self.height = viewHeight - 12;
    }
    else
    {
        self.lineView_top.constant = 17;
        self.lineView.hidden = NO;
        self.height = viewHeight;
    }
    [self.collectionView reloadData];
    
    if (self.swiper.count > 0)
    {
        NSDictionary * dic = self.swiper[0];
        [self.headerImageView yy_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholder:MYGetImage(@"opening_notice_placeholder")];
        
        UIColor * color = [UIColor colorWithHexString:dic[@"color"]];
        self.gradientLayer1.colors = @[(__bridge id)[color colorWithAlphaComponent:1].CGColor,(__bridge id)[color colorWithAlphaComponent:0].CGColor];
        
        NSString * type = dic[@"type"];
        if ([type isEqualToString:@"game_info"])
        {
            [MyAOPManager gameRelateStatistic:@"ShowHomeFeaturedBanner" GameInfo:dic[@"gameinfo"] Add:@{}];
        }
        else if ([type isEqualToString:@"special"])
        {
            [MyAOPManager relateStatistic:@"ShowHomeFeaturedBanner" Info:@{@"title":dic[@"title"]}];
        }
        else if ([type isEqualToString:@"activity"])
        {
            [MyAOPManager relateStatistic:@"ShowHomeFeaturedBanner" Info:@{@"title":@"活动"}];
        }
    }
    [self layoutIfNeeded];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionTitleArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyHomeTopFunctionCell";
    MyHomeTopFunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.cellBtn.tag = indexPath.item;
    cell.indexPath = indexPath;
    cell.dataDic = self.sectionTitleArray[indexPath.item];
    cell.cellBtnBlock = ^(NSInteger index) {
        [self pushToVc:index];
    };
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / 5, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    [self pushToVc:indexPath.item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat off_x = scrollView.contentOffset.x * 20 / (scrollView.contentSize.width - scrollView.width);
    self.lineView_x.constant = off_x;
    //为了不让一级菜单自动滚动闪而添加
    if (!self.isScroll)
    {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]]];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
}

- (void)pushToVc:(NSInteger)index
{
    NSDictionary * dic = self.sectionTitleArray[index];
    //统计
//    [MyAOPManager userInfoRelateStatistic:dic[@"aop"]];
    
    UIViewController * vc = [YYToolModel getCurrentVC];
    NSString * jumpType = dic[@"jumpType"];
    /**
     
     省钱卡           mcard   ( 客户端判断, 如果当前已登录, 用户是vip, 则跳省钱卡, 否则跳vip )
     免费领券        freeReceiveVoucher
     专题               special
     账号交易        trade
     今日开服        openServer
     活动               webview
     
     */
    NSString * title = dic[@"title"];
    [MyAOPManager relateStatistic:@"ClickIconOfHomePage" Info:@{@"icon":![YYToolModel isBlankString:title] ? title : jumpType}];
    
    if ([[dic objectForKey:@"isCheckLogin"] boolValue] && ![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    NSArray * array = @[@"goldMall", @"share", @"noviceTask", @"rechargeVip",@"tradeGoods"];
    if ([jumpType isEqualToString:@"mcard"]) {
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = 0;
        payVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:payVC animated:YES];
    }else if([jumpType isEqualToString:@"freeReceiveVoucher"]){
        MyHomeCouponCenterController * payVC = [[MyHomeCouponCenterController alloc]init];
        payVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:payVC animated:YES];
    }else if([jumpType isEqualToString:@"special"]){
        if ([dic[@"style"] intValue] == 6) {
            InternalTestingViewController * detail = [[InternalTestingViewController alloc] init];
            detail.Id = dic[@"id"];
            detail.hidesBottomBarWhenPushed = true;
            [YYToolModel.getCurrentVC.navigationController pushViewController:detail animated:YES];
            return;
        }
        if (dic[@"title"])
        {
            [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:@{@"title":dic[@"title"], @"clickIndex":@"home"}];
        }
        MyProjectGameController * project = [MyProjectGameController new];
        project.hidesBottomBarWhenPushed = YES;
        project.project_id = dic[@"id"];
        [[YYToolModel getCurrentVC].navigationController pushViewController:project animated:YES];
        
    }else if([jumpType isEqualToString:@"trade"]){
        TransactionViewController * payVC = [[TransactionViewController alloc]init];
        payVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:payVC animated:YES];
    }else if([jumpType isEqualToString:@"openServer"]){
        MyOpenServiceListController * payVC = [[MyOpenServiceListController alloc]init];
        payVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:payVC animated:YES];
    }else if([jumpType isEqualToString:@"webview"] || [jumpType isEqualToString:@"syGift"]){
        NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", dic[@"url"], [dic[@"url"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        WebViewController * web = [[WebViewController alloc]init];
        web.urlString = url;
        web.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:web animated:YES];
    }else if([jumpType isEqualToString:@"video"]){
        AwemeListController * web = [[AwemeListController alloc]init];
        web.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:web animated:YES];
    }else if([jumpType isEqualToString:@"active_novice"]){
        if ([dic[@"version"] integerValue] == 1)
        {
            if ([YYToolModel isAlreadyLogin]) return;
            NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", dic[@"url"], [dic[@"url"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
            UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
            pay.loadUrl = url;
            pay.isFullScreen = YES;
            pay.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
        }
        else
        {
            NewExclusiveViewController * web = [[NewExclusiveViewController alloc]init];
            web.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:web animated:YES];
        }
    }else if([jumpType isEqualToString:@"active_flyback"]){
        
        if ([dic[@"version"] integerValue] == 1)
        {
            NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", dic[@"url"], [dic[@"url"] containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
            UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
            pay.loadUrl = url;
            pay.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
        }
        else
        {
            MyUserReturnController * web = [[MyUserReturnController alloc]init];
            web.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:web animated:YES];
        }
    }
    else if([array containsObject:jumpType])
    {
        [[YYToolModel shareInstance] showUIFortype:jumpType Parmas:@""];
    }
    else
    {
        NSString *className = jumpType;
        Class class = NSClassFromString(className);
        if (class && className) {
            BaseViewController *ctrl = class.new;
            ctrl.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:ctrl animated:YES];
        }
    }
//    //跳转
//    NSString *className = dic[@"vc"]; //classNames 字符串数组集
//    NSDictionary * info = [YYToolModel getUserdefultforKey:@"member_info"];
//    if ([className isEqualToString:@"UserPayGoldViewController"] || [className isEqualToString:@"MyLimitedBuyingController"])
//    {
//        if (![YYToolModel islogin])
//        {
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            loginVC.hidesBottomBarWhenPushed = YES;
//            [vc.navigationController pushViewController:loginVC animated:YES];
//            return;
//        }
//        else if ([YYToolModel isBlankString:info[@"mobile"]] && [className isEqualToString:@"MyLimitedBuyingController"])
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
//                bindVC.hidesBottomBarWhenPushed = YES;
//                [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
//            });
//            [MBProgressHUD showToast:@"请先绑定手机号"];
//            return;
//        }
//    }
//    else if ([className isEqualToString:@"project_id"])
//    {
//        MyProjectGameController * project = [MyProjectGameController new];
//        project.project_id = dic[@"id"];
//        project.project_title = dic[@"title"];
//        project.hidesBottomBarWhenPushed = YES;
//        [vc.navigationController pushViewController:project animated:YES];
//        return;
//    }
//    if ([className isEqualToString:@"UserPayGoldViewController"])
//    {
//        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
//        payVC.selectedIndex = 0;
//        payVC.hidesBottomBarWhenPushed = YES;
//        [vc.navigationController pushViewController:payVC animated:YES];
//    }
//    else
//    {
//        Class class = NSClassFromString(className);
//        if (class && className) {
//            BaseViewController *ctrl = class.new;
//            ctrl.hidesBottomBarWhenPushed = YES;
//            [vc.navigationController pushViewController:ctrl animated:YES];
//        }
//    }
}

@end
