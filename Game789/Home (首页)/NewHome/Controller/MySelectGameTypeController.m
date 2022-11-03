//
//  MySelectGameTypeController.m
//  Game789
//
//  Created by Maiyou on 2020/11/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySelectGameTypeController.h"

#import "MyHomeGameListApi.h"
@class MyGetSelectLikeTypeApi;
@class MySaveLikeTypeApi;

@interface MySelectGameTypeController ()

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation MySelectGameTypeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    
    [self getLikeTypes];
}

- (void)getLikeTypes
{
    MyGetSelectLikeTypeApi * api = [[MyGetSelectLikeTypeApi alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSArray * array = request.data;
            for (int i = 0; i < array.count; i ++)
            {
                UIButton * btn = [self.view viewWithTag:i + 10];
                [btn setTitle:array[i][@"name"] forState:0];
            }
            self.dataArray = array;
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray)
    {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark ——— 点击选择游戏类型
- (IBAction)gameTypeClick:(id)sender
{
    UIButton * btn = sender;
    if (![self.selectedArray containsObject:btn])
    {
        if (self.selectedArray.count < 3)
        {
            btn.selected = YES;
            btn.backgroundColor = MAIN_COLOR;
            [self.selectedArray addObject:btn];
        }
        else
        {
            [MBProgressHUD showToast:@"最多可选三个选项" toView:self.view];
        }
    }
    else
    {
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
        if ([self.selectedArray containsObject:btn])
        {
            [self.selectedArray removeObject:btn];
        }
    }
}

#pragma mark ——— 跳过
- (IBAction)jumpBtnClick:(id)sender
{
    [YYToolModel saveUserdefultValue:@"1" forKey:@"MyLikeGameType"];
    [YYToolModel initTabbarRootVC];
}

#pragma mark ——— 确定
- (IBAction)sureBtnClick:(id)sender
{
    [self saveLikeTypes];
}

- (void)saveLikeTypes
{
    if (self.selectedArray.count == 0)
    {
        [MBProgressHUD showToast:@"请选择喜欢的游戏类型" toView:self.view];
        return;
    }
    NSString * str = @"";
    NSString * name = @"";
    for (int i = 0; i < self.selectedArray.count; i ++)
    {
        UIButton * btn = self.selectedArray[i];
        NSDictionary * dic = self.dataArray[btn.tag - 10];
        [str isEqualToString:@""] ? (str = [NSString stringWithFormat:@"%@", dic[@"id"]]) : (str = [NSString stringWithFormat:@"%@,%@", str, dic[@"id"]]);
        [name isEqualToString:@""] ? (name = [NSString stringWithFormat:@"%@", dic[@"name"]]) : (name = [NSString stringWithFormat:@"%@,%@", name, dic[@"name"]]);
    }
    MySaveLikeTypeApi * api = [[MySaveLikeTypeApi alloc] init];
    api.isShow = YES;
    api.tags = str;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [MyAOPManager relateStatistic:@"SelectTheTypeTag" Info:@{@"type":name}];
            [YJProgressHUD showSuccess:@"提交成功" inview:self.view];
            [YYToolModel saveUserdefultValue:@"1" forKey:@"MyLikeGameType"];
            [YYToolModel initTabbarRootVC];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

@end
