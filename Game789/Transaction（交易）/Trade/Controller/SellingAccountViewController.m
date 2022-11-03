//
//  SellingAccountViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "SellingAccountViewController.h"
#import "PromptDetailsView.h"
#import "SellAmountViewCell.h"
#import "SmallAccountApi.h"
#import "SellGameListApi.h"
#import "HXPhotoView.h"
#import "SellAccountUploadApi.h"
#import "SwpNetworking.h"
#import "SellScreenImageCell.h"
#import "MySellAccountApi.h"
#import "MySendVerifyCodeView.h"

static const CGFloat kPhotoViewMargin = 12.0;

@interface SellingAccountViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, HXCustomCameraViewControllerDelegate, HXAlbumListViewControllerDelegate, HXPhotoViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSMutableArray * valueArray;

//选择列表的数据
@property (nonatomic, strong) NSMutableArray * smallAccountArray;
@property (nonatomic, strong) NSMutableArray * gameList;

//获取列表的数据
@property (nonatomic, strong) NSMutableArray * smallAccountData;
@property (nonatomic, strong) NSMutableArray * gameListData;

@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) NSMutableArray * imagesArray;

@property (nonatomic, copy) NSString * game_id;
@property (nonatomic, copy) NSString * small_account_id;

@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) UICollectionView * collectionView;

//编辑信息所用
@property (nonatomic, strong) NSMutableArray * urlsArray;
@property (nonatomic, strong) NSMutableArray * editImageArray;
@property (nonatomic, strong) NSMutableArray * indexArray;

//上传当前图片的下标
@property (nonatomic, assign) NSInteger uploadImageIndex;
@property (nonatomic, strong) NSMutableArray * uploadImagesArray;

@property (nonatomic, assign) BOOL isVerify;

@end

@implementation SellingAccountViewController

- (NSMutableArray *)valueArray
{
    if (!_valueArray)
    {
        _valueArray = [NSMutableArray arrayWithArray:@[@"选择".localized, @"选择".localized, @"", @"", @"", @"", @"", @""]];
    }
    return _valueArray;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[
                        @[@{@"title":@"选择游戏",},
                          @{@"title":@"选择小号",},
                          @{@"title":@"游戏区服",},
                          @{@"title":@"出售价",},
                          @{@"title":@"出售可得", @"detail":@"(手续费5%, 最低5元)"}],
                        @[@{@"title":@"标题"},
                          @{@"title":@"商品描述", @"detail":@"(选填)"},
                          @{@"title":@"二级密码", @"detail":@"(有则必填)"}]
                      ];
    }
    return _titleArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"我要卖号";
    self.navBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.uploadImageIndex = 0;
    
    [self creatBottomView];
    
    [self getGameList];
    //点击重新出售
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self againBuy];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.manager.configuration.clarityScale = 6.5;
}

- (void)againBuy
{
    if (self.detailDic)
    {
        self.valueArray = [NSMutableArray array];
        self.game_id = self.detailDic[@"game_info"][@"game_id"];
        self.small_account_id = self.detailDic[@"xh_username"];
        [self.valueArray addObject:self.detailDic[@"game_info"][@"game_name"]];
        [self.valueArray addObject:self.detailDic[@"xh_alias"]];
        [self.valueArray addObject:self.detailDic[@"server_name"]];
        [self.valueArray addObject:self.detailDic[@"sell_price"]];
        [self.valueArray addObject:[self getPlatCurrency:self.detailDic[@"sell_price"]]];
        [self.valueArray addObject:self.detailDic[@"title"]];
        [self.valueArray addObject:self.detailDic[@"content"]];
        [self.valueArray addObject:self.detailDic[@"second_level_pwd"]];
        [self.tableView reloadData];
        
        NSMutableArray * imageArray = [NSMutableArray array];
        self.urlsArray = [NSMutableArray array];
        self.editImageArray = [NSMutableArray array];
        for (NSDictionary * dic in self.detailDic[@"game_screenshots"])
        {
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"source"]]]];
//            [imageArray addObject:image];
            HXPhotoModel * model = [HXPhotoModel photoModelWithImage:image];
            [imageArray addObject:model];
            
            [self.editImageArray addObject:@{@"image":image, @"url":dic[@"source"]}];
        }
        [self.manager addLocalModels:imageArray];
        self.scrollView.hidden = NO;
        for (int i = 0; i < 3; i ++)
        {
            UIView * view = [self.footerView viewWithTag:i + 50];
            view.hidden = YES;
        }
        [self.photoView refreshView];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PromptDetailsView * detailView = [[PromptDetailsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            detailView.type = @"2";
            detailView.agree = ^(BOOL isAgree) {
                
            };
            [detailView showAnimationWithSpace:20];
        });
    }
}

