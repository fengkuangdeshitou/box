//
//  SettingDetailViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/17.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "SettingDetailViewController.h"
#import "MyFeedbackViewController.h"
#import "MyYouthModePwdController.h"

#import "SecureListTableViewCell.h"
#import "GetVersionApi.h"

#import "DeviceInfo.h"
#import "FileUtils.h"
#import "GameDownLoadApi.h"
#import "EditUserInfoApi.h"

#import "AppDelegate.h"

@interface SettingDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSDictionary *versionDic;

@end

@implementation SettingDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.view insertSubview:self.navBar aboveSubview:self.view];

    self.navBar.title = @"设置";
    [self setCellData];
}

- (void)setCellData
{
//    NSString * style = [YYToolModel getUserdefultforKey:DOWN_STYLE];
//    if (style == NULL)
//    {
//        [YYToolModel saveUserdefultValue:@"0" forKey:DOWN_STYLE];
//        style = @"0";
//    }
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[
      @{@"icon":@"清理缓存",@"title":@"清理缓存",@"text":[NSString stringWithFormat:@"%.2f M",[DeviceInfo shareInstance].folderSizes]},
      @{@"icon":@"feedback_icon",@"title":@"投诉反馈",@"text":@""},
      @{@"icon":@"setting_notice_icon",@"title":@"免责声明",@"text":@""},
      @{@"icon":@"user_agreement_icom",@"title":@"用户协议",@"text":@""},
      @{@"icon":@"privacy_policy_icon",@"title":@"隐私政策",@"text":@""},
      @{@"icon":@"检查更新",@"title":@"检查更新",@"text":[DeviceInfo shareInstance].appDisplayVersion},
      @{@"icon":@"预防闪退",@"title":@"预防闪退",@"text":@""},
      @{@"icon":@"youth_mode_icon",@"title":@"青少年模式",@"text":@""}]];
    
//@{@"icon":@"download_style_icon",@"title":@"下载方式",@"text":style.intValue == 0 ? @"先下载再安装" : @"在线安装"}
//    //如果是至尊版不显示下载方式
//    if ([DeviceInfo shareInstance].isGameVip)
//    {
//        [self.dataSource removeLastObject];
//    }
    [self.tableView reloadData];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - kTabbarSafeBottomMargin - 20, kScreenW, 20)];
    label.textColor = [UIColor colorWithHexString:@"#EDEDED"];
    label.text = [DeviceInfo shareInstance].channel;
    label.backgroundColor = UIColor.clearColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

