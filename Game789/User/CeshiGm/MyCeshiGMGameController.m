//
//  MyCeshiGMGameController.m
//  Game789
//
//  Created by Maiyou on 2019/6/11.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyCeshiGMGameController.h"
#import "MyLoadGMGameController.h"
#import "SmallAccountApi.h"

@interface MyCeshiGMGameController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textField_top;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray * xhListArray;

@end

@implementation MyCeshiGMGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"测试GM游戏";
    self.textField_top.constant = kStatusBarAndNavigationBarHeight + 20;
}

- (IBAction)sureClick:(id)sender
{
    [self getSmallAccount];
}

#pragma mark - 获取小号列表
- (void)getSmallAccount
{
    if (self.textField.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入maiyou_gameid" toView:self.view];
        return;
    }
    SmallAccountApi * api = [[SmallAccountApi alloc] init];
    api.count = 50;
    api.pageNumber = 1;
    api.maiyou_gameid = self.textField.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            self.xhListArray = [NSMutableArray arrayWithArray:request.data[@"xh_list"]];
            for (NSDictionary * dic in request.data[@"xh_list"])
            {
                [array addObject:dic[@"xh_alias"]];
            }
            
            if (array.count > 0)
            {
                [self showSmallAccount:array];
            }
            else
            {
                [MBProgressHUD showToast:@"暂无小号列表" toView:self.view];
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

//显示小号列表
- (void)showSmallAccount:(NSArray *)array
{
    [BRStringPickerView showStringPickerWithTitle:@"请选择小号" dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index)
     {
         NSDictionary * dic = self.xhListArray[index];
         NSString * xh_username   = dic[@"xh_username"];
         
         MyLoadGMGameController * load = [MyLoadGMGameController new];
         load.xh_username = xh_username;
         load.maiyou_gameid = self.textField.text;
         [self.navigationController pushViewController:load animated:YES];
     }];
}

@end
