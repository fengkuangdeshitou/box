//
//  MyOrderDetailListController.m
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyOrderDetailListController.h"
#import "MyOrderDetailListView.h"

@interface MyOrderDetailListController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation MyOrderDetailListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.navBar.title = @"我的账单";
    
    self.selectedButton = self.horButton;
    self.backView_top.constant = kNavigationBarHeight;
    for (int i = 0; i < 4; i ++)
    {
        UIButton * button = [self.backView viewWithTag:i + 10];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + self.backView.height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - kTabbarSafeBottomMargin - view_top)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenW * 4, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < 4; i ++)
        {
            MyOrderDetailListView * listView = [[MyOrderDetailListView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.currentVC = self;
            listView.index = i;
            listView.tag = i + 20;
            if (i == 0)
            {
                listView.isLoaded = YES;
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
    self.scrollView.contentOffset = CGPointMake(kScreenW * (button.tag - 10), 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / kScreenW;
    UIButton * button = [self.view viewWithTag:index + 10];
    
    [self changeButtonStatus:button];
    
}

- (void)changeButtonStatus:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    MyOrderDetailListView * listView = [self.view viewWithTag:button.tag + 10];
    if (!listView.isLoaded)
    {
        listView.isLoaded = YES;
    }
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
}

@end
