//
//  MyGameHallSubsectionController.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGameHallSubsectionController.h"
#import "MyNewGameHallController.h"

#import "YHSegmentView.h"
#import "MySelectGameTypeView.h"
#import "CGXPopoverView.h"
#import "HGNavbarSearchView.h"
#import "MyGameHallTypeView.h"

@interface MyGameHallSubsectionController ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) NSArray * vcArray;
@property (nonatomic, strong) NSMutableArray * itemArray;
@property (nonatomic, strong) MyNewGameHallController * hallVc;
@property (nonatomic, copy) NSString *game_species_type;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic , strong) CGXPopoverManager *manager;
@property (nonatomic , strong) CGXPopoverManager *managerKaifu;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) YHSegmentView *segmentView;
@property (nonatomic, strong) UIButton * typeButton;
/** 是否是首页点击游戏类型 */
@property (nonatomic, assign) BOOL isHomeSelect;
@property (nonatomic, strong) MyGameHallTypeView * typeView;
/** 是否选择游戏类型 */
@property (nonatomic, assign) BOOL isSelectType;

@end

@implementation MyGameHallSubsectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self layoutUI];
    
    [self addNavbarRightView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计
    [self UmStatistic:self.selectedIndex == -1 ? 0 : self.selectedIndex];
}

- (void)prepareBasic
{
    [MyAOPManager relateStatistic:@"FindGameViewAppear" Info:@{}];
    self.navBar.backgroundColor = MAIN_COLOR;
    self.navBar.titleLable.hidden = YES;
    self.game_species_type = @"1";
    self.selectedIndex = -1;
    [DeviceInfo shareInstance].isClickGameHall = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameHallUITask:) name:@"gameHallUITack" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectGameType:) name:@"selectGameType" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAction:) name:NSStringFromClass([self class]) object:nil];
}

#pragma mark ——— 单击指定双击刷新
- (void)scrollTopAction:(NSNotification *)noti
{
    [self.hallVc.hallListView1.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSNumber * number = noti.object;
    //双击刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([number boolValue])
        {
            [self.hallVc.hallListView1.tableView.mj_header beginRefreshing];
        }
    });
}

#pragma mark — 首页热门分类的选择
- (void)selectGameType:(NSNotification *)noti
{
    self.isHomeSelect = YES;
    NSString * typeId = noti.object;
    [self.segmentView setSelectedItemAtIndex:0];
    
    MyNewGameHallController * hallVc = self.vcArray[0];
    hallVc.hallListView1.typeId = typeId;
}

- (void)gameHallUITask:(NSNotification *)noti
{
    NSString * type = noti.object;
    [self.segmentView setSelectedItemAtIndex:type.integerValue];
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
                [weakSelf refreshData:type];
            }
        };
        [self.view addSubview:_typeView];
    }
    return _typeView;
}

- (void)addNavbarRightView
{
    HGNavbarSearchView * view = [[HGNavbarSearchView alloc] initWithFrame:CGRectMake(kScreenW - 76.5, self.navBar.height - 44, 76.5, 44)];
    view.currentVC = self;
    view.isVideo = NO;
    view.SearchBtnClick = ^(BOOL value) {
    };
    [self.navBar addSubview:view];
    
    UIButton * typeBtn = [UIControl creatButtonWithFrame:CGRectMake((self.navBar.width - 85) / 2, self.navBar.height - 44, 85, 44) backgroundColor:[UIColor clearColor] title:@"BT游戏" titleFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] actionBlock:^(UIControl *control) {
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
    }];
    [typeBtn setImage:MYGetImage(@"game_type_normal") forState:UIControlStateNormal];
    [typeBtn setImage:MYGetImage(@"game_type_selected") forState:UIControlStateSelected];
    [typeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
    [self.navBar addSubview:typeBtn];
    self.typeButton = typeBtn;
}

- (void)layoutUI
{
    NSString * typeId = [YYToolModel getUserdefultforKey:@"HomeGameTypeClick"];
    //设置标题
    NSArray *titleArr = @[@"分类".localized, @"热门榜".localized, @"新游榜".localized];
    //设置控制器
    MyNewGameHallController * hallVc  = [MyNewGameHallController new];
    MyNewGameHallController * hallVc1 = [MyNewGameHallController new];
    MyNewGameHallController * hallVc2 = [MyNewGameHallController new];
    hallVc.type = @"";
    hallVc1.type = @"2";
    hallVc2.type = @"3";
    hallVc.typeId = typeId ?:@"-1";

    self.vcArray = @[hallVc, hallVc1, hallVc2];
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) ViewControllersArr:[self.vcArray copy] TitleArr:titleArr TitleNormalSize:14 TitleSelectedSize:14 SegmentStyle:YHSegementStyleIndicate ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
        
        self.hallVc = self.vcArray[index];
        [self refreshData:NO];
        
        self.selectedIndex = index;
        self.isHomeSelect = NO;
        
        //统计
        [self UmStatistic:index];
    }];
    segmentView.spaceView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    segmentView.yh_indicateStyle = YHSegementIndicateStyleDefine;
    segmentView.yh_segmentIndicateWidth = 28;
    segmentView.yh_segmentIndicateHeight = 3;
    segmentView.yh_segmentIndicateBottom = 8;
    segmentView.yh_segmentTintColor = [UIColor colorWithHexString:@"#FFC000"];
    segmentView.yh_titleNormalColor = [UIColor colorWithHexString:@"#282828"];
    segmentView.yh_titleSelectedColor = [UIColor colorWithHexString:@"#282828"];
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
}

#pragma mark — 刷新数据
- (void)refreshData:(BOOL)isRefresh
{
    if ([self.hallVc isKindOfClass:[MyNewGameHallController class]])
    {
        if (isRefresh)
        {
            self.hallVc.hallListView1.game_species_type = self.game_species_type;
            self.hallVc.game_species_type = self.game_species_type;
            [self.hallVc.hallListView1.tableView.mj_header beginRefreshing];
        }
        else
        {
            if (![self.hallVc.game_species_type isEqualToString:self.game_species_type])
            {
                self.hallVc.hallListView1.game_species_type = self.game_species_type;
                self.hallVc.game_species_type = self.game_species_type;
                self.hallVc.hallListView1.pageNumber = 1;
                [self.hallVc.hallListView1 gameTypeRequestList:nil Hud:YES];
            }
        }
    }
    else
    {
//        NewsSubsectionViewController * vc = self.vcArray[3];
//        [vc refreshData:self.game_species_type];
    }
}

#pragma mark — 友盟统计
- (void)UmStatistic:(NSInteger)index
{
    //友盟统计
    NSString * str = @"";
    switch (index)
    {
        case 0:
            str = @"BrowseTheGameCategoryListPage";
            break;
        case 1:
            str = @"BrowseTheHotGameListPage";
            break;
        case 2:
            str = @"BrowseTheNewGameListPage";
            break;
        case 3:
            str = @"BrowseTodayServiceListPage";
            break;
            
        default:
            break;
    }
    [MyAOPManager relateStatistic:str Info:@{}];
}

@end
