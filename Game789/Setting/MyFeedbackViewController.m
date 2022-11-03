//
//  MyFeedbackViewController.m
//  Game789
//
//  Created by Maiyou on 2019/3/4.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyFeedbackViewController.h"
#import "HXPhotoView.h"
#import "MyAllGameListController.h"
#import "MyGameFeedbackView.h"
#import "MyComplaintFeedbackView.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface MyFeedbackViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UITextField * textField1;
@property (nonatomic, strong) UITextField * textField2;

@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIView * topBackView;
@property (nonatomic, strong) UIView * topView1;
@property (nonatomic, strong) UIView * gameView;

@end

@implementation MyFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self layoutUI];
}

- (void)prepareBasic
{
    self.navBar.title = self.game_id ? @"游戏反馈" : @"投诉反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
}

- (void)layoutUI
{
    CGFloat topView_top = kStatusBarAndNavigationBarHeight;
    if (!self.gameName)
    {
        UIView * horiView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 50)];
        horiView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:horiView];
        
        NSArray * titles = @[@"游戏反馈".localized, @"投诉反馈".localized];
        for (int i = 0; i < titles.count; i ++)
        {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW / 2 * i, 0, kScreenW / 2, horiView.height)];
            [button setTitle:[titles[i] localized] forState:0];
            [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
            [button addTarget:self action:@selector(topTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 10;
            [horiView addSubview:button];
            
            if (i == 0)
            {
                button.selected = YES;
                self.selectedButton = button;
                button.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(button.center.x - 18 / 2, horiView.height - 12, 18, 3)];
                lineView.layer.masksToBounds = YES;
                lineView.layer.cornerRadius = 1.5;
                lineView.backgroundColor = MAIN_COLOR;
                [horiView insertSubview:lineView belowSubview:button];
                self.lineView = lineView;
            }
        }
        topView_top = CGRectGetMaxY(horiView.frame) + 0.5;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView_top, kScreenW, kScreenH - topView_top)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.game_id ? kScreenW : kScreenW * 2, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    MyGameFeedbackView * feedbackView = [[MyGameFeedbackView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, scrollView.height)];
    feedbackView.currentVC = self;
    feedbackView.game_id = self.game_id;
    feedbackView.gameName = self.gameName ? : @"";
    [scrollView addSubview:feedbackView];
    
    MyComplaintFeedbackView * complainView = [[MyComplaintFeedbackView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, scrollView.height)];
    complainView.currentVC = self;
    [scrollView addSubview:complainView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    UIButton * sender = [self.view viewWithTag:index + 10];
    [self topTitleButtonClick:sender];
}

- (void)topTitleButtonClick:(UIButton *)sender
{
    if (self.selectedButton != sender)
    {
        sender.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [sender setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
        self.selectedButton.selected = NO;
        self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        [self.selectedButton setTitleColor:[UIColor colorWithHexString:@"##999999"] forState:0];
        self.selectedButton = sender;
        
        [UIView animateWithDuration:0.26 animations:^{
            self.lineView.ly_centerX = sender.ly_centerX;
            self.scrollView.contentOffset = CGPointMake(kScreenW * (sender.tag - 10), 0);
        }];
    }
}

@end
