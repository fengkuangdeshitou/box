//
//  MyInviteFriendsController.m
//  Game789
//
//  Created by Maiyou on 2021/4/30.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyInviteFriendsController.h"
#import "MyInviteRecordsController.h"
#import "InviteAPI.h"

@interface MyInviteFriendsController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (nonatomic, strong) NSDictionary * shareInfo;

@end

@implementation MyInviteFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"邀请好友";
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    self.navBar.titleLabelColor = UIColor.whiteColor;
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = YES;
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"邀请明细" titleColor:UIColor.whiteColor];
    [self.navBar setOnClickRightButton:^{
        [weakSelf.navigationController pushViewController:[MyInviteRecordsController new] animated:YES];
    }];
    
    self.scrollView.delegate = self;
    if (@available(iOS 11.0, *))
    {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    InviteAPI * api = [[InviteAPI alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1)
        {
            self.shareInfo = request.data;
            self.countLabel.text = [NSString stringWithFormat:@"%@",request.data[@"count"]];
            self.sumLabel.text = [NSString stringWithFormat:@"%@",request.data[@"sum"]];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0)
    {
        self.navBar.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:scrollView.contentOffset.y / 44.f];
    }
    else
    {
        self.navBar.backgroundColor = UIColor.clearColor;
    }
}

- (IBAction)inviteBtnClick:(id)sender
{
    UIImage *image = [UIImage imageNamed:[YYToolModel getShareIconName]];
    NSString * shareHost = [self.shareInfo objectForKey:@"inviteShareHost"];
    NSString * invite = [[shareHost stringByAppendingString:@"?invite="] stringByAppendingString:[YYToolModel getUserdefultforKey:@"user_name"]];
    NSString * url = [[invite stringByAppendingString:@"&agent="] stringByAppendingString:[DeviceInfo shareInstance].channel];
    NSDictionary * params = @{@"title":self.shareInfo[@"title"],
                              @"img":image,
                              @"desc":self.shareInfo[@"content"],
                              @"url":url};
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
         [self shareWebPageToPlatformType:platformType Params:params];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType Params:(NSDictionary *)params
{
    NSString * title = params[@"title"];
    UIImage * img = params[@"img"];
    NSString * desc = params[@"desc"];
    NSString * url = params[@"url"];
    NSData *data = UIImageJPEGRepresentation(img, 0.8);
    
    if (self.gameInfo)
    {
        title = self.gameInfo[@"game_name"];
        desc  = self.gameInfo[@"game_introduce"];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.gameInfo[@"game_image"][@"thumb"]]];
        url = [NSString stringWithFormat:@"http://%@.wakaifu.com/index.php?s=/game/details/game_id/%@", [DeviceInfo shareInstance].channel, self.gameInfo[@"game_id"]];
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:[UIImage imageWithData:data]];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********", error);
            [MBProgressHUD showToast:@"分享失败" toView:self.view];
        }
        else
        {
            [YJProgressHUD showSuccess:@"分享成功" inview:self.view];
            //统计分享成功事件
            [MobClick event:@"InviteFriends"];
            //分享成功加载任务
            if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine)
            {
                [self loadTaskApi:@"wxshare"];
            }
            else
            {
                [self loadTaskApi:@"qqkongjian"];
            }
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark - 根据type做任务
- (void)loadTaskApi:(NSString *)str
{
    if (![YYToolModel islogin]) return;
    
    TaskCenterApi * api = [[TaskCenterApi alloc] init];
    api.paramsDic = @{@"name":str, @"ui":@""};
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}


@end
