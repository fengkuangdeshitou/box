//
//  SecureViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "SecureViewController.h"
#import "SecureListTableViewCell.h"

#import "BindMobileViewController.h"
#import "ModifyNameViewController.h"
#import "ModifyPwdViewController.h"
#import "BindVerifyViewController.h"
#import "CancellationAccountViewController.h"
#import "AuthAlertView.h"

#import "GetUserInfoApi.h"

@interface SecureViewController () <UITableViewDelegate, UITableViewDataSource, AuthAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSDictionary *data;
@property (nonatomic, strong) UIImageView * headerImage;
@property (nonatomic, strong) UILabel * statusLabel;

@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation SecureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

    [self.view insertSubview:self.navBar aboveSubview:self.view];

    self.navBar.title = @"个人中心".localized;
    [self setCellData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCellData) name:@"kSetMemberInfoSuccess" object:nil];
    
    [self getUserInfo];
}

- (void)getUserInfo
{
    GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
    
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleUserSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleUserSuccess:(GetUserInfoApi *)api
{
    if (api.success == 1)
    {
        NSDictionary * dic = api.data[@"member_info"] ;
        if ([dic[@"avatar_status"] length] > 0 && [dic[@"avatar_status"] intValue] == 0)
        {
            self.statusLabel.text = @"(审核中)".localized;
        }
        else
        {
            self.statusLabel.text = @"";
        }
    }
}

- (void)setCellData
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    NSString *moblie = dic[@"mobile"];
    //姓名密文显示
    NSString *nameLength = dic[@"real_name"];
    NSString *real_name;
    if ([YYToolModel isBlankString:nameLength]==NO) {
        int startName = (int)nameLength.length;
        NSString *realName = [nameLength stringByReplacingCharactersInRange:NSMakeRange(1, startName-1) withString:[self padRight:startName-1]];
        real_name = realName;
    }else{
        real_name = dic[@"real_name"];
    }
    
    //身份证号密文显示
    
    NSString *cardLength = dic[@"identity_card"];
    NSString * identity_card;
    if (![YYToolModel isBlankString:cardLength] && [self validateIdentityCard:cardLength])
    {
        int startCard = (int)cardLength.length;
        NSString *identityCard = [cardLength stringByReplacingCharactersInRange:NSMakeRange(4, startCard-8) withString:[self padRight:4]];
         identity_card = identityCard;
    }
    else
    {
         identity_card = dic[@"identity_card"];
    }
    
    
    NSString *nick_name = dic[@"nick_name"];
    if (!moblie || moblie.length == 0) {
        moblie = @"未绑定".localized;
    }
    
    if ((!identity_card || identity_card.length == 0) || (!real_name || real_name.length == 0))
    {
        identity_card = @"未实名".localized;
    }
    else
    {
        identity_card = [NSString stringWithFormat:@"%@,%@", real_name, identity_card];
    }
    
    if (!nick_name || nick_name.length == 0) {
        nick_name = @"未设置".localized;
    }
    NSString *qq = dic[@"qq"];
    if (!qq || qq.length == 0) {
        qq = @"未设置".localized;
    }
    NSArray * datas = @[
    @[@{@"title":@"个人头像",@"text":dic[@"icon_link"]}],
    @[@{@"title":@"账号",@"text":dic[@"member_name"]},
      @{@"title":@"昵称",@"text":nick_name},
      @{@"title":@"QQ",@"text":qq},
      @{@"title":@"手机绑定",@"text":moblie}],
    @[@{@"title":@"实名认证",@"text":identity_card},
      @{@"title":@"登录密码",@"text":@"修改密码"},
      @{@"title":@"账号管理",@"text":@"注销账号"}]];
    self.dataSource = [[NSMutableArray alloc] initWithArray:datas];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 8)];
    view.backgroundColor = FontColorF6;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.row, (long)indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dic = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = [dic[@"title"] localized];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 90, 5, 50, 50)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"text"]]];
        imageView.layer.cornerRadius = imageView.height / 2;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        self.headerImage = imageView;
        
        CGSize size = [YYToolModel sizeWithText:dic[@"title"] size:CGSizeMake(MAXFLOAT, 60) font:[UIFont systemFontOfSize:14]];
        UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + size.width , 0, 80, 60)];
        statusLabel.text = @"";
        statusLabel.textColor = [UIColor redColor];
        statusLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:statusLabel];
        self.statusLabel = statusLabel;
    }
    else
    {
        cell.detailTextLabel.text = [dic[@"text"] localized];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (self.statusLabel.text.length > 0)
        {
            [MBProgressHUD showToast:@"头像正在审核中..." toView:self.view];
        }
        else
        {
            [self selectImage];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self pasteUsername:self.dataSource[indexPath.section][indexPath.row][@"text"]];
        }
        else if (indexPath.row == 1)
        {
            [self pushModifyNickNameVC];
        }
        else if (indexPath.row == 2)
        {
            [self pushModifyQQVC];
        }
        else if (indexPath.row == 3)
        {
            [self pushBindMobileVC];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [self pushModifyIDVC];
        }
        else if (indexPath.row == 1)
        {
            [self pushModifyPwdVC];
        }
        else if (indexPath.row == 2)
        {
            CancellationAccountViewController * cancellation = [[CancellationAccountViewController alloc] init];
            [self.navigationController pushViewController:cancellation animated:YES];
        }
    }
}
#pragma mark - 选择上传图片
- (void)selectImage
{
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        NSSLog(@"%lu张图片",(unsigned long)photoList.count);
        if (photoList.count > 0)
        {
            [photoList[0] requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                
            } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                
            } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                [self uploadImage:image];
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                
            }];
        }
    } cancel:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        NSSLog(@"取消了");
    } ];
}

