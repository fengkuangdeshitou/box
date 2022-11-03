//
//  HGGameGiftListController.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGGameGiftListController.h"
#import "MyGiftViewController.h"
#import "MyGameGiftDetailController.h"

#import "HGShowGameGiftCell.h"
#import "HGGameReceiveGiftView.h"

#import "GetGiftApi.h"

@interface HGGameGiftListController () <UITableViewDelegate, UITableViewDataSource, YNPageScrollMenuViewDelegate>

@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * giftData;
@property (nonatomic, strong) UIView * sectionView;
@property (nonatomic, strong) HGGameReceiveGiftView * giftView;

@property (nonatomic, assign) NSInteger menuSelectedIndex;
@property (nonatomic, assign) NSInteger giftSelectedIndex;

@property (nonatomic, assign) BOOL isCellBtnReceive;

@end

@implementation HGGameGiftListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.giftData = [NSMutableArray array];
    NSMutableArray * type1Array = [NSMutableArray array];
    NSMutableArray * type2Array = [NSMutableArray array];
    NSMutableArray * type3Array = [NSMutableArray array];
    NSArray * giftArray = [_dataDic[@"game_info"][@"gift_bag_list"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [@([obj1[@"gift_type"] integerValue]) compare:@([obj2[@"gift_type"] integerValue])];
    }];
    for (NSDictionary * dic in giftArray) {
       if ([dic[@"gift_type"] intValue] == 1){
           [type1Array addObject:dic];
           if (![self.titleArray containsObject:@"免费礼包"])
           {
               [self.titleArray addObject:@"免费礼包"];
           }
       }
       else if ([dic[@"gift_type"] intValue] == 2){
           [type2Array addObject:dic];
           if (![self.titleArray containsObject:@"充值礼包"])
           {
               [self.titleArray addObject:@"充值礼包"];
           }
       }
       else if ([dic[@"gift_type"] intValue] == 3){
           [type3Array addObject:dic];
           if (![self.titleArray containsObject:@"限时礼包"])
           {
               [self.titleArray addObject:@"限时礼包"];
           }
       }
    }
    [self.giftData addObject:type1Array];
    [self.giftData addObject:type2Array];
    [self.giftData addObject:type3Array];
    
    if (self.giftData.count > 0)
    {
        self.dataArray = [NSMutableArray arrayWithArray:self.giftData[0]];
    }
    [self.tableView reloadData];
    
    if (self.dataArray.count == 0)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabbarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        UIView * view = [self creatFooterView];
        view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _tableView.tableFooterView = self.titleArray.count > 0 ? view : [UIView new];
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"HGShowGameGiftCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGShowGameGiftCell"];
    }
    return _tableView;
}

- (NSNumber *)xy_noDataViewCenterYOffset
{
    return [NSNumber numberWithFloat:-self.view.height / 4];
}

#pragma mark - 懒加载
- (UIView *)sectionView
{
    if (!_sectionView)
    {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 69)];
        _sectionView.backgroundColor =  [UIColor colorWithHexString:@"#F6F6F6"];
        
        if (self.titleArray.count > 0)
        {
            YNPageConfigration *style_config_1 = [YNPageConfigration defaultConfig];
            style_config_1.itemFont = [UIFont systemFontOfSize:14];
            style_config_1.selectedItemFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
            style_config_1.selectedItemColor = [UIColor colorWithHexString:@"#282828"];
            style_config_1.normalItemColor = [UIColor colorWithHexString:@"#666666"];
            style_config_1.lineHeight = 3;
            style_config_1.lineColor = MAIN_COLOR;
            style_config_1.lineCorner = 1;
            style_config_1.lineBottomMargin = 5;
            style_config_1.scrollMenu = YES;
            style_config_1.lineLeftAndRightMargin = 25;
            style_config_1.aligmentModeCenter = NO;
            
            YNPageScrollMenuView *menuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(15, 15, 200, 44) titles:self.titleArray.mutableCopy configration:style_config_1 delegate:self currentIndex:0];
            menuView.backgroundColor = UIColor.clearColor;
            [_sectionView addSubview:menuView];
            
            UIButton * myGift = [UIControl creatButtonWithFrame:CGRectMake(kScreenW - 15 - 90, 0, 90, menuView.height) backgroundColor:[UIColor clearColor] title:@"我的礼包" titleFont:[UIFont systemFontOfSize:12] actionBlock:^(UIControl *control) {
                if ([YYToolModel isAlreadyLogin])
                {
                    [self.navigationController pushViewController:[MyGiftViewController new] animated:YES];
                }
            }];
            [myGift setTitleColor:FontColor99 forState:0];
            [myGift setImage:MYGetImage(@"home_more_icon") forState:0];
            [myGift layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
            [menuView addSubview:myGift];
        }
        
    }
    return _sectionView;
}

- (UIView *)creatSectionFooterView
{
    UIView * sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
    sectionFooterView.backgroundColor =  [UIColor colorWithHexString:@"#F6F6F6"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 20)];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.text = @"以游戏内实际礼包为准，平台展示仅供参考";
    label.textAlignment = NSTextAlignmentCenter;
    [sectionFooterView addSubview:label];
    
    return sectionFooterView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.titleArray.count > 0 ? self.sectionView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.titleArray.count > 0 ? 65 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.dataArray.count > 0 ? 45 : 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.dataArray.count > 0 ? [self creatSectionFooterView] : [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"HGShowGameGiftCell";
    HGShowGameGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.dataDic = self.dataArray[indexPath.row];
    cell.receiveGiftAction = ^(NSString * _Nonnull giftId) {
        self.isCellBtnReceive = YES;
        self.giftSelectedIndex = indexPath.row;
        [self receiveGift:giftId];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.row);
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    
    MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
    detail.isReceived = YES;
    detail.gift_id = dic[@"packid"];
    detail.vc = YYToolModel.getCurrentVC;
    [self presentViewController:detail animated:YES completion:nil];
}

- (void)receiveSuccessAlert:(NSIndexPath *)indexPath
{
    HGGameReceiveGiftView * giftView = [[HGGameReceiveGiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    giftView.dataDic = self.dataArray[indexPath.row];
    giftView.receiveGiftAction = ^{
        self.giftSelectedIndex = indexPath.row;
        [self receiveGift:self.dataArray[indexPath.row][@"id"]];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:giftView];
    self.giftView = giftView;
}

#pragma mark — YNPageScrollMenuViewDelegate
- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index
{
    self.menuSelectedIndex = index;
    self.dataArray = self.giftData[index];
    [self.tableView reloadData];
}

- (void)receiveGift:(NSString *)giftId
{
    if (![YYToolModel islogin])
    {
        LoginViewController *VC = [[LoginViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    GetGiftApi *api = [[GetGiftApi alloc] init];
    api.gift_id = giftId;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGiftSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleGiftSuccess:(GetGiftApi *)api
{
    if (api.success == 1)
    {
        NSString * code = [NSString stringWithFormat:@"礼包码为：%@", api.data[@"data"]];
        [self jxt_showAlertWithTitle:@"领取成功" message:code appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionDefaultTitle(@"取消".localized).
            addActionDestructiveTitle(@"复制".localized);
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = api.data[@"data"];
                [MBProgressHUD showToast:@"已复制到粘贴板"];
            }
        }];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
