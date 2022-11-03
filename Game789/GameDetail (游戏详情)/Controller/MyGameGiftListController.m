//
//  MyGameGiftListController.m
//  Game789
//
//  Created by Maiyou001 on 2022/5/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyGameGiftListController.h"
#import "MyGiftViewController.h"

#import "MyGameGiftListView.h"
#import "GameDetailApi.h"
@class GetGameGiftApi;

@interface MyGameGiftListController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *horButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation MyGameGiftListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"游戏礼包";
    
    self.selectedButton = self.horButton;
    self.horButton.selected = YES;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.backView_top.constant = kNavigationBarHeight;
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"我的礼包" titleColor:[UIColor colorWithHexString:@"#999999"]];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navBar setOnClickRightButton:^{
        if ([YYToolModel isAlreadyLogin])
        {
            [weakSelf.navigationController pushViewController:[MyGiftViewController new] animated:YES];
        }
    }];
    
    [self.view addSubview:self.scrollView];
    
    [self getData];
}

- (void)getData
{
    GetGameGiftApi * api = [[GetGameGiftApi alloc] init];
    api.gameId = self.gameId;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success)
        {
            self.dataArray = request.data;
            
            NSMutableArray * array1 = [NSMutableArray array];
            NSMutableArray * array2 = [NSMutableArray array];
            NSMutableArray * array3 = [NSMutableArray array];
            for (int i=0;i<self.dataArray.count;i++)
            {
                NSDictionary * dic = self.dataArray[i];
               if ([dic[@"gift_type"] intValue] == 1)
               {
                   [array1 addObject:dic];
               }
               else if ([dic[@"gift_type"] intValue] == 2){
                   [array2 addObject:dic];
               }
               else if ([dic[@"gift_type"] intValue] == 4){
                   [array3 addObject:dic];
               }
            }
            
            for (int i = 0; i < 3; i ++)
            {
                MyGameGiftListView * listView = [self.view viewWithTag:i + 20];
                if (i == 0)
                {
                    listView.dataArray = [[NSMutableArray alloc] initWithArray:array1];
                }
                else if (i == 1)
                {
                    listView.dataArray = [[NSMutableArray alloc] initWithArray:array2];;
                }
                else if (i == 2)
                {
                    listView.dataArray = [[NSMutableArray alloc] initWithArray:array3];;
                }
            }
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
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
        
        WEAKSELF
        NSMutableArray * data = [NSMutableArray array];
        for (int i = 0; i < 3; i ++)
        {
            MyGameGiftListView * listView = [[MyGameGiftListView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, _scrollView.height)];
            listView.tag = i + 20;
            listView.receivedSuccessblock = ^{
                [weakSelf getData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refrefshGiftNotification" object:nil];
            };
            if (i == 0)
            {
                for (int i=0;i<self.dataArray.count;i++) {
                    NSDictionary * dic = self.dataArray[i];
                   if ([dic[@"gift_type"] intValue] == 1)
                   {
                       [data addObject:dic];
                   }
                }
                listView.dataArray = [[NSMutableArray alloc] initWithArray:data];
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
    
    MyGameGiftListView * listView = [self.view viewWithTag:button.tag + 10];
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0;i<self.dataArray.count;i++) {
        NSDictionary * dic = self.dataArray[i];
       if ([dic[@"gift_type"] intValue] == 1 && button.tag == 10)
       {
           [array addObject:dic];
       }
       else if ([dic[@"gift_type"] intValue] == 2 && button.tag == 11){
           [array addObject:dic];
       }
       else if ([dic[@"gift_type"] intValue] == 4 && button.tag == 12){
           [array addObject:dic];
       }
    }
    listView.dataArray = [[NSMutableArray alloc] initWithArray:array];
    
    [UIView animateWithDuration:0.26 animations:^{
        self.lineView.ly_centerX = button.ly_centerX;
    }];
}

@end
