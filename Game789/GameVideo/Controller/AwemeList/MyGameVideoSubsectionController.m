//
//  MyGameVideoSubsectionController.m
//  Game789
//
//  Created by Maiyou on 2020/4/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameVideoSubsectionController.h"
#import "AwemeListController.h"
#import "MyGameVideoTrackController.h"

#import "YHSegmentView.h"

@interface MyGameVideoSubsectionController ()

@property (nonatomic, strong) NSArray * vcArray;
@property (nonatomic, strong) UIButton * rightBtn;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MyGameVideoSubsectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor   = [UIColor blackColor];
    self.navBar.hidden = YES;
    
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MYLog(@"viewWillAppear");
    
    NSNumber * num = [YYToolModel getUserdefultforKey:@"SaveDanmuStatus"];
    if (num != NULL)
    {
        self.rightBtn.selected = num.boolValue;
    }
    else
    {
        self.rightBtn.selected = YES;
        [YYToolModel saveUserdefultValue:[NSNumber numberWithBool:self.navBar.rightButton.selected] forKey:@"SaveDanmuStatus"];
    }
    

    MyGameVideoTrackController * track = (MyGameVideoTrackController *)self.vcArray[1];
    if (track && self.selectedIndex == 1)
    {
        [track.collectionView.mj_header beginRefreshing];
    }
}

- (void)layoutUI
{
    //设置标题
    NSArray *titleArr = @[@"推荐".localized, @"足迹".localized];
    //设置控制器
    AwemeListController * hallVc  = [AwemeListController new];
    MyGameVideoTrackController * track = [MyGameVideoTrackController new];
    
    self.vcArray = @[hallVc, track];
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarHeight) ViewControllersArr:[self.vcArray copy] TitleArr:titleArr TitleNormalSize:17 TitleSelectedSize:17 SegmentStyle:YHSegementStyleSpace ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
        self.selectedIndex = index;
        AwemeListController * list = (AwemeListController *)self.vcArray[0];
        AwemeListCell *cell = [list.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:list.currentIndex inSection:0]];
        index == 0 ? [cell play:NO] : [cell pause];
        self.rightBtn.hidden = index;
        if (index == 1)
        {
            [track.collectionView.mj_header beginRefreshing];
        }
    }];
    segmentView.spaceView.hidden = YES;
    segmentView.yh_bgColor = [UIColor blackColor];
    segmentView.yh_titleNormalColor = [UIColor colorWithHexString:@"#666666"];
    segmentView.yh_titleSelectedColor = [UIColor whiteColor];
    [segmentView setYh_defaultSelectIndex:0];
    [self.view addSubview:segmentView];
    
    UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenW / 2 - 0.5, (44 - 15) / 2, 1, 15)];
    sepLine.backgroundColor = [UIColor whiteColor];
    [segmentView addSubview:sepLine];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(segmentView.width - 40, (44 - 30) / 2, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"danmu_close_bg"] forState:0];
    [rightBtn setImage:[UIImage imageNamed:@"danmu_open_bg"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:rightBtn];
    self.rightBtn = rightBtn;
}

- (void)rightBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [YYToolModel saveUserdefultValue:[NSNumber numberWithBool:sender.selected] forKey:@"SaveDanmuStatus"];
    
    //获取当前显示的cell
    AwemeListController * track = (AwemeListController *)self.vcArray[0];
    AwemeListCell *cell = [track.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:track.currentIndex inSection:0]];
    if (sender.selected)
    {
        [cell play:NO];
    }
    else
    {
        cell.showIndex = 0;
        [cell.barrageManager stop];
        
        [[MyVideoPlayerManager shareManager].barrageArray enumerateObjectsUsingBlock:^(OCBarrageManager * obj, NSUInteger idx, BOOL *stop) {
            [obj stop];
        }];
    }
}

@end
