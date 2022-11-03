//
//  MyTrumpetRecyclingDetailController.m
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTrumpetRecyclingDetailController.h"

#import "MyTrumpetRecyclingDetailCell.h"
#import "MyRansomAlertView.h"
#import "MySendVerifyCodeView.h"

#import "MyRecycleGameListApi.h"
@class MyRecycleGameAllXhApi;
@class MyRecycleXhApi;

@interface MyTrumpetRecyclingDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *recycleNum;
@property (weak, nonatomic) IBOutlet UILabel *recycleAmount;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *recycleArray;
@property (nonatomic, assign) BOOL isVerify;

@end

@implementation MyTrumpetRecyclingDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self loadData];
    
    [self getGameAllXhList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isVerify = NO;
}

- (void)prepareBasic
{
    self.navBar.title = @"选择小号";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.topView_top.constant = kStatusBarAndNavigationBarHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"咦～什么都没有…" detailStr:@""];
    self.tableView.ly_emptyView.contentView.hidden = YES;
    self.tableView.tableFooterView = [UIView new];
    
    self.recycleArray = [NSMutableArray array];
    
    if (self.listModel)
    {
        [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:self.listModel.img[@"thumb"]] placeholder:MYGetImage(@"game_icon")];
        
        self.gameName.text = self.listModel.name;
        
        self.recycleNum.text = [NSString stringWithFormat:@"%@", self.listModel.recyclable];
        
        self.recycleAmount.text = [NSString stringWithFormat:@"%@", self.listModel.recyclableCoin];
    }
}

- (void)getGameAllXhList
{
    MyRecycleGameAllXhApi * api = [[MyRecycleGameAllXhApi alloc] init];
    api.game_id = self.listModel.Id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleListSuccess:(BaseRequest *)request
{
    if (request.success == 1)
    {
        NSArray * array = request.data[@"list"];
        NSMutableArray * tplArray = [NSMutableArray array];
        for (NSDictionary * dic in array)
        {
            MyTrumpetRecyclingModel * model = [[MyTrumpetRecyclingModel alloc] initWithDictionary:dic];
            [tplArray addObject:model];
        }
        if (self.pageNumber == 1)
        {
            self.dataArray = [[NSMutableArray alloc] initWithArray:tplArray];
        }
        else
        {
            [self.dataArray addObjectsFromArray:tplArray];
        }
        NSDictionary *dic = request.data[@"paginated"];
        if (self.dataArray.count >= [dic[@"total"] integerValue])
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
        _tableView.ly_emptyView.contentView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showToast:request.error_desc];
    }
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell1";
    MyTrumpetRecyclingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyTrumpetRecyclingDetailCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.recycleModel = self.dataArray[indexPath.row];
    cell.SelectAction = ^(BOOL isSelected, NSInteger index) {
        MyTrumpetRecyclingModel * recycleModel = self.dataArray[index];
        if (isSelected)//添加
        {
            if (![self.recycleArray containsObject:recycleModel])
            {
                [self.recycleArray addObject:recycleModel];
            }
        }
        else
        {//去除
            if ([self.recycleArray containsObject:recycleModel])
            {
                [self.recycleArray removeObject:recycleModel];
            }
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击事件");
}

#pragma mark ——— 确认回收
- (IBAction)sureButtonAction:(id)sender
{
    if (self.recycleArray.count == 0)
    {
        [MBProgressHUD showToast:@"请选择要回收的小号" toView:self.view];
        return;
    }
    
    !self.isVerify ? [self showVerifyCodeView] : [self showNoticeView];
}

#pragma mark — 显示验证码
- (void)showVerifyCodeView
{
    MySendVerifyCodeView * codeView = [[MySendVerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    codeView.codeType = @"05";
    codeView.CodeVerifySuccessBlock = ^{
        self.isVerify = YES;
        [self showNoticeView];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:codeView];
}

#pragma mark — 显示温馨提示
- (void)showNoticeView
{
    NSString * ids = @"";
    CGFloat recycleAmount = 0;
    for (MyTrumpetRecyclingModel * recycleModel in self.recycleArray)
    {
        if ([ids isEqualToString:@""])
        {
            ids = recycleModel.Id;
        }
        else
        {
            ids = [NSString stringWithFormat:@"%@,%@", ids, recycleModel.Id];
        }
        recycleAmount += recycleModel.recycledCoin.floatValue;
    }
    
    MyRansomAlertView * alertView = [[MyRansomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    alertView.type = @"1";
    alertView.showDetail.text = [NSString stringWithFormat:@"%@%lu%@%@%@", @"您正在回收".localized, (unsigned long)self.recycleArray.count, @"个小号，回收金额".localized, [NSNumber numberWithFloat:recycleAmount], @"金币".localized];
    alertView.agree = ^(BOOL isAgree) {
        [self recycleXhRequest:ids];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

- (void)recycleXhRequest:(NSString *)ids
{
    MyRecycleXhApi * api = [[MyRecycleXhApi alloc] init];
    api.ids = ids;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self.recycleArray removeAllObjects];
            
            [YJProgressHUD showSuccess:@"回收成功" inview:self.view];
            
            if (self.RecycleXhSuccess)
            {
                self.RecycleXhSuccess();
            }
            
            //在主线程延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getGameAllXhList];
        [tableView.mj_header endRefreshing];
    }];
    
    // 上拉刷新
    tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getGameAllXhList];
        [tableView.mj_footer endRefreshing];
    }];
}

@end
