//
//  MyRebateNoticeInfoController.m
//  Game789
//
//  Created by Maiyou on 2020/7/22.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRebateNoticeInfoController.h"
#import "ReturnGuideApi.h"
#import "ReturnGuideContentTableViewCell.h"
#import "ReturnGuideSectionView.h"
#import "MyReplyRebateListHeaderView.h"

@interface MyRebateNoticeInfoController () <UITableViewDelegate, UITableViewDataSource, ReturnGuideSectionViewDelegate>

@property (nonatomic, strong) NSArray * dataArray;
@property (strong, nonatomic) NSMutableArray *dataSourceExpand;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) MyReplyRebateListHeaderView * headerView;

@end

@implementation MyRebateNoticeInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"返利指南";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self listGuideRequest];
}

- (void)listGuideRequest {

    ReturnGuideApi *api = [[ReturnGuideApi alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleReturnGuideApiListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleReturnGuideApiListSuccess:(ReturnGuideApi *)api
{
    if (api.success == 1)
    {
        self.dataArray = [api.data objectForKey:@"guide_list"];
        self.dataSourceExpand = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            [self.dataSourceExpand addObject:@"0"];
        }
        [self.tableView reloadData];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnGuideContentTableViewCell class]) bundle:nil]
        forCellReuseIdentifier:@"ReturnGuideContentTableViewCell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (MyReplyRebateListHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MyReplyRebateListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
    }
    return _headerView;
}

#pragma mark TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ReturnGuideSectionView *view = [self createGuideHeaderView];
    view.row = section;
    view.delegate = self;
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    [view resetTitles:[dic objectForKey:@"guide_title"]];
    NSString *selecteStr = [self.dataSourceExpand objectAtIndex:section];
    view.fireImg.image = [selecteStr isEqualToString:@"0"] ?  MYGetImage(@"rebate_down_icon") : MYGetImage(@"rebate_up_icon");
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *selecteStr = [self.dataSourceExpand objectAtIndex:section];
    if ([selecteStr isEqualToString:@"0"])
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ReturnGuideContentTableViewCell";
    ReturnGuideContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    [cell setModelDic:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"==%ld",(long)indexPath.row);
}

#pragma mark ----delegate-
- (void)resetAllStatusExc:(NSInteger )index {
    for (int i=0; i<self.dataSourceExpand.count; i++) {
        if (i == index) {
            continue;
        }
        [self.dataSourceExpand replaceObjectAtIndex:i withObject:@"0"];
    }
}

- (void)ReturnGuideSectionViewPressAction:(NSInteger)index {
    [self resetAllStatusExc:index];
    if ([[self.dataSourceExpand objectAtIndex:index] isEqualToString:@"0"]) {
        [self.dataSourceExpand replaceObjectAtIndex:index withObject:@"1"];
    }
    else {
        [self.dataSourceExpand replaceObjectAtIndex:index withObject:@"0"];
    }
    [self.tableView reloadData];
}

- (ReturnGuideSectionView *)createGuideHeaderView {
    ReturnGuideSectionView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReturnGuideSectionView class]) owner:nil options:nil] firstObject];
    return view;
}
@end