- (void)getVersionApiRequest {

    GetVersionApi *api = [[GetVersionApi alloc] init];
    api.isShow = YES;
    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleNoticeSuccess:(GetVersionApi *)api {
    if (api.success == 1) {
        self.versionDic = api.data;
        NSInteger step = [self compareVersion:[DeviceInfo shareInstance].appVersion to:self.versionDic[@"version_code"]];

        if (step == -1) {
            //更新
            [self jxt_showAlertWithTitle:@"" message:[NSString stringWithFormat:@"%@%@",self.versionDic[@"update_content"],self.versionDic[@"version_name"]] appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"更新".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1) {
                    NSURL* nsUrl = [NSURL URLWithString:self.versionDic[@"down_url"]];
                    [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
                }
            }];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"已是最新版本";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
        }
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

- (void)getMessageApiRequest {

    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    //    WEAKSELF
    api.requestTimeOutInterval = 60;
    api.urls = self.versionDic[@"down_url"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle2NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handle2NoticeSuccess:(GameDownLoadApi *)api {
    if (api.success == 1) {
        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",api.data[@"url"]]];
        [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
    }
    else {
        [MBProgressHUD showToast:[api.error_desc isKindOfClass:[NSNull class]] ? @"下载失败".localized : api.error_desc];
    }
}

/**
 比较两个版本号的大小

 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }

    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }

    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }

    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;

    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }

        // 版本相等，继续循环。
    }

    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }

    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 58;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SecureListTableViewCell";
    SecureListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell setModelDic:dic];
    cell.moreIcon.hidden = NO;
    if (indexPath.row == 7)
    {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
        sw.on = [DeviceInfo shareInstance].isOpenYouthMode;
        [sw addTarget:self action:@selector(getSwitchStatus:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        cell.moreIcon.hidden = YES;
    }
    else
    {
        cell.accessoryView = [UIView new];
        cell.moreIcon.hidden = NO;
    }
    return cell;
}

- (void)getSwitchStatus:(UISwitch *)sw
{
    MYLog(@"=====%d", sw.isOn);
    NSString * pwd = [YYToolModel getUserdefultforKey:@"MyYouthModePwd"];
    MyYouthModePwdController * pwdVC = [MyYouthModePwdController new];
    if (pwd == NULL && sw.isOn)
    {
        sw.on = !sw.isOn;
        pwdVC.isVerify = NO;
    }
    else if (pwd && !sw.isOn)
    {
        sw.on = !sw.isOn;
        pwdVC.isVerify = YES;
    }
    else
    {
        [YYToolModel saveUserdefultValue:sw.isOn ? @"1" : @"0" forKey:@"MyYouthMode"];
        return;
    }
    pwdVC.sureBtnBlock = ^(BOOL isVerify) {
        sw.on = !sw.isOn;
        [YYToolModel saveUserdefultValue:sw.isOn ? @"1" : @"0" forKey:@"MyYouthMode"];
    };
    [self.navigationController pushViewController:pwdVC animated:YES];
}

- (BOOL)openMessageNotificationService
{
    BOOL isOpen = NO;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        isOpen = YES;
    }
    return isOpen;
}

- (void)getValue1:(id)sender
{
    UISwitch *swi2=(UISwitch *)sender;
    if (swi2.isOn) {
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }else{
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = self.dataSource[indexPath.row];
    if (indexPath.row == 0)
    {
        [self clearCache];
    }
    else if (indexPath.row == 1) {
        [self submitFeedback];
    }
    else if (indexPath.row == 2) {
        [self loadUrl:DisclaimerUrl title:dic[@"title"]];
    }
    else if (indexPath.row == 3)
    {
        [self loadUrl:LoginUserAgreementUrl title:dic[@"title"]];
    }
    else if (indexPath.row == 4)
    {
        [self loadUrl:LoginPrivacyPolicyUrl title:dic[@"title"]];
    }
    else if (indexPath.row == 5) {
        [self update];
    }
    else if (indexPath.row == 6) {
        NSString *path = [NSString stringWithFormat:@"%@base/common/preventionCash/agent/%@.mobileconfig", Base_Request_Url, [DeviceInfo shareInstance].channel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path] options:@{} completionHandler:nil];

//        [self getMobileconfigRequest];
//        [self provision];
    }
//    else if (indexPath.row == 5)
//    {
//        if (![DeviceInfo shareInstance].isGameVip)
//        {
//            [self selectDownLoadStyle];
//        }
//    }
}

- (void)loadUrl:(NSString *)url title:(NSString *)title
{
    WebViewController * webVC = [WebViewController new];
    webVC.webTitle = title;
    webVC.urlString = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 提交意见
- (void)submitFeedback
{
    if (![YYToolModel islogin])
    {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        return;
    }
    MyFeedbackViewController * feedback = [MyFeedbackViewController new];
    feedback.game_id = @"";
    [self.navigationController pushViewController:feedback animated:YES];
}

#pragma mark - 选择下载方式
- (void)selectDownLoadStyle
{
    NSArray * array = @[@"先下载再安装".localized, @"在线安装".localized];
    [BRStringPickerView showStringPickerWithTitle:@"请选择游戏下载方式".localized dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index) {
        
        if ([YYToolModel islogin])
        {
            EditUserInfoApi * api = [[EditUserInfoApi alloc] init];
            api.isShow = YES;
            api.ios_down_style = [NSString stringWithFormat:@"%ld", (long)index];
            [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                if (api.success == 1)
                {
                    [self setDownLoadStyle:index SelectValue:selectValue];
                }
                else
                {
                    [MBProgressHUD showToast:api.error_desc toView:self.view];
                }
            } failureBlock:^(BaseRequest * _Nonnull request) {
                
            }];
        }
        else
        {
            [YYToolModel saveUserdefultValue:@"1" forKey:@"NoLoginDownStyle"];
            [self setDownLoadStyle:index SelectValue:selectValue];
        }
    }];
}

- (void)setDownLoadStyle:(NSInteger)index SelectValue:(NSString *)selectValue
{
    [YYToolModel saveUserdefultValue:[NSString stringWithFormat:@"%ld", (long)index] forKey:DOWN_STYLE];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[5]];
    [dic setValue:selectValue forKey:@"text"];
    [self.dataSource replaceObjectAtIndex:5 withObject:dic];
    [self.tableView reloadData];
}

- (void)provision {
    //模板位置
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"maiyouProfile" ofType:@"mobileconfig"];
    //目标位置
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"profile.mobileconfig"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:templatePath toPath:path error:nil];

    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UInt16 port = appDelegate.httpServer.port;
    NSLog(@"%u", port);
    if (success) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%u/profile.mobileconfig", port]]];
    else NSLog(@"Error generating profile");
}

- (void)clearCache {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [MBProgressHUD showToast:@"清除成功!" toView:self.view];
            [self setCellData];
        }];
    });
}

- (void)update
{
    [self getVersionApiRequest];

}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight-59) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#e9e8e8"];
        _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);        // 设置端距，这里表示separator离左边和右边均80像素
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SecureListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"SecureListTableViewCell"];
    }
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

@end
