//
//  MyNewGameHallController.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewGameHallController.h"
#import "GetGameListApi.h"
#import "NoNetwrokView.h"
#import "HGNavbarSearchView.h"
#import "MyGameHallTypeView.h"

@interface MyNewGameHallController ()<NoNetwrokViewDelegate>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) NoNetwrokView * noNetwork;
@property (nonatomic, strong) MyGameHallTypeView * typeView;
/** 是否选择游戏类型 */
@property (nonatomic, assign) BOOL isSelectType;
@property (nonatomic, strong) UIButton * typeButton;

@end

@implementation MyNewGameHallController

- (MyGameHallListView *)hallListView1
{
    if (!_hallListView1)
    {
        _hallListView1 = [[MyGameHallListView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, ScreenHeight - kStatusBarAndNavigationBarHeight-kTabbarHeight)];
        _hallListView1.game_species_type = self.game_species_type;
        _hallListView1.currentVC = self;
        _hallListView1.type = self.type;
        _hallListView1.typeId = self.typeId;
//        [_hallListView1.tableView.mj_header beginRefreshing];
        [self.view addSubview:_hallListView1];
    }
    return _hallListView1;
}

- (NoNetwrokView *)noNetwork{
    if (!_noNetwork) {
        _noNetwork = [NoNetwrokView sharedInstance];
    }
    _noNetwork.delegate = self;
    return _noNetwork;
}

- (void)onAgainRequestAction{
    [self gameTypeRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navBar.hidden = YES;
    
    [self setLayoutUI];
    
    [self addNavbarRightView];
    
    NSArray * array = [YYToolModel getCacheData:MiluGameTypeListCache];
    if (array)
    {
        [self gameTypeParmasData:array];
    }
    [self gameTypeRequest];
}

- (void)setLayoutUI
{
    self.navBar.backgroundColor = MAIN_COLOR;
    self.navBar.titleLable.hidden = YES;
    self.game_species_type = @"1";
    self.type = @"";
    
    NSString * typeId = [YYToolModel getUserdefultforKey:@"HomeGameTypeClick"];
    self.typeId = typeId ?:@"-1";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectGameType:) name:@"selectGameType" object:nil];
}

#pragma mark — 首页热门分类的选择
- (void)selectGameType:(NSNotification *)noti
{
    UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
    DWTabBarController * tabarVc = (DWTabBarController *)nav.tabBarController;
    tabarVc.selectedVc = self;
    
    NSString * typeId = noti.object;
    self.hallListView1.typeId = typeId;
}

#pragma mark - 懒加载
- (MyGameHallTypeView *)typeView
{
    if (!_typeView)
    {
        WEAKSELF
        _typeView = [[MyGameHallTypeView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight)];
        _typeView.selectGameTypeBlock = ^(NSString * _Nonnull type, NSString * _Nonnull title) {
            weakSelf.isSelectType = !weakSelf.isSelectType;
            weakSelf.typeButton.selected = weakSelf.isSelectType;
            if (type)
            {
                [MyAOPManager relateStatistic:@"ClickGamHallType" Info:@{@"type":title}];
                weakSelf.game_species_type = type;
                [weakSelf.typeButton setTitle:title forState:0];
                [weakSelf.typeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
                weakSelf.hallListView1.game_species_type = weakSelf.game_species_type;
                weakSelf.game_species_type = weakSelf.game_species_type;
                [weakSelf.hallListView1.tableView.mj_header beginRefreshing];
            }
        };
        [self.view addSubview:_typeView];
    }
    return _typeView;
}

- (void)addNavbarRightView
{
    HGNavbarSearchView * view = [[HGNavbarSearchView alloc] initWithFrame:CGRectMake(kScreenW - 76.5, kStatusBarAndNavigationBarHeight - 44, 76.5, 44)];
    view.currentVC = self;
    view.isVideo = NO;
    view.SearchBtnClick = ^(BOOL value) {
    };
    [self.navBar addSubview:view];
    
    NSDictionary * dic = [DeviceInfo shareInstance].data;
    BOOL is_open_discount = [dic[@"is_open_discount"] boolValue];
    BOOL is_open_h5 = [dic[@"is_open_h5"] boolValue];
    
    UIButton * typeBtn = [UIControl creatButtonWithFrame:CGRectMake((self.navBar.width - 85) / 2, self.navBar.height - 44, 85, 44) backgroundColor:[UIColor clearColor] title:@"BT游戏" titleFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] actionBlock:^(UIControl *control) {
        if (is_open_discount || is_open_h5)
        {
            if (self.isSelectType)
            {
                [self.typeView dismissView];
            }
            else
            {
                self.typeView.gameSpeciesType = self.game_species_type;
                [self.typeView showView];
            }
            self.isSelectType = !self.isSelectType;
            self.typeButton.selected = self.isSelectType;
        }
    }];
    if (is_open_discount || is_open_h5)
    {
        [typeBtn setImage:MYGetImage(@"game_type_normal") forState:UIControlStateNormal];
        [typeBtn setImage:MYGetImage(@"game_type_selected") forState:UIControlStateSelected];
        [typeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
    }
    [self.navBar addSubview:typeBtn];
    self.typeButton = typeBtn;
}

#pragma mark - 获取所有游戏类型
- (void)gameTypeRequest
{
    GetGameListApi *api = [[GetGameListApi alloc] init];
    api.pageNumber = 1;
    api.count = 500;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGameTypeListSuccess:api];
        [self.noNetwork dismiss];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [self.view addSubview:self.noNetwork];
        [self.noNetwork show];
    }];
}

- (void)handleGameTypeListSuccess:(GetGameListApi *)api
{
    if (api.success == 1)
    {
        NSArray * list = api.data[@"game_classify_list"];
        [YYToolModel saveCacheData:list forKey:MiluGameTypeListCache];
        
        [self gameTypeParmasData:list];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)gameTypeParmasData:(NSArray *)array
{
    [self segmentView:array];
    
    //获取缓存游戏大厅精选数据
    NSDictionary * dic = [YYToolModel getCacheData:MiluGameMallDataCache];
    if (dic)
    {
        [self.hallListView1 gameMallParmasData:dic];
    }else{
        [self.hallListView1 gameTypeRequestList:^(BOOL isSuccess) {

        } Hud:!dic];
    }
}

#pragma mark
- (void)segmentView:(NSArray *)arrayTitle
{
    NSMutableArray * titleArr = [NSMutableArray array];
    //获取类型
    for (int i = 0; i < arrayTitle.count; i++)
    {
        [titleArr addObjectsFromArray:arrayTitle[i][@"sub_classify_list"][0]];
    }
    [titleArr insertObject:@{@"game_classify_id":@"-1", @"game_classify_name":@"精选".localized} atIndex:0];
    self.segmentTitles = titleArr;
    
    self.hallListView1.typeArray = titleArr;
}

@end
