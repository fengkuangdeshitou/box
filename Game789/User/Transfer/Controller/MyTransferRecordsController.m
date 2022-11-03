//
//  MyTransferRecordsController.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferRecordsController.h"

#import "MyTransferRecordListView.h"

@interface MyTransferRecordsController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation MyTransferRecordsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"转游记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.topView_top.constant = kStatusBarAndNavigationBarHeight;
    
    self.selectedButton = self.horButton;
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + 48;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - view_top)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreenW * 4, _scrollView.height);
        
        for (int i = 0; i < 4; i ++)
        {
            MyTransferRecordListView * listView = [[MyTransferRecordListView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.index = i;
            listView.tag = i + 20;
            listView.currentVC = self;
            if (i == 0)
            {
                listView.isLoaded = YES;
            }
            if (i == 1)
            {
                listView.y = 25;
                listView.height = _scrollView.height - 25;
                UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, 25)];
                tipLabel.text = @"温馨提示:左滑即可撤销该记录";
                tipLabel.font = [UIFont systemFontOfSize:14];
                tipLabel.textColor = [UIColor redColor];
                tipLabel.textAlignment = NSTextAlignmentCenter;
                [_scrollView addSubview:tipLabel];
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
    
    MyTransferRecordListView * listView = [self.view viewWithTag:button.tag + 10];
    if (!listView.isLoaded)
    {
        listView.isLoaded = YES;
    }
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
    
//    //统计页面
//    NSString * str = @"";
//    if (button.tag - 10 == 0)
//    {
//        str = @"BrowseMyVouchers_Available";
//    }
//    else if (button.tag - 10 == 1)
//    {
//        str = @"BrowseMyVoucher_Used";
//    }
//    else if (button.tag - 10 == 2)
//    {
//        str = @"BrowseMyVoucher_Expired";
//    }
//    [MyAOPManager relateStatistic:str Info:@{}];
}

@end
