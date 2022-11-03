//
//  GameCommitViewController.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GameCommitViewController.h"
#import "GameSubmitCommitApi.h"
#import "HXPhotoView.h"

static const CGFloat kPhotoViewMargin = 20.0;

@interface GameCommitViewController () <HXPhotoViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *enterText;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadName;
@property (weak, nonatomic) IBOutlet UIView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *uploadDes;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageListView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backVIew_top;

@property (nonatomic, strong) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray * imagesArray;

@end


@implementation GameCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.title = @"发表评论";
    self.backVIew_top.constant = kStatusBarAndNavigationBarHeight + 10;
    self.enterText.zw_placeHolder = @"请围绕该游戏画面、玩法、操作、氪金等方面进行点评。优质的评论将随机获得5-50个金币奖励，不少于10个字哦!".localized;
    self.enterText.delegate = self;
    self.enterText.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"发表".localized titleColor:[UIColor colorWithHexString:@"#FAA520"]];
    self.navBar.onClickRightButton = ^{
        MYLog(@"发表");
        [weakSelf sureButtonAction];
    };
    
    [self creatImageList];
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 0;
        _manager.configuration.rowCount = 4;
        _manager.configuration.clarityScale = 4;
        _manager.configuration.downloadICloudAsset = NO;
        _manager.configuration.photoListCancelLocation = HXPhotoListCancelButtonLocationTypeLeft;
        _manager.configuration.themeColor = [UIColor blackColor];
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    }
    return _manager;
}

- (void)dealloc
{
    [self.manager clearSelectedList];
}

- (void)creatImageList
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.imageListView.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 0);
    [self.backView addSubview:scrollView];
    scrollView.hidden = YES;
    self.scrollView = scrollView;
    
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(kPhotoViewMargin, kPhotoViewMargin, width - kPhotoViewMargin * 2, 0) manager:self.manager];
    photoView.delegate = self;
    photoView.lineCount = 4;
    photoView.spacing = 8;
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    [photoView refreshView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageListView.mas_left);
        make.top.equalTo(self.imageListView.mas_top);
        make.right.equalTo(self.imageListView.mas_right);
        make.bottom.equalTo(self.imageListView.mas_bottom);
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 1000)
    {
        textView.text = [textView.text substringToIndex:1000];
    }
}

#pragma mark - 添加u图片
- (IBAction)addImageAction:(id)sender
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
            UIView * view = [self.backView viewWithTag:i + 50];
            view.hidden = YES;
        }
    }
    else
    {
        self.scrollView.hidden = YES;
        for (int i = 0; i < 3; i ++)
        {
            UIView * view = [self.backView viewWithTag:i + 50];
            view.hidden = NO;
        }
    }
    self.imagesArray = [NSMutableArray arrayWithArray:allList];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    self.imageListView_height.constant = CGRectGetMaxY(frame) + kPhotoViewMargin;
    
    if (self.imagesArray.count > 7)
    {
        self.backView_height.constant = 300 + 70 * 2;
    }
    else if (self.imagesArray.count > 3)
    {
        self.backView_height.constant = 300 + 70;
    }
    else
    {
        self.backView_height.constant = 300;
    }
}

- (void)sureButtonAction
{
    NSString * content = [self.enterText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (content.length < 10)
    {
        [MBProgressHUD showToast:@"评论字数不少于10个".localized];
        return;
    }
//    else if (self.imagesArray.count == 0)
//    {
//        [MBProgressHUD showToast:@"请选择图片"];
//        return;
//    }
    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (HXPhotoModel * model in self.imagesArray)
    {
        NSData * data = UIImagePNGRepresentation(model.thumbPhoto);
        MYLog(@"==========%lu", (unsigned long)data.length);
        [dataArray addObject:data];
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    NSDictionary * parmaDic = @{@"topic_id":self.topicId,
                                @"device_id":[DeviceInfo shareInstance].deviceType,
                                @"content":self.enterText.text,
                                @"member_id":userID};
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"base/comment/add"];
    [SwpNetworking swpPOSTAddFiles:urlstr parameters:parmaDic fileName:@"pic_screenshots" fileDatas:dataArray swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject)
     {
         if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
         {
             [YJProgressHUD showSuccess:@"评论发表成功,后台正在审核中" inview:YYToolModel.getCurrentVC.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 if (self.commentSuccess) self.commentSuccess();
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }
         else
         {
             [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"]];
         }
     } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
         
     }];
}

#pragma mark --get commit--
- (void)getCommitApiRequest:(NSString *)content {

    GameSubmitCommitApi *api = [[GameSubmitCommitApi alloc] init];
    //    WEAKSELF
    api.topic_id = self.topicId;
    api.content = content;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleCommitSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleCommitSuccess:(GameSubmitCommitApi *)api {
    if (api.success == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
