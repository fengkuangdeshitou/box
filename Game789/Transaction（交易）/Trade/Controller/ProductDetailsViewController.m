//
//  ProductDetailsViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ProductDetailApi.h"
#import "SellingAccountViewController.h"
#import "UserPayGoldViewController.h"
#import "PromptDetailsView.h"
#import "MyMoreTransactionView.h"
#import "MyCollectionTradeApi.h"
#import "AuthAlertView.h"
#import "AdultAlertView.h"

@class MyCancleCollectionTradeApi;

@interface ProductDetailsViewController ()<AuthAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *purchase;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *container_height;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *product_icon;
@property (weak, nonatomic) IBOutlet UILabel *product_name;
@property (weak, nonatomic) IBOutlet UILabel *product_des;
//基本信息
@property (weak, nonatomic) IBOutlet UILabel *showTimeType;
@property (weak, nonatomic) IBOutlet UILabel *trading_time;
@property (weak, nonatomic) IBOutlet UILabel *small_name;
@property (weak, nonatomic) IBOutlet UILabel *detail_info;
@property (weak, nonatomic) IBOutlet UILabel *show_device;
@property (weak, nonatomic) IBOutlet UILabel *showPrice;
@property (weak, nonatomic) IBOutlet UIImageView *trade_status_image;
/**  账号创建时间  */
@property (weak, nonatomic) IBOutlet UILabel *creat_time;
@property (weak, nonatomic) IBOutlet UILabel *seller_des_title;
/**  卖家描述  */
@property (weak, nonatomic) IBOutlet UILabel *seller_des;
@property (weak, nonatomic) IBOutlet UILabel *screenShotView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seller_des_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seller_title_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rejectContent_height;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_y;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleHeight;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *failedDes;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

//二级密码
@property (weak, nonatomic) IBOutlet UILabel *showPwd;
@property (weak, nonatomic) IBOutlet UILabel *showPwdTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showPwdTitle_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showPwdTitle_y;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * thumbArray;
@property (nonatomic, strong) NSMutableArray * lunchScreenArray;
@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, assign) NSInteger  creatIndex;
@property (nonatomic, strong) UIButton * collectionButton;

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"商品详情";
    self.navBar.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.hidden = YES;
    self.scrollView_y.constant = kStatusBarAndNavigationBarHeight;
    self.container_height.constant = 1000;
    
    [self creatRightButton];
    //获取数据
    [self getData];
}

#pragma mark - 添加分享按钮
- (void)creatRightButton
{
    CGFloat iconWidth = 26;
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW - 75, self.navBar.height - iconWidth - (44 - iconWidth) / 2, 60, iconWidth)];
    [self.navBar addSubview:rightView];
    
    NSArray * array = @[@"game_collection_normal", @"detail_share_icon"];
    for (int i = 0; i < array.count; i ++)
    {
        MyLikeButton * shareButton = [[MyLikeButton alloc] init];
        shareButton.frame = CGRectMake((iconWidth + 10) * i, 0, iconWidth, iconWidth);
        shareButton.tag = i + 10;
        [shareButton setImage:[UIImage imageNamed:array[i]] forState:0];
        [shareButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:shareButton];
        
        if (i == 0)
        {
            [shareButton setImage:[UIImage imageNamed:@"game_collection_selected"] forState:UIControlStateSelected];
            shareButton.animateStyle = YYViewAnimateEffectStyleZoom;
            self.collectionButton = shareButton;
        }
    }
}