#pragma mark - 获取游戏列表
- (void)getGameList
{
    SellGameListApi * api = [[SellGameListApi alloc] init];
    api.count = 1000;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (![request.data[@"game_list"] isKindOfClass:[NSNull class]])
            {
                self.gameListData = [NSMutableArray arrayWithArray:request.data[@"game_list"]];
                self.gameList = [NSMutableArray array];
                for (NSDictionary * dic in request.data[@"game_list"])
                {
                    [self.gameList addObject:dic[@"game_name"]];
                }
            }
            else
            {
                [MBProgressHUD showToast:@"暂无游戏列表"];
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

#pragma mark - 获取小号列表
- (void)getSmallAccount
{
    if (!self.game_id)
    {
        [MBProgressHUD showToast:@"请先选择游戏"];
        return;
    }
    
    SmallAccountApi * api = [[SmallAccountApi alloc] init];
    api.count = 50;
    api.game_id = self.game_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.smallAccountData = [NSMutableArray arrayWithArray:request.data[@"xh_list"]];
            self.smallAccountArray = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"xh_list"])
            {
                [self.smallAccountArray addObject:dic[@"xh_alias"]];
            }
            
            if (self.smallAccountData.count > 0)
            {
                [self showSmallAccount];
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView new]initWithFrame:CGRectMake(0, 0, kScreenH, 0)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenH, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        return 100;
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        return 90;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"SellAmountViewCell";
    SellAmountViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SellAmountViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * dic = self.titleArray[indexPath.section][indexPath.row];
    cell.showTitle.text = [dic[@"title"] localized];
    cell.enterText.tag = indexPath.section * 10 + indexPath.row;
    cell.enterText.delegate  = self;
    cell.showTitle.textColor = [UIColor blackColor];
    cell.showTitle1.textColor = [UIColor blackColor];
    if (indexPath.section == 0)
    {
        NSString * value = self.valueArray[indexPath.row];
        cell.textView.hidden = YES;
        cell.textView.editable = NO;
        if (indexPath.row < 2)
        {
            cell.enterText.enabled = NO;
            cell.enterText.hidden = YES;
            cell.showValue.text = value;
            if ([cell.showValue.text isEqualToString:@"选择"]) {
                cell.showValue.textColor = [UIColor colorWithHexString:@"#DEDEDE"];
            }else {
                cell.showValue.textColor = [UIColor blackColor];
            }
        }
        else if (indexPath.row == 2 || indexPath.row == 3)
        {
            cell.showValue.hidden = YES;
            cell.moreImage.hidden = YES;
            cell.enterText.placeholder = [NSString stringWithFormat:@"%@%@", @"请输入".localized, dic[@"title"]];
            cell.enterText.text = value;
            if (indexPath.row == 3)
            {
                cell.enterText.keyboardType = UIKeyboardTypeNumberPad;
                [cell.enterText addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventEditingChanged];
                cell.enterText.placeholder = @"不低于6元".localized;
            }
        }
        else
        {
            cell.showValue.hidden = YES;
            cell.moreImage.hidden = YES;
            cell.showDetail.text =  dic[@"detail"];
            cell.enterText.enabled = NO;
            cell.enterText.text = value;
            cell.lineView.hidden = YES;
        }
    }
    else
    {
        NSString * value = self.valueArray[indexPath.row + 5];
        cell.showValue.hidden = YES;
        cell.moreImage.hidden = YES;
        if (indexPath.row == 0)
        {
            cell.enterText.placeholder = [NSString stringWithFormat:@"%@%@(最多15个字)", @"请输入".localized, dic[@"title"]];
            cell.enterText.delegate = self;
            cell.enterText.text = value;
            cell.textView.hidden = YES;
            cell.textView.editable = NO;
        }
        else if (indexPath.row == 1)
        {
            cell.showTitle.hidden = YES;
            cell.enterText.hidden = YES;
            cell.enterText.enabled = NO;
            
            cell.showTitle1.text = dic[@"title"];
            cell.showDetail1.text = dic[@"detail"];
            cell.textView.zw_placeHolder = @"可描述角色等级、装备、属性，完善的描述可快速有效促成交易。".localized;
            cell.textView.text = value;
            cell.textView.tag = 70;
            cell.textView.delegate = self;
            cell.textView.backgroundColor = [UIColor whiteColor];
            cell.textView.textColor = [UIColor blackColor];
        }
        else
        {
            cell.showTitle.hidden = YES;
            cell.enterText.hidden = YES;
            cell.enterText.enabled = NO;
            
            cell.showTitle1.text = dic[@"title"];
            cell.showDetail1.text = dic[@"detail"];
            cell.textView.zw_placeHolder = @"例如：仓库密码。此密码仅审核人员及最终买家可见；".localized;
            cell.textView.text = value;
            cell.textView.delegate = self;
            cell.textView.tag = 71;
            cell.textView.keyboardType = UIKeyboardTypeASCIICapable;
            cell.textView.backgroundColor = [UIColor whiteColor];
            cell.textView.textColor = [UIColor blackColor];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        [self selectGame];
    }
    else if (indexPath.row == 1 && indexPath.section == 0)
    {
        [self selectSmallAccount];
    }
}

#pragma mark - 选择游戏列表
- (void)selectGame
{
    if (self.gameList.count == 0)
    {
        [MBProgressHUD showToast:@"暂无游戏列表"];
        return;
    }
    [BRStringPickerView showStringPickerWithTitle:@"请选择游戏".localized dataSource:self.gameList defaultSelValue:self.gameList[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index)
    {
        if (selectValue)
        {
            SellAmountViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.showValue.text = selectValue;
            [self.valueArray replaceObjectAtIndex:0 withObject:selectValue];
            
            NSDictionary * dic = self.gameListData[index];
            if (![self.game_id isEqualToString:dic[@"game_id"]])
            {
                [self.valueArray replaceObjectAtIndex:1 withObject:@"选择".localized];
                [self.tableView reloadData];
                self.game_id = dic[@"game_id"];
                self.small_account_id = @"";
            }
        }
    }];
}

#pragma mark - 选择小号列表
- (void)selectSmallAccount
{
    [self getSmallAccount];
}

//显示小号列表
- (void)showSmallAccount
{
    [BRStringPickerView showStringPickerWithTitle:@"请选择小号".localized dataSource:self.smallAccountArray defaultSelValue:self.smallAccountArray[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index)
     {
         SellAmountViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
         cell.showValue.text = selectValue;
         [self.valueArray replaceObjectAtIndex:1 withObject:selectValue];
        cell.showValue.textColor = [UIColor blackColor] ;
         NSDictionary * dic = self.smallAccountData[index];
         self.small_account_id = dic[@"xh_username"];
     }];
}

- (void)valueChangedAction:(UITextField *)textField
{
    SellAmountViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.enterText.text = [self getPlatCurrency:textField.text];
}

/**  计算平台币  */
- (NSString *)getPlatCurrency:(NSString *)enterText
{
    if (enterText.length > 0)
    {
        if (enterText.floatValue < 5)
        {
            return @"0.00平台币".localized;
        }
        else
        {
            CGFloat money = enterText.floatValue * 0.05;
            if (money < 5)
            {
                money = 5;
            }
            return [NSString stringWithFormat:@"%.2f%@", (enterText.floatValue - money) * 10, @"平台币".localized];
        }
    }
    else
    {
        return @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        [self.valueArray replaceObjectAtIndex:2 withObject:textField.text];
    }
    else if (textField.tag == 3)
    {
        [self.valueArray replaceObjectAtIndex:3 withObject:textField.text];
        
        SellAmountViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        [self.valueArray replaceObjectAtIndex:4 withObject:cell.enterText.text];
    }
    else if (textField.tag == 10)
    {
        [self.valueArray replaceObjectAtIndex:5 withObject:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 10){
        if ([string isEqualToString:@"\n"]){
            return YES;
        }
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([toBeString length] > 15) {
            textField.text = [toBeString substringToIndex:15];
            [MBProgressHUD showToast:@"标题最多15个字" toView:self.view];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 70)
    {
        [self.valueArray replaceObjectAtIndex:6 withObject:textView.text];
    }
    else
    {
        [self.valueArray replaceObjectAtIndex:7 withObject:textView.text];
    }
}

#pragma mark - footerView 添加图片
- (UIView *)creatFooterView
{
    CGSize size = [self sizeWithText];
    CGSize size1 = [self sizeWithText1];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120 + size.height + 200)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.footerView = footerView;

    UIButton * addImage = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 70, 70)];
    [addImage addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [addImage setImage:MYGetImage(@"trading_add_image") forState:0];
    addImage.tag = 50;
    [footerView addSubview:addImage];

    CGFloat label_x = CGRectGetMaxX(addImage.frame) + 10;
    CGFloat label_width = kScreenW - label_x - 20;
    UILabel * uploadName = [[UILabel alloc] initWithFrame:CGRectMake(label_x, addImage.y, label_width, 35)];
    uploadName.text = @"上传图片".localized;
    uploadName.font = [UIFont systemFontOfSize:14];
    uploadName.tag = 51;
    [footerView addSubview:uploadName];

    UILabel * uploadDes = [[UILabel alloc] initWithFrame:CGRectMake(label_x, CGRectGetMaxY(uploadName.frame), label_width, 35)];
    uploadDes.text = @"请上传3-5张游戏截图".localized;
    uploadDes.textColor = [UIColor colorWithHexString:@"#99A6A0"];
    uploadDes.font = [UIFont systemFontOfSize:14];
    uploadDes.tag = 52;
    [footerView addSubview:uploadDes];
    
    NSString * text1 = @"备注: 由于游戏排行榜会因为时间关系导致最终排行误差，为避免造成买卖双方纠纷，上传排行描述及相关截图的一律不通过审核!".localized;
    UILabel * tipsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, footerView.height - size1.height, size1.width, size1.height)];
    tipsLabel1.font = [UIFont systemFontOfSize:12];
    tipsLabel1.text = text1;
    tipsLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    tipsLabel1.numberOfLines = 0;
    [footerView addSubview:tipsLabel1];
    
    NSMutableAttributedString * attr1 = [[NSMutableAttributedString alloc] initWithString:text1];
    [attr1 addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 3)];
    tipsLabel1.attributedText = attr1;
    
    [tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(15);
        make.right.equalTo(footerView.mas_right).offset(-15);
        make.bottom.equalTo(footerView.mas_bottom).offset(-kPhotoViewMargin);
        make.height.equalTo(@(size1.height + 5));
    }];
    
    NSString * text = @"温馨提示: 亲爱的玩家，为了快速审核交易信息，请上传以下截图：人物属性界面、VIP充值等级或特权界面、背包仓库或宠物属性界面。".localized;
    UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, footerView.height - size.height, size.width, size.height)];
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.text = text;
    tipsLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    tipsLabel.numberOfLines = 0;
    [footerView addSubview:tipsLabel];
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 5)];
    tipsLabel.attributedText = attr;
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(15);
        make.right.equalTo(footerView.mas_right).offset(-15);
        make.bottom.equalTo(tipsLabel1.mas_top).offset(-kPhotoViewMargin);
        make.height.equalTo(@(size.height + 5));
    }];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:footerView.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 0);
    [footerView addSubview:scrollView];
    scrollView.hidden = YES;
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left);
        make.top.equalTo(footerView.mas_top);
        make.right.equalTo(footerView.mas_right);
        make.bottom.equalTo(tipsLabel.mas_bottom);
    }];
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0) manager:self.manager];
    photoView.delegate = self;
    photoView.lineCount = 4;
    photoView.spacing = 8;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    return footerView;
}