- (void)pasteUsername:(NSString *)username
{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = username;
    
    [MBProgressHUD showToast:@"账号已复制在粘贴板" toView:self
    .view];
}

- (void)uploadImage:(UIImage *)image
{
    NSData * data = UIImageJPEGRepresentation(image, 0.6);
    MYLog(@"==========%lu", (unsigned long)data.length);
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    NSDictionary * parmaDic = @{@"member_id":userID};
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"user/user/uploadAvatar"];
    [SwpNetworking swpPOSTAddFile:urlstr parameters:parmaDic fileName:@"file" fileData:data swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject)
    {
        if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
        {
            [YJProgressHUD showSuccess:@"上传成功,后台审核中..." inview:[UIApplication sharedApplication].keyWindow];
            self.headerImage.image = image;
            
            [self getUserInfo];
        }
        else
        {
            [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"]];
        }
    } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
        
    } ShowHud:YES];
}

- (void)pushBindMobileVC
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    NSString *moblie = dic[@"mobile"];

    if (!moblie || moblie.length == 0) {
        BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
        [self.navigationController pushViewController:bindVC animated:YES];
    }else{
        [self jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionDefaultTitle(@"解绑当前手机号").
            addActionDefaultTitle(@"更换当前手机号").
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            MYLog(@"==============%ld", (long)buttonIndex);
            if (buttonIndex == 0 || buttonIndex == 1)
            {
                BindVerifyViewController *verifyVC = [[BindVerifyViewController alloc]init];
                verifyVC.bandMobile = moblie;
                verifyVC.isRebind = (buttonIndex == 0 ? NO : YES);
                [self.navigationController pushViewController:verifyVC animated:YES];
            }
        }];
    }
}

- (void)pushModifyQQVC {
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"QQ".localized;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)pushModifyNickNameVC {
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"昵称".localized;
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)pushModifyNameVC {
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"真实姓名".localized;
    [self.navigationController pushViewController:bindVC animated:YES];
}
- (void)pushModifyIDVC
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    if ([dic[@"status"] integerValue] != 1)
    {
//        ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
//        bindVC.title = @"实名认证".localized;
//        [self.navigationController pushViewController:bindVC animated:YES];
        [AuthAlertView showAuthAlertViewWithDelegate:self];
    }
    else
    {
        [MBProgressHUD showToast:@"已实名" toView:self.view];
    }
}

- (void)pushModifyPwdVC {
    ModifyPwdViewController *bindVC = [[ModifyPwdViewController alloc] init];
    [self.navigationController pushViewController:bindVC animated:YES];
}

#pragma mark - 实名认证成功
- (void)onAuthSuccess
{
    [self setCellData];
}

- (HXPhotoManager *)manager {
    if (!_manager)
    {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.singleSelected = YES;
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
        };
        _manager.configuration.singleJumpEdit = YES;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.clarityScale = 4;
        _manager.configuration.requestImageAfterFinishingSelection = YES;
        _manager.configuration.photoListCancelLocation = HXPhotoListCancelButtonLocationTypeLeft;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    }
    return _manager;
}

- (void)dealloc
{
    [self.manager clearSelectedList];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.separatorColor = [UIColor colorWithHexString:@"#e9e8e8"];
        _tableView.backgroundColor = FontColorF6;
        _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);        // 设置端距，这里表示separator离左边和右边均80像素
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SecureListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"SecureListTableViewCell"];
    }
    return _tableView;
}

- (UIView *)creatFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, footerView.height - 44, kScreenW - 80, 44);
    [btn addTarget:self
            action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = MAIN_COLOR;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.height / 2;
    [footerView addSubview:btn];
    
    return footerView;
}

- (void)exitApp
{
    [self cancelLocalNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

// 取消本地推送通知
- (void)cancelLocalNotification {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;

    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

#pragma mark - 验证身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 拼接n个*到字符串

-(NSString *)padRight:(int)count {
    
    NSMutableString * str = [[NSMutableString alloc] init];
    
    for (int i=0; i<count;i++) {
        
        [str appendString:@"*"];
        
    }
    return str;
}
@end
