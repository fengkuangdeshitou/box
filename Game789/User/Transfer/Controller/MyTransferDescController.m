//
//  MyTransferDescController.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferDescController.h"
#import "MySubmitTransferDataController.h"

#import "MyTransferDescSectionView.h"

#import "MyTransferListApi.h"
@class MyTransferDescApi;

@interface MyTransferDescController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;
@property (nonatomic, strong) MyTransferDescSectionView *sectionView;
@property (nonatomic, strong) NSDictionary *detailData;

@end

@implementation MyTransferDescController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self getData];
}

- (void)prepareBasic
{
    self.navBar.title = @"转游福利".localized;
    self.topView_top.constant = kStatusBarAndNavigationBarHeight;
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"转游说明".localized titleColor:FontColor99];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navBar setOnClickRightButton:^{
        WebViewController * coin = [WebViewController new];
        coin.urlString = TransferInstructionsUrl;
        [weakSelf.navigationController pushViewController:coin animated:YES];
    }];
    
    NSString *url = [[self.dataDic objectForKey:@"game_image"] objectForKey:@"thumb"];
    [self.imageViews yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    
    NSString *class_type = self.dataDic[@"game_classify_type"];
    if ([class_type hasPrefix:@" "])
    {
        class_type = [class_type substringFromIndex:1];
    }
    self.titleLabel.text = self.dataDic[@"game_name"];
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:self.dataDic[@"introduction"]])
    {
        self.introduction.hidden = YES;
        self.firstTagLabel.hidden  = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        NSString *desc = self.dataDic[@"game_desc"];
        if (![YYToolModel isBlankString:desc])
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                NSString * str = [NSString stringWithFormat:@"%@", tagArray[i]];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (i == 0)
                {
                    self.firstTagLabel.hidden = NO;
                    self.firstTagLabel.text  = str;
                }
                else if (i == 1)
                {
                    self.secondTagLabel.hidden = NO;
                    self.secondTagLabel.text = str;
                }
                else if (i == 2)
                {
                    self.thirdTagLabel.hidden = NO;
                    self.thirdTagLabel.text = str;
                }
            }
        }
    }
    else
    {
        self.introduction.hidden = NO;
        _introduction.text = self.dataDic[@"introduction"];
        self.firstTagLabel.hidden = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:self.dataDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", self.dataDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameDetailClick)];
    [self.topView addGestureRecognizer:tap];
}

- (void)gameDetailClick
{
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.maiyou_gameid = self.dataDic[@"gameid"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)getData
{
    MyTransferDescApi * api = [[MyTransferDescApi alloc] init];
    api.isShow = YES;
    api.detail_id = self.dataDic[@"id"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.detailData = request.data;
            [self.view addSubview:self.tableView];
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
- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat view_top = kStatusBarAndNavigationBarHeight + 98;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - view_top - 89) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ColorWhite;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.sectionView = [[MyTransferDescSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    self.sectionView.showTitle.text = section == 1 ? @"备注".localized : @"转游规则".localized;
    return self.sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"cell1";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = FontColor66;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = indexPath.section == 1 ? self.detailData[@"comment"] : self.detailData[@"rule"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ——— 立即转游
- (IBAction)transferBtnClick:(id)sender
{
    [MyAOPManager gameRelateStatistic:@"ClickTransferGameRechargeImmediatelyButton" GameInfo:self.detailData Add:@{@"game_classify_name":self.detailData[@"game_classify_type"]}];
    
    MySubmitTransferDataController * submitData = [MySubmitTransferDataController new];
    submitData.dataDic = self.detailData;
    [self.navigationController pushViewController:submitData animated:YES];
}

@end
