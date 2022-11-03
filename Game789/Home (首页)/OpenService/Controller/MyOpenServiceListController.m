//
//  MyOpenServiceListController.m
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyOpenServiceListController.h"
#import "MyTadayOpenServiceController.h"
#import "MyGameTypesViewController.h"
#import "YHSegmentView.h"

@interface MyOpenServiceListController ()

@property (nonatomic, strong) NSMutableArray * vcArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *game_classify_id;

@end

@implementation MyOpenServiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"开服表";
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBar.lineView.backgroundColor = FontColorDE;
    self.game_classify_id = @"";
    
    WEAKSELF
    self.navBar.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.navBar wr_setRightButtonWithImage:MYGetImage(@"trade_filter_icon")];
    [self.navBar setOnClickRightButton:^{
        MyGameTypesViewController * type = [MyGameTypesViewController new];
        type.game_classify_id = weakSelf.game_classify_id;
        type.SureBtnClick = ^(NSDictionary * _Nonnull typeDic) {
            MyTadayOpenServiceController * vc = weakSelf.vcArray[weakSelf.selectedIndex];
            weakSelf.game_classify_id = typeDic[@"game_classify_id"];
            vc.game_classify_id = typeDic[@"game_classify_id"];
            [vc.tableView.mj_header beginRefreshing];
        };
        [weakSelf presentViewController:type animated:YES completion:^{
            
        }];
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSegmentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //统计进入新游首发页面事件
    [MyAOPManager relateStatistic:@"BrowseTodayServiceListPage" Info:@{}];
}

- (NSArray *)getArrayTitles
{
    return @[@"今日开服", @"即将开服", @"历史开服"];
}

- (NSMutableArray *)getArrayVCs
{
    MyTadayOpenServiceController * vc = [MyTadayOpenServiceController new];
    vc.type = @"10";
    vc.game_classify_id = self.game_classify_id;
    MyTadayOpenServiceController * vc1 = [MyTadayOpenServiceController new];
    vc1.type = @"20";
    vc1.game_classify_id = self.game_classify_id;
    MyTadayOpenServiceController * vc2 = [MyTadayOpenServiceController new];
    vc2.type = @"30";
    vc2.game_classify_id = self.game_classify_id;
    self.vcArray = [NSMutableArray arrayWithObjects:vc, vc1, vc2, nil];
    return self.vcArray;
}

- (void)creatSegmentView
{
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) ViewControllersArr:[self getArrayVCs] TitleArr:[self getArrayTitles] TitleNormalSize:13 TitleSelectedSize:16 SegmentStyle:YHSegementStyleIndicate ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
        self.selectedIndex = index;
        MyTadayOpenServiceController * vc = self.vcArray[index];
        if (vc.game_classify_id.integerValue != self.game_classify_id.integerValue || !vc.isAllLoad)
        {
            vc.isAllLoad = YES;
            vc.game_classify_id = self.game_classify_id;
            [vc kaiFuApiRequest:nil Hud:YES];
        }
    }];
    segmentView.yh_indicateStyle = YHSegementIndicateStyleDefine;
    segmentView.yh_segmentIndicateWidth = 28;
    segmentView.yh_segmentIndicateHeight = 3;
    segmentView.yh_segmentIndicateBottom = 8;
    segmentView.spaceView.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
    segmentView.yh_segmentTintColor = [UIColor colorWithHexString:@"#FFC000"];
    segmentView.yh_titleNormalColor = [UIColor colorWithHexString:@"#999999"];
    segmentView.yh_titleSelectedColor = [UIColor colorWithHexString:@"#282828"];
//    [segmentView setYh_defaultSelectIndex:0];
    [self.view addSubview:segmentView];
}

@end