- (CGSize)sizeWithText
{
    NSString * text = @"温馨提示: 亲爱的玩家，为了快速审核交易信息，请上传以下截图：人物属性界面、VIP充值等级或特权界面、背包仓库或宠物属性界面。".localized;
    CGSize size = [YYToolModel sizeWithText:text size:CGSizeMake(kScreenW - 2 * 15, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
    return size;
}

- (CGSize)sizeWithText1
{
    NSString * text = @"备注: 由于游戏排行榜会因为时间关系导致最终排行误差，为避免造成买卖双方纠纷，上传排行描述及相关截图的一律不通过审核!".localized;
    CGSize size = [YYToolModel sizeWithText:text size:CGSizeMake(kScreenW - 2 * 15, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
    return size;
}

- (void)addImageAction:(UIButton *)sender
{
    [self.photoView goPhotoViewController];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal
{
    NSSLog(@"allList--------%@",allList);
    
    if (allList.count > 0)
    {
        self.scrollView.hidden = NO;
        for (int i = 0; i < 3; i ++)
        {
            UIView * view = [self.footerView viewWithTag:i + 50];
            view.hidden = YES;
        }
    }
    else
    {
        self.scrollView.hidden = YES;
        for (int i = 0; i < 3; i ++)
        {
            UIView * view = [self.footerView viewWithTag:i + 50];
            view.hidden = NO;
        }
    }
    
    //只有编辑状态下才会判断
    if (self.detailDic)
    {//判断是否上传url
        self.indexArray = [NSMutableArray array];
        NSMutableArray * tplArray = [NSMutableArray array];
        for (int i = 0; i < allList.count; i ++)
        {
            HXPhotoModel * model = allList[i];
            for (int j = 0; j < self.editImageArray.count; j ++)
            {
                NSDictionary * dic = self.editImageArray[j];
                if (dic[@"image"] == model.thumbPhoto)
                {
                    [tplArray addObject:dic];
                }
            }
        }
        self.editImageArray = tplArray;
    }
    
    self.imagesArray = [NSMutableArray arrayWithArray:allList];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    self.footerView.height = CGRectGetMaxY(frame) + kPhotoViewMargin * 4 + [self sizeWithText].height + [self sizeWithText1].height;
    self.tableView.tableFooterView = self.footerView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.maxNum = 5;
        _manager.configuration.rowCount = 4;
        _manager.configuration.clarityScale = 4;
        _manager.configuration.themeColor = [UIColor blackColor];
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        _manager.configuration.photoListCancelLocation = HXPhotoListCancelButtonLocationTypeLeft;
    }
    return _manager;
}

- (void)dealloc
{
    [self.manager clearSelectedList];
}

#pragma mark - 底部出售按钮
- (void)creatBottomView
{
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 64, kScreenW, 64)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton * sureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, kScreenW - 40, 44)];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureButton setTitle:@"确认出售".localized forState:0];
    [sureButton setTitleColor:[UIColor whiteColor] forState:0];
    sureButton.backgroundColor = MAIN_COLOR;
//    [sureButton gradientButtonWithSize:sureButton.frame.size colorArray:@[(id)MYColor(255, 138, 28), (id)MYColor(255, 205, 90)] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 22;
    sureButton.layer.masksToBounds = YES;
    [bottomView addSubview:sureButton];
    
    if ([DeviceInfo shareInstance].is_close_trade == 1)
    {
        sureButton.enabled = NO;
        sureButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [sureButton setTitle:@"春节期间(1月24日-1月30日)暂停新交易上架".localized forState:0];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)sureButtonAction:(UIButton *)sender
{
    NSMutableDictionary * parmaDic = [NSMutableDictionary  dictionary];
    for (int i = 0; i < self.valueArray.count; i ++)
    {
        NSString  * string = self.valueArray[i];
        switch (i) {
            case 0:
                if ([string isEqualToString:@"选择".localized] || !string)
                {
                    [MBProgressHUD showToast:@"请选择游戏" toView:self.view];
                    return;
                }
                else
                {
                    [parmaDic setValue:self.game_id forKey:@"game_id"];
                }
                break;
            case 1:
                if ([YYToolModel isBlankString:self.small_account_id])
                {
                    [MBProgressHUD showToast:@"请选择小号" toView:self.view];
                    return;
                }
                else
                {
                    [parmaDic setValue:self.small_account_id forKey:@"xh_username"];
                }
                break;
            case 2:
                if ([string isEqualToString:@""])
                {
                    [MBProgressHUD showToast:@"请输入区服" toView:self.view];
                    return;
                }
                else
                {
                    [parmaDic setValue:string forKey:@"server_name"];
                }
                break;
            case 3:
                if ([string isEqualToString:@""])
                {
                    [MBProgressHUD showToast:@"请输入出售价" toView:self.view];
                    return;
                }
                else
                {
                    if (string.integerValue < 6)
                    {
                        [MBProgressHUD showToast:@"出售价不低于6元" toView:self.view];
                        return;
                    }
                    [parmaDic setValue:string forKey:@"sell_price"];
                }
                break;
            case 5:
                if ([string isEqualToString:@""])
                {
                    [MBProgressHUD showToast:@"请输入标题" toView:self.view];
                    return;
                }
                else
                {
                    [parmaDic setValue:string forKey:@"title"];
                }
                break;
            case 6:
                    [parmaDic setValue:string forKey:@"content"];
                break;
            case 7:
                    [parmaDic setValue:string forKey:@"second_level_pwd"];
                break;
            default:
                break;
        }
    }

    NSMutableArray * imageArray = [NSMutableArray arrayWithArray:self.imagesArray];
    if (self.detailDic)//编辑
    {
        if ([self.detailDic[@"title"] isKindOfClass:parmaDic[@"title"]] || [self.detailDic[@"content"] isKindOfClass:parmaDic[@"content"]])
        {
            [MBProgressHUD showToast:@"请勿重复提交!"];
            return;
        }
        
        if (self.editImageArray.count > 0)
        {
            NSMutableArray * urlArray = [NSMutableArray array];
            
            for (int i = 0; i < self.editImageArray.count; i ++)
            {
                NSDictionary * dic = self.editImageArray[i];
                [urlArray addObject:dic[@"url"]];
                
                for (int j = 0; j < self.imagesArray.count; j ++)
                {
                    HXPhotoModel * model = self.imagesArray[j];
                    if (dic[@"image"] == model.thumbPhoto)
                    {
                        [imageArray removeObject:model];
                    }
                }
            }
        }
    }

    if ((imageArray.count + self.editImageArray.count) < 3)
    {
        [MBProgressHUD showToast:@"请至少选择3张图片".localized toView:self.view];
        return;
    }
    else if ((imageArray.count + self.editImageArray.count) > 5)
    {
        [MBProgressHUD showToast:@"请最多选择5张图片".localized toView:self.view];
        return;
    }
    else
    {
        self.imagesArray = imageArray;
    }
    
    //没有短信验证先验证
    !self.isVerify ? [self showVerifyCodeView:parmaDic] : [self requestData:parmaDic];
}

- (void)requestData:(NSMutableDictionary *)parmaDic
{
//    NSMutableArray * dataArray = [NSMutableArray array];
//    for (HXPhotoModel * model in self.imagesArray)
//    {
//        NSData * data = UIImagePNGRepresentation(model.thumbPhoto);
//        MYLog(@"==========%lu", (unsigned long)data.length);
//        [dataArray addObject:data];
//    }
    
    parmaDic[@"member_id"] = [YYToolModel getUserdefultforKey:USERID];
    [self jxt_showAlertWithTitle:@"确定要出售此游戏小号吗？" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确认出售".localized);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1)
        {
            self.uploadImagesArray = [NSMutableArray array];
            if (self.imagesArray.count > 0)
            {
                MBProgressHUD * hud = [MBProgressHUD showProgress:[NSString stringWithFormat:@"正在上传第%ld张图片", (long)self.uploadImageIndex + 1] toView:self.view];
                [self uploadImagesData:parmaDic Hud:hud];
            }
            else
            {
                [self uploadData:parmaDic];
            }
        }
    }];
}

