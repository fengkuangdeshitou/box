//
//  HGCommunityPushVC.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HGCommunityPushVC.h"
#import "MBProgressHUD+QNExtension.h"
#import "HGCommunicityTopicV.h"
#import "HXPhotoModel.h"
#import "MyAddTopicViewController.h"

#import "MyCommunityRequestApi.h"
@class MyCommunityAddRequestApi;

static const CGFloat kPhotoViewMargin = 20.0;

@interface HGCommunityPushVC () <HXPhotoViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *enterText;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UILabel *uploadName;
@property (weak, nonatomic) IBOutlet UIView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *uploadDes;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageListView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backVIew_top;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *enterTextCount;

@property (nonatomic, strong) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray * imagesArray;

//上传当前图片的下标
@property (nonatomic, assign) NSInteger uploadImageIndex;
@property (nonatomic, strong) NSMutableArray * uploadImagesArray;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, strong) HXPhotoModel *video;

@end


@implementation HGCommunityPushVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBaisc];
        
    [self creatImageList];
}

- (void)prepareBaisc
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.title = @"发布话题";
    self.backVIew_top.constant = kStatusBarAndNavigationBarHeight + 10;
    self.enterText.zw_placeHolder = @"来吧，尽情发挥吧...".localized;
    self.enterText.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedTopicAction)];
    [self.upView addGestureRecognizer:tap];
    
    WEAKSELF
    [self.navBar wr_setRightButtonWithTitle:@"发布".localized titleColor:FontColor28];
    self.navBar.onClickRightButton = ^{
        MYLog(@"发表");
        [weakSelf sureButtonAction];
    };
}


- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.maxNum = 9;
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.rowCount = 4;
        _manager.configuration.clarityScale = 6.5;
        _manager.configuration.videoMaximumDuration = 3;
        _manager.configuration.downloadICloudAsset = NO;
        _manager.configuration.selectTogether = NO;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
//        _manager.configuration.selectVideoLimitSize = YES;
        _manager.configuration.specialModeNeedHideVideoSelectBtn = NO;
//        _manager.configuration.limitVideoSize = 1024 * 1024 * 30;
//        _manager.configuration.videoCodecKey = AVVideoCodecH264;
//        _manager.configuration.sessionPreset = AVCaptureSessionPreset640x480;
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.videoCanEdit = NO;
        _manager.configuration.photoListCancelLocation = HXPhotoListCancelButtonLocationTypeLeft;
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

- (void)selectedTopicAction
{
    WEAKSELF
    MyAddTopicViewController * topic = [[MyAddTopicViewController alloc] init];
    topic.AddTopicBlock = ^(NSString * _Nullable name, NSString * _Nullable titleId) {
        weakSelf.topicLabel.text = name;
        weakSelf.topicId = titleId;
        weakSelf.topicLabel.textColor = [UIColor colorWithHexString:@"#282828"];
    };
    [self presentViewController:topic animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    MYLog(@"======%@", textView.text);
    if (textView.text.length > 500) {
        textView.text = [textView.text substringToIndex:500];
    }
    self.enterTextCount.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
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
    
    if (videos.count > 0) {
        self.video = allList[0];
    }else {
        self.video = nil;
    }
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
    if (!self.topicId) {
        [MBProgressHUD showToast:@"请选择话题" toView:self.view];
        return;
    }
    if (self.enterText.text.length < 20)
    {
        [MBProgressHUD showToast:@"发布话题不少于20个字" toView:self.view];
        return;
    }
    NSString * content = [self.enterText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (HXPhotoModel * model in self.imagesArray)
    {
        NSData * data = UIImagePNGRepresentation(model.thumbPhoto);
        MYLog(@"==========%lu", (unsigned long)data.length);
        [dataArray addObject:data];
    }
    
    NSMutableDictionary * parmaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"themeid":self.topicId,
    @"content":self.enterText.text}];
    
    self.uploadImagesArray = [NSMutableArray array];
    if (self.video) {
        [self uploadDataVideo];
    }else if(self.imagesArray.count > 0) {
        MBProgressHUD * hud = [MBProgressHUD showProgress:[NSString stringWithFormat:@"正在上传第%ld张图片", (long)self.uploadImageIndex + 1] toView:self.view];
        [self uploadImagesData:parmaDic Hud:hud];
    } else {
        [self uploadData:parmaDic File:NO];
    }
}

