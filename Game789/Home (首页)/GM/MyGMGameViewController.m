//
//  MyGMGameViewController.m
//  Game789
//
//  Created by Maiyou on 2019/5/29.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGMGameViewController.h"
#import "MyGMGameListView.h"

@interface MyGMGameViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * selectedButton;

@end

@implementation MyGMGameViewController

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50 + kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - 50 - kTabbarSafeBottomMargin - kStatusBarAndNavigationBarHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenW * 2, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        for (int i = 0; i < 2; i ++)
        {
            MyGMGameListView * listView = [[MyGMGameListView alloc] initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, _scrollView.height) Tag:20 + i];
            listView.currentVC = self;
            [_scrollView addSubview:listView];
        }
    }
    return _scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"GM游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topView_top.constant = kStatusBarAndNavigationBarHeight;
    self.selectedButton = [self.view viewWithTag:10];
    self.selectedButton.selected = YES;
    
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //主要是为了刷新下载进度条
    MyGMGameListView * listView = [self.view viewWithTag:20];
    [listView.tableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIButton * button = [self.view viewWithTag:index + 10];
    [self lineViewAnimate:button];
}

- (IBAction)switchTitleClick:(id)sender
{
    UIButton * button = sender;
    [self lineViewAnimate:sender];
    self.scrollView.contentOffset = CGPointMake(kScreenW * (button.tag - 10), 0);
}

- (void)lineViewAnimate:(UIButton *)button
{
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    } completion:^(BOOL finished) {
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
    }];
}

@end
