//
//  MyCustomerServiceController.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCustomerServiceController.h"
#import "MyServiceDetailController.h"

#import "MyCustomerServiceHeaderView.h"
#import "MyServiceCenterHeaderView.h"
#import "MyCustomerServiceFooterView.h"
#import "MyServiceCenterSectionView.h"
#import "MyCustomServiceApi.h"
#import "MyCustomServiceCell.h"
#import "MyServicesContactCell.h"

@interface MyCustomerServiceController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MyServiceCenterHeaderView *headerView;
@property (nonatomic, strong) MyCustomerServiceFooterView *footerView;
@property (nonatomic, strong) MyServiceCenterSectionView *sectionView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *contactArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *kefuDic;

@end

@implementation MyCustomerServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getData];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"客服中心";
    self.navBar.lineView.hidden = YES;
    self.selectedIndex = -1;
}

- (void)getData
{
    MyCustomServiceApi * api = [[MyCustomServiceApi alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.dataArray = request.data[@"faq"];
            self.footerView.telNumber = request.data[@"complaint_tel"];
            NSDictionary * kefu_info = [request.data[@"kefu_info"] deleteAllNullValue];
            if (![kefu_info[@"wechat_public_number_title"] isBlankString])
            {
                self.headerView.dataDic   = request.data[@"kefu_info"];
                self.tableView.tableHeaderView = self.headerView;
            }
            self.contactArray = [NSMutableArray array];
            self.kefuDic = kefu_info;
            if ([kefu_info[@"is_private_kefu"] boolValue])
            {
                NSDictionary * dic = @{@"title":kefu_info[@"kefu_weixin_title"], @"icon":@"service_wxgz_icon", @"value":kefu_info[@"kefu_weixin"], @"type":@"8", @"btn":@"去撩她"};
                [self.contactArray addObject:dic];
            }
            if (![kefu_info[@"qq"] isEqualToString:@""])
            {
                NSDictionary * dic = @{@"title":![YYToolModel isBlankString:kefu_info[@"qq_title"]] ? kefu_info[@"qq_title"] : @"QQ在线客服", @"icon":@"service_qq_icon", @"value":kefu_info[@"qq"], @"type":@"7", @"btn":@"去撩她"};
                [self.contactArray addObject:dic];
            }
            if (![kefu_info[@"tel"] isEqualToString:@""])
            {
                NSDictionary * dic = @{@"title":@"客服电话", @"icon":@"service_tel_icon", @"value":kefu_info[@"tel"], @"type":@"1", @"btn":@"拨打电话"};
                [self.contactArray addObject:dic];
            }
            if (![kefu_info[@"email"] isEqualToString:@""])
            {
                NSDictionary * dic = @{@"title":@"电子邮件", @"icon":@"service_emil_icon", @"value":kefu_info[@"email"], @"type":@"2", @"btn":@"复制邮箱"};
                [self.contactArray addObject:dic];
            }
            if (kefu_info[@"facebook_link"])
            {
                NSDictionary * dic = @{@"title":@"Facebook", @"icon":@"service_fb_icon", @"value":kefu_info[@"facebook_name"], @"type":@"3", @"btn":@"去关注"};
                [self.contactArray addObject:dic];
            }
            if (kefu_info[@"line_name"])
            {
                NSDictionary * dic = @{@"title":@"Line", @"icon":@"service_line_icon", @"value":kefu_info[@"line_name"], @"type":@"4", @"btn":@"复制账号"};
                [self.contactArray addObject:dic];
            }
            if (![kefu_info[@"qq_group"] isEqualToString:@""])
            {
                NSDictionary * dic = @{@"title":@"QQ群", @"icon":@"service_qq_group_icon", @"value":kefu_info[@"qq_group"], @"type":@"5", @"btn":@"去加入", @"key":kefu_info[@"qq_group_key"]};
                [self.contactArray addObject:dic];
            }
            if ([kefu_info[@"exists_general_weixin"] boolValue])
            {
                NSString * url = kefu_info[@"kefu_weixin_url"];
                NSDictionary * dic = @{@"title":![url isBlankString] ? kefu_info[@"kefu_weixin_title"] : @"微信", @"icon":@"service_wx_icon", @"value":kefu_info[@"kefu_weixin"], @"type":@"6", @"btn":![url isBlankString] ? @"去撩她" : @"复制账号"};
                [self.contactArray addObject:dic];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.backgroundColor = BackColor;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view insertSubview:_tableView belowSubview:self.navBar];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyCustomServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCustomServiceCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyServicesContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyServicesContactCell"];
    }
    return _tableView;
}

- (MyServiceCenterHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyServiceCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 244 + kStatusBarHeight)];
    }
    return _headerView;
}

- (MyCustomerServiceFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[MyCustomerServiceFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    }
    return _footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.contactArray.count;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 65;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 56 : 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionView = [[MyServiceCenterSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 66)];
    _sectionView.showTitle.text = section == 0 ? ([self.kefuDic[@"is_private_kefu"] boolValue] ? @"私人经理" : @"在线客服")  : @"常见问题";
    _sectionView.showTime.text = section == 0 ? [NSString stringWithFormat:@"在线时间：%@", self.kefuDic[@"online_time"]] : @"";
    return _sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * cellIdentify = @"MyServicesContactCell";
        MyServicesContactCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        cell.dataDic = self.contactArray[indexPath.row];
        cell.kefuDic = self.kefuDic;
        return cell;
    }
    else
    {
        static NSString * cellIdentify = @"MyCustomServiceCell";
        MyCustomServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        cell.isShowContent = self.selectedIndex == indexPath.row;
        cell.dataDic = self.dataArray[indexPath.row];
        cell.moreBtnBlock = ^{
            if (self.selectedIndex != indexPath.row)
            {
                self.selectedIndex = indexPath.row;
            }
            else
            {
                self.selectedIndex = -1;
            }
            [self.tableView reloadData];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (self.selectedIndex == indexPath.row)
        {
            MyServiceDetailController * detail = [MyServiceDetailController new];
            detail.dataDic = self.dataArray[indexPath.row];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else
        {
            self.selectedIndex = indexPath.row;
            [self.tableView reloadData];
        }
    }
    else
    {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y >= 20)
//    {
//        self.navBar.backgroundColor = MAIN_COLOR;
//    }
//    else
//    {
//        self.navBar.backgroundColor = [UIColor clearColor];
//    }
}

@end