- (void)uploadImagesData:(NSMutableDictionary *)parmaDic Hud:(MBProgressHUD *)hud
{
    hud.progress = (float)self.uploadImageIndex / (float)self.imagesArray.count;
    if (self.uploadImageIndex < self.imagesArray.count)
    {
        HXPhotoModel * model = self.imagesArray[self.uploadImageIndex];
        [model requestImageDataStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
            
        } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
            
        } success:^(NSData * _Nullable imageData, UIImageOrientation orientation, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
//            NSData * data = UIImageJPEGRepresentation(model.previewPhoto, 1.0);
            MYLog(@"%ld-----========----%@", (long)self.uploadImageIndex, model.thumbPhoto);
            

            NSString * url = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"upload_image"];
            [SwpNetworking swpPOSTAddFile:url parameters:@{@"type":@"forum",@"ImageType":model.type == 2 ? @"GIF" : @"png"} fileName:@"img" fileData:imageData swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
                
                if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
                {
                    self.uploadImageIndex = self.uploadImageIndex + 1;
                    [self.uploadImagesArray addObject:resultObject[@"data"][@"path"]];
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
                            [self uploadData:parmaDic File:NO];
                        });
                    }
                }
                else
                {
                    [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"] toView:self.view];
                    self.uploadImageIndex = 0;
                }
            } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
                self.uploadImageIndex = 0;
            } ShowHud:NO];
        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            
        }];
        
    }
}

- (void)uploadDataVideo
{
    if (self.imagesArray.count > 0)
    {
        PHAsset *asset = self.video.asset;
        NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
        NSString *filename = ((PHAssetResource*)resources[0]).originalFilename;
        MBProgressHUD * hud = [MBProgressHUD showProgress:[NSString stringWithFormat:@"正在上传"] toView:self.view];
        HXPhotoModel * model = self.imagesArray[0];
        [model exportVideoWithPresetName:AVAssetExportPresetHighestQuality startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
            
        } iCloudProgressHandler:^(double progress, HXPhotoModel * _Nullable model) {
            
        } exportProgressHandler:^(float progress, HXPhotoModel * _Nullable model) {
            
        } success:^(NSURL * _Nullable videoURL, HXPhotoModel * _Nullable model) {
            NSData * videoData = [NSData dataWithContentsOfURL:videoURL];
            [SwpNetworking swpPOSTVideoFile:@"/upload_video" parameters:@{@"type":@"forum"} name:@"video" fileName:filename fileData:videoData progress:^(float progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.progress = progress;
                });
            } swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
                [hud hideAnimated:YES];
                NSDictionary * data = resultObject[@"data"];
                NSDictionary * status = resultObject[@"status"];
                if ([status[@"succeed"] integerValue] == 1) {
                    NSString * videoUrl = data[@"path"];
                    NSMutableDictionary * parmaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"themeid":self.topicId,
                         @"content":self.enterText.text,
                        @"video":videoUrl}];
                    [self uploadData:parmaDic File:YES];
                }
                else
                {
                    [MBProgressHUD showToast:status[@"error_desc"] toView:self.view];
                }
            } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
                [hud hideAnimated:YES];
            }];
        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            [hud hideAnimated:YES];
        }];
    }
}

- (void)uploadData:(NSMutableDictionary *)parmaDic File:(BOOL)isVideo
{
    if (!isVideo)
    {
        parmaDic[@"imgs"] = self.uploadImagesArray;
    }
    MyCommunityAddRequestApi * api = [[MyCommunityAddRequestApi alloc] init];
    api.isShow = YES;
    api.dataDic = parmaDic;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"提交成功，后台审核中" inview:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        self.uploadImageIndex = 0;
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)convertMp4 {
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_filePathURL options:nil];
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyyMMddHHmmss"];
//    _fileName = [NSString stringWithFormat:@"output-%@.mp4",[formater stringFromDate:[NSDate date]]];
//    _outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", _fileName];
//    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//
//    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
//      MyLog(@"outPath = %@",_outfilePath);
//      AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//      exportSession.outputURL = [NSURL fileURLWithPath:_outfilePath];
//      exportSession.outputFileType = AVFileTypeMPEG4;
//      [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
//          MyLog(@"AVAssetExportSessionStatusCompleted---转换成功");
//          _filePath = _outfilePath;
//          _filePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",_outfilePath]];
//           MyLog(@"转换完成_filePath = %@\\n_filePathURL = %@",_filePath,_filePathURL);
//          //获取大小和长度
//          [self SetViewText];
//          [self uploadNetWorkWithParam:@{@"contenttype":@"application/octet-stream",@"discription":description}];
//        }else{
//          MyLog(@"转换失败,值为:%li,可能的原因:%@",(long)[exportSession status],[[exportSession error] localizedDescription]);
//          [_hud hide:YES];
//          [MyHelper showAlertWith:nil txt:@"转换失败,请重试"];
//        }
//      }];
//    }
}



@end