#pragma mark - 获取数据
- (void)getData
{
    ProductDetailApi * api = [[ProductDetailApi alloc] init];
    api.trade_id = self.trade_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleListSuccess:request];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleListSuccess:(BaseRequest *)request
{
    if ([request.data isKindOfClass:[NSNull class]])
    {
        [MBProgressHUD showToast:@"数据解析失败！" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    self.scrollView.hidden = NO;
    NSDictionary * dic = request.data;
    self.dataDic = dic;
    //统计商品详情页的游戏名称和价格
    [MyAOPManager relateStatistic:@"BrowseTheTradingProductDetailsPage" Info:@{@"gameName":dic[@"game_info"][@"game_name"], @"price":dic[@"sell_price"]}];
    self.collectionButton.selected = [dic[@"is_collected"] boolValue];
    [self.product_icon yy_setImageWithURL:[NSURL URLWithString:dic[@"game_info"][@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    self.product_name.text = dic[@"game_info"][@"game_name"];
    
    NSString * nameRemark = dic[@"game_info"][@"nameRemark"];
    BOOL isNameRemark = [YYToolModel isBlankString:nameRemark];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", nameRemark];
    self.nameRemark.hidden = isNameRemark;
    
    NSArray * array = dic[@"game_info"][@"game_classify_name"];
    NSString * string = @"";
    for (NSDictionary * dic in array)
    {
        [string isEqualToString:@""] ? string = dic[@"tagname"] : (string = [NSString stringWithFormat:@"%@ %@", string, dic[@"tagname"]]);
    }
    self.product_des.text = string;
    
    
    //有描述显示描述，没有显示福利标签
    for (UILabel * label in self.stackView.subviews) {
        label.text = @"";
    }
    if (dic[@"game_info"][@"introduction"]) {
        self.desc.text = dic[@"game_info"][@"introduction"];
        self.desc.hidden = NO;
        self.stackView.hidden = YES;
    }else{
        self.desc.hidden = YES;
        self.stackView.hidden = NO;
        NSArray * array = [dic[@"game_info"][@"game_desc"] componentsSeparatedByString:@"+"];
        for (int i = 0; i<array.count; i++) {
            UILabel * label = [self.stackView viewWithTag:i+20];
            label.text = [NSString stringWithFormat:@"%@",array[i]];
        }
    }

    //基本信息
    if ([dic[@"game_device_type"] integerValue] == 0)
    {
        self.show_device.text = @"(适用于双端)".localized;
    }
    else if ([dic[@"game_device_type"] integerValue] == 1)
    {
        self.show_device.text = @"(适用于安卓端)".localized;
    }
    else if ([dic[@"game_device_type"] integerValue] == 2)
    {
        self.show_device.text = @"(适用于苹果端)".localized;
    }

    NSInteger check_status = [dic[@"check_status"] integerValue];
    if (check_status == 1)
    {
        self.showTimeType.text = @"成交时间:".localized;
        self.showTimeType.textColor = [UIColor colorWithHexString:@"#999999"];
        self.trading_time.text = [NSDate detailTimeStringWithTs:[dic[@"trade_time"] floatValue]];
        self.trading_time.textColor = [UIColor colorWithHexString:@"#FF802F"];
        
        self.bottomView.hidden = YES;
        self.bottomView_y.constant = 0;
    }
    else
    {
        self.showTimeType.text = @"上架时间:".localized;
        self.showTimeType.textColor = [UIColor colorWithHexString:@"#999999"];
        self.trading_time.text = [NSDate detailTimeStringWithTs:[dic[@"sell_time"] floatValue]];
        self.trading_time.textColor = [UIColor colorWithHexString:@"#0B1611"];
        
        //判断是否显示底部按钮
        NSDictionary * member_info = [YYToolModel getUserdefultforKey:@"member_info"];
        if ([member_info[@"member_name"] isEqualToString:dic[@"seller_username"]])
        {
            if (check_status == 2 || check_status == -1)
            {
                [self.purchase setTitle:@"重新出售".localized forState:0];
            }
            else
            {
                self.bottomView.hidden = YES;
                self.bottomView_y.constant = 0;
            }
        }
    }

    self.small_name.text = dic[@"xh_alias"];

    self.detail_info.text = dic[@"server_name"];
    
    self.showPrice.text = [NSString stringWithFormat:@"¥%@", dic[@"sell_price"]];
    
    NSString * now_time = [NSDate getNowTimeTimestamp];
    CGFloat longTime = [now_time floatValue] - [dic[@"xh_create_time"] floatValue];
    self.creat_time.text = [NSString stringWithFormat:@"%@%.0f%@, %@%@%@", @"此号已创建".localized, ceil(longTime / (24 * 60 * 60)), @"天".localized, @"实际累充".localized, dic[@"xh_recharge_money"], @"元".localized];
    
    //审核状态（0：待审核，-1：已失效，1：已完成，2：审核失败:3：出售中）
    if (check_status == 1)
    {
        self.trade_status_image.image = MYGetImage(@"product_status_success");
    }
    else if (check_status == 2)
    {
        self.trade_status_image.image = MYGetImage(@"product_status_back");
    }
    else if (check_status == 3)
    {
        self.trade_status_image.image = MYGetImage(@"product_status_review");
    }
    else if (check_status == 0)
    {
        self.trade_status_image.image = MYGetImage(@"product_status_pending_review");
    }
    else if (check_status == -1)
    {
        self.trade_status_image.image = MYGetImage(@"product_status_Invalid");
    }
    
    //二级密码
    if ([dic[@"second_level_pwd"] isKindOfClass:[NSNull class]] || [dic[@"second_level_pwd"] isEqualToString:@""])
    {
        self.showPwdTitle_height.constant = 0;
        self.showPwdTitle_y.constant = 0;
    }
    else
    {
        //判断是否为自己账号
        NSDictionary * member_info = [YYToolModel getUserdefultforKey:@"member_info"];
        if ([member_info[@"member_name"] isEqualToString:dic[@"seller_username"]])
        {
            self.showPwd.text = dic[@"second_level_pwd"];
        }
        else
        {
//            self.showPwdTitle_height.constant = 0;
//            self.showPwdTitle_y.constant = 0;
            
            if (check_status == 1)
            {
                self.showPwd.text = dic[@"second_level_pwd"];
            }
            else
            {
                self.showPwd.text = @"******";
            }
        }
    }
    
    //审核失败隐藏中间失败原因
    if (check_status == 2)
    {
        NSString * reject_content = dic[@"reject_content"];
        CGSize size = [YYToolModel sizeWithText:reject_content size:CGSizeMake(kScreenW - 50, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
        if (size.height > 20)
        {
            self.rejectContent_height.constant = size.height + 5;
            self.middleHeight.constant = size.height + 20 + 65;
        }
        self.failedDes.text = dic[@"reject_content"];
    }
    else
    {
        self.middleView.hidden = YES;
        self.middleHeight.constant = 0;
        self.rejectContent_height.constant = 0;
        self.seller_title_y.constant -= 20;
    }
    
    self.seller_des_title.text = dic[@"title"];
    
    //买家描述
    int type = [dic[@"type"] intValue];
    if (type == 1) {
        NSString * content = dic[@"content"];
        if (![content isKindOfClass:[NSNull class]] && ![content isEqualToString:@""])
        {
            self.seller_des.text = content;
        }
    }else{
        NSString * content = dic[@"content_html"];
        if (![content isKindOfClass:[NSNull class]] && ![content isEqualToString:@""])
        {
            NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            self.seller_des.attributedText = att;
        }
    }
    
    [self.view layoutIfNeeded];
    //显示截图
    self.imageArray = [NSMutableArray array];
    self.thumbArray = [NSMutableArray array];
    NSArray * screenShots = dic[@"game_screenshots"];
    CGFloat middleView_y = CGRectGetMaxY(self.screenShotView.frame);
    //有可能描述很长
//    CGSize size = [YYToolModel sizeWithText:content size:CGSizeMake(kScreenW - 40, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
//    if (size.height > 20)
//    {
//        middleView_y += size.height - 20;
//    }
    //当审核不为审核未通过,减去原有的高度
//    if (check_status != 2)
//        middleView_y -= 90;
    
    [self.view layoutIfNeeded];
    
    if (screenShots.count > 0)
    {
        for (int i = 0; i < screenShots.count; i ++)
        {
            NSDictionary * dic1 = screenShots[i];
            [self.imageArray addObject:dic1[@"source"]];
            [self.thumbArray addObject:dic1[@"thumb"]];
        }
        
        self.creatIndex = 0;
        
//        (check_status != 2) ? (middleView_y -= 20) : (middleView_y += 20);
        [self screatscreenShotsButton:middleView_y + 20];
    }
    else
    {
        self.screenShotView.hidden = true;
        [self addMoreTransactionView:CGRectGetMaxY(self.screenShotView.frame) + 80];
        
//        CGFloat view_height = CGRectGetMaxY(self.screenShotView.frame) + 80;
//        self.container_height.constant = view_height;
    }
}

- (void)screatscreenShotsButton:(CGFloat)button_y
{
//    NSString * urlStr = self.thumbArray[self.creatIndex];
//
//    CGFloat image_width = kScreenW - 100;
//    CGFloat image_height = 200;
//    __block UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50, button_y + (image_height + 10) * self.creatIndex, image_width, image_height)];
//    [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
//    {
//        if (!image) return;
//
//        button.frame = CGRectMake(50, button_y, image_width, image.size.height * image_width / image.size.width);
//        button.tag = self.creatIndex;
//        self.creatIndex ++;
//        if (self.creatIndex == self.thumbArray.count)
//        {
//            [self addMoreTransactionView:CGRectGetMaxY(button.frame)];
//            return;
//        }
//        else
//        {
//            [self screatscreenShotsButton:CGRectGetMaxY(button.frame) + 20];
//        }
//    }];
//    [button addTarget:self action:@selector(clickViewImageAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.containerView addSubview:button];
    
    CGFloat view_top = 0;
    NSInteger rowCount = 3;
    CGFloat padding = 10;
    CGFloat image_height = 65;
    for (int i = 0; i < self.thumbArray.count; i ++)
    {
        NSString * url = self.thumbArray[i];
        CGFloat image_width = (kScreenW - padding * (rowCount + 1)) / rowCount;
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(padding + (image_width + padding) * (i % rowCount), button_y + (image_height + padding) * (i / rowCount), image_width, image_height)];
        [button addTarget:self action:@selector(clickViewImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:MYGetImage(@"game_icon") forState:0];
        [button sd_setImageWithURL:[NSURL URLWithString:url] forState:0];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.tag = i;
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [self.containerView addSubview:button];
        view_top = CGRectGetMaxY(button.frame) + 20;
    }
    
    [self addMoreTransactionView:view_top];
}

- (IBAction)downLoadAction:(id)sender
{
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = [NSString stringWithFormat:@"%@", self.dataDic[@"game_info"][@"game_id"]];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 查看截图
- (void)clickViewImageAction:(UIButton *)sender
{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.lunchScreenArray;
    browser.currentPage = sender.tag;
    [browser show];
}

- (NSMutableArray *)lunchScreenArray
{
    if (!_lunchScreenArray)
    {
        _lunchScreenArray = [NSMutableArray array];
        [self.imageArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 网络图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
//            data.projectiveView = [self viewAtIndex:idx];
            data.allowSaveToPhotoAlbum = NO;
            [_lunchScreenArray addObject:data];
        }];
    }
    return _lunchScreenArray;
}

#pragma mark - 分享
- (void)rightButtonAction:(UIButton *)sender
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if (sender.tag == 10)
    {
        [self collectionGameRequest:sender.selected];
    }
    else
    {
        //1、创建分享参数
        UIImage *image = [UIImage imageNamed:[YYToolModel getShareIconName]];
        NSString *string = [self.dataDic[@"trade_detail_url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSDictionary * dic = @{@"title":self.dataDic[@"title"],
                               @"img":image,
                               @"desc":self.dataDic[@"content"],
                               @"url":string};
        [self shareBtnClick:dic];
        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//        [shareParams SSDKSetupShareParamsByText:self.dataDic[@"content"]
//                                         images:imageArray
//                                            url:[NSURL URLWithString:string]
//                                          title:self.dataDic[@"title"]
//                                           type:SSDKContentTypeWebPage];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil customItems:@[@(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)] shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)  {
//
//           switch (state) {
//               case SSDKResponseStateSuccess:
//               {
//                   [MBProgressHUD showToast:@"分享成功"];
//                   break;
//               }
//               case SSDKResponseStateFail:
//               {
//                   [MBProgressHUD showToast:@"分享失败"];
//                   break;
//               }
//               default:
//                   break;
//           }
//       }];
    }
}

- (void)shareBtnClick:(NSDictionary *)params
{
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
    NSString * description = params[@"desc"];
    NSString * url = params[@"url"];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:img];
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
            [MBProgressHUD showToast:@"分享成功" toView:self.view];
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

#pragma mark — 收藏/取消收藏
- (void)collectionGameRequest:(BOOL)isCancle
{
    if (isCancle)
    {
        self.collectionButton.selected = NO;
        
        MyCancleCollectionTradeApi * api = [[MyCancleCollectionTradeApi alloc] init];
        api.tradeId = self.dataDic[@"trade_id"];
        api.isShow = YES;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
         {
             if (api.success == 1)
             {
                 [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
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
        self.collectionButton.selected = YES;
        
        MyCollectionTradeApi * api = [[MyCollectionTradeApi alloc] init];
        api.tradeId = self.dataDic[@"trade_id"];
        api.isShow = YES;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
         {
             if (api.success == 1)
             {
                 [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
             }
             else
             {
                 [MBProgressHUD showToast:api.error_desc toView:self.view];
             }
         } failureBlock:^(BaseRequest * _Nonnull request) {
             
         }];
    }
}

- (void)onAuthSuccess
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];
    [dic setValue:@1 forKey:@"isRealNameAuth"];
    [NSUserDefaults.standardUserDefaults setValue:dic forKey:@"member_info"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - 立即购买
- (IBAction)bottomButtonAction:(id)sender
{
    if (![YYToolModel islogin])
    {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        [self removeFromParentViewController];
        return;
    }
    
    NSDictionary * member_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    BOOL isRealNameAuth = [member_info[@"isRealNameAuth"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAuth && !isRealNameAuth) {
        [AuthAlertView showAuthAlertViewWithDelegate:self];
        return;
    }
    
    BOOL isAdult = [member_info[@"isAdult"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAdult && !isAdult) {
        [AdultAlertView showAdultAlertView];
        return;
    }
    
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
    {
        [self.navigationController pushViewController:[BindMobileViewController new] animated:YES];
        return;
    }
    
    
    UIButton * button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"重新出售"])
    {
        SellingAccountViewController * account = [SellingAccountViewController new];
        account.detailDic = self.dataDic;
        account.finish = ^(BOOL isTrading) {
            [self getData];
        };
       [self.navigationController pushViewController:account animated:YES];
    }
    else
    {
        //判断游戏适用平台
        if ([self.dataDic[@"game_device_type"] integerValue] == 1)
        {
            [self jxt_showAlertWithTitle:@"" message:@"该帐号角色为安卓设备帐号，IOS设备可能无法登陆使用，您确定要购买吗？" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"继续购买".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1)
                {
                    [self gotoSellAccountView];
                }
            }];
        }
        else
        {
            [self gotoSellAccountView];
        }
    }
}

- (void)gotoSellAccountView
{
    WEAKSELF
    PromptDetailsView * detailView = [[PromptDetailsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    detailView.type = @"1";
    detailView.agree = ^(BOOL isAgree)
    {
        UserPayGoldViewController * pay = [UserPayGoldViewController new];
        pay.isRecharge = NO;
        pay.trade_id = self.dataDic[@"trade_id"];
        [weakSelf.navigationController pushViewController:pay animated:YES];
        
        [self removeFromParentViewController];
    };
    [detailView showAnimationWithSpace:20];
}

- (void)addMoreTransactionView:(CGFloat)topView_y
{
    NSArray * tradesArray = self.dataDic[@"related_trades"];
    if (tradesArray.count > 0)
    {
        NSInteger count = tradesArray.count;
        if (tradesArray.count > 3) {
            count = 3;
        }
        CGFloat viewHeight = count * 130 + 44;
        
        MyMoreTransactionView * moreView = [[MyMoreTransactionView alloc] initWithFrame:CGRectMake(0, topView_y, kScreenW, viewHeight)];
        moreView.currentVC = self;
        moreView.dataDic = self.dataDic;
        [self.containerView addSubview:moreView];
        
        [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(topView_y));
            make.left.equalTo(self.containerView.mas_left);
            make.right.equalTo(self.containerView.mas_right);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];
        
        self.container_height.constant = CGRectGetMaxY(moreView.frame) + 10;
    }
    else
    {
        self.container_height.constant = topView_y + 10;
    }
    [self.containerView layoutIfNeeded];
}

@end