- (void)uploadImagesData:(NSMutableDictionary *)parmaDic Hud:(MBProgressHUD *)hud
{
    hud.progress = (float)self.uploadImageIndex / (float)self.imagesArray.count;
    if (self.uploadImageIndex < self.imagesArray.count)
    {
        NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"user/trade/uploadImagePublicOss"];
        HXPhotoModel * model = self.imagesArray[self.uploadImageIndex];
        NSData * data = UIImagePNGRepresentation(model.thumbPhoto);
        [SwpNetworking swpPOSTAddFile:urlstr parameters:@{@"type":@"trade"} fileName:@"imageData" fileData:data swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
            if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
            {
                self.uploadImageIndex ++;
                [self.uploadImagesArray addObject:resultObject[@"data"][@"imageUrl"]];
                
                if (self.uploadImageIndex < self.imagesArray.count)
                {
                    hud.label.text = [NSString stringWithFormat:@"正在上传第%ld张图片", (long)self.uploadImageIndex + 1];
                    [self uploadImagesData:parmaDic Hud:hud];
                }
                else
                {
                    [hud hideAnimated:YES];

                    hud.progress = (float)self.uploadImageIndex / (float)self.imagesArray.count;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.uploadImageIndex = 0;
                        [self uploadData:parmaDic];
                    });
                }
            }
            else
            {
                self.uploadImageIndex = 0;
                [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"] toView:self.view];
            }
        } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
            self.uploadImageIndex = 0;
            [MBProgressHUD showToast:errorMessage toView:self.view];
        } ShowHud:NO];

    }
}

- (void)uploadData:(NSMutableDictionary *)parmaDic
{
    //将编辑的图片全部上传
    [self.editImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dic = obj;
        [self.uploadImagesArray addObject:dic[@"url"]];
    }];
    parmaDic[@"game_uploadedshots"] = self.uploadImagesArray;
    [SwpNetworking swpPOST:@"user/trade/submitTradeDetail" parameters:parmaDic swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
        if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
        {
            [YJProgressHUD showSuccess:@"提交成功" inview:YYToolModel.getCurrentVC.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.finish(YES);
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        else
        {
            self.uploadImageIndex = 0;
            [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"] toView:self.view];
        }
    } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
        self.uploadImageIndex = 0;
    } ShowHud:YES];
}

#pragma mark — 显示验证码
- (void)showVerifyCodeView:(NSMutableDictionary *)parmaDic
{
    MySendVerifyCodeView * codeView = [[MySendVerifyCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    codeView.codeType = @"06";
    codeView.CodeVerifySuccessBlock = ^{
        self.isVerify = YES;
        [self requestData:parmaDic];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:codeView];
}

@end
