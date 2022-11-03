//
//  MyRecycleRecordsController.m
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRecycleRecordsController.h"
#import "MyRecycleRecordsView.h"

@interface MyRecycleRecordsController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation MyRecycleRecordsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"回收记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedButton = self.horButton;
    self.horButton.selected = YES;
    self.horButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.backView_top.constant = kNavigationBarHeight;
    
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
        _scrollView.contentSize = CGSizeMake(kScreenW * 3, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < 3; i ++)
        {
            MyRecycleRecordsView * listView = [[MyRecycleRecordsView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.currentVC = self;
            listView.index = i + 1;
            listView.tag = i + 20;
            listView.backgroundColor = UIColor.whiteColor;
            if (i == 0)
            {
                listView.isLoaded = YES;
                listView.isRedeem = @"1";
            }
            else if (i == 1)
            {
                listView.isRedeemed = @"1";
            }
            else if (i == 2)
            {
                listView.isRedeem = @"0";
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
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.selectedButton = button;
    
    MyRecycleRecordsView * listView = [self.view viewWithTag:button.tag + 10];
    if (!listView.isLoaded)
    {
        listView.isLoaded = YES;
    }
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
}

@end
