//
//  MyActivityGuideController.m
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyActivityGuideController.h"
#import "SGPageTitleView.h"
#import "SGPageTitleViewConfigure.h"
#import "MyActivityGuideListView.h"
#import "MyActivityGuideApi.h"
@interface MyActivityGuideController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation MyActivityGuideController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    
    MyActivityGuideApi * api = [[MyActivityGuideApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.count = 15;
    api.type = @"raiders";
    api.game_id = self.game_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1) {
            NSArray * array = api.data[@"list"];
            
            self.introduction_count = array.count;
        }
        [self loadUI];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [self loadUI];
    }];
    
    
}

- (void)loadUI{
    if (self.introduction_count > 0) {
        self.horButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.horButton.selected = YES;
        self.selectedButton = self.horButton;
        self.backView_top.constant = kNavigationBarHeight;
        
        [self.view addSubview:self.scrollView];
    }else{
        MyActivityGuideListView * listView = [[MyActivityGuideListView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin)];
        listView.currentVC = self;
        listView.game_id = self.game_id;
        listView.gameInfo = self.gameInfo;
        listView.isLoaded = YES;
        listView.type = @"";
        [self.view addSubview:listView];
    }
}

- (void)prepareBasic
{
    self.navBar.title = self.gameInfo[@"game_name"];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + self.backView.height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - kTabbarSafeBottomMargin - view_top)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenW * 2, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < 2; i ++)
        {
            MyActivityGuideListView * listView = [[MyActivityGuideListView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.currentVC = self;
            listView.index = i + 1;
            listView.tag = i + 20;
            listView.game_id = self.game_id;
            listView.gameInfo = self.gameInfo;
            if (i == 0)
            {
                listView.isLoaded = YES;
                listView.type = @"activity";
            }
            else
            {
                listView.type = @"raiders";
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
    [self.selectedButton setTitleColor:FontColor66 forState:0];
    button.selected = YES;
    [button setTitleColor:FontColor28 forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.selectedButton = button;
    
    MyActivityGuideListView * listView = [self.view viewWithTag:button.tag + 10];
    if (!listView.isLoaded)
    {
        listView.isLoaded = YES;
    }
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
}

@end
