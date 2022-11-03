//
//  MyCollectionCenterController.m
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyCollectionCenterController.h"

#import "MyCollectionCenterListView.h"

@interface MyCollectionCenterController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) MyCollectionCenterListView * listView;

@end

@implementation MyCollectionCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"我的游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.horButton.selected = YES;
    self.horButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.horButton setTitleColor:FontColor28 forState:0];
    self.selectedButton = self.horButton;
    self.backView_top.constant = kNavigationBarHeight;
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_listView.isLoaded)
    {
        [self.listView.tableView.mj_header beginRefreshing];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + self.backView.height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - kTabbarSafeBottomMargin - view_top)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenW * 3, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < 3; i ++)
        {
            MyCollectionCenterListView * listView = [[MyCollectionCenterListView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.currentVC = self;
            listView.index = i;
            listView.tag = i + 200;
            if (i == 0)
            {
                listView.isLoaded = YES;
                self.listView = listView;
            }
            [_scrollView addSubview:listView];
        }
    }
    return _scrollView;
}

- (IBAction)buttonClick:(id)sender
{
    UIButton * button = sender;
    if (self.selectedButton != button)
    {
        [self changeButtonStatus:button];
    }
    self.scrollView.contentOffset = CGPointMake(kScreenW * (button.tag - 100), 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / kScreenW;
    UIButton * button = [self.view viewWithTag:index + 100];
    
    [self changeButtonStatus:button];
}

- (void)changeButtonStatus:(UIButton *)button
{
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectedButton setTitleColor:FontColor66 forState:0];
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [button setTitleColor:FontColor28 forState:0];
    self.selectedButton = button;
    
    MyCollectionCenterListView * listView = [self.view viewWithTag:button.tag + 100];
    if (!listView.isLoaded)
    {
        listView.isLoaded = YES;
    }
    self.listView = listView;
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
}

@end
