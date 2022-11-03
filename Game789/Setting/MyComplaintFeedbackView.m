//
//  MyComplaintFeedbackView.m
//  Game789
//
//  Created by Maiyou on 2020/4/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyComplaintFeedbackView.h"

static const CGFloat kPhotoViewMargin = 12.0;

@implementation MyComplaintFeedbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyComplaintFeedbackView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [self prepareBasic];
        
        [self creatPhotoPickview];
    }
    return self;
}

- (void)prepareBasic
{
    for (int i = 0; i < 9; i ++)
    {
        UIButton * button = (UIButton *)[self viewWithTag:100 + i];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    }
    self.containerView_height.constant = CGRectGetMaxY(self.footerView.frame);
    
    [self.complaintQQ addTarget:self action:@selector(enterQQEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)creatPhotoPickview
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.footerView.height)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = CGSizeMake(kScreenW, 0);
    [self.footerView addSubview:scrollView];
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
        make.left.equalTo(self.footerView.mas_left);
        make.top.equalTo(self.footerView.mas_top);
        make.right.equalTo(self.footerView.mas_right);
        make.bottom.equalTo(self.footerView.mas_bottom);
    }];
}

- (void)enterQQEditingChanged:(UITextField *)textField
{
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (IBAction)sureSubmitClick:(id)sender
{
    if (self.complaintUser.text.length == 0)
    {
        [MBProgressHUD showToast:@"请填写投诉对象" toView:self.currentVC.view];
        return;
    }
    if (self.complaintMobile.text.length == 0)
    {
        [MBProgressHUD showToast:@"请填写投诉对象联系方式" toView:self.currentVC.view];
        return;
    }
    if (self.complaintName.text.length == 0)
    {
        [MBProgressHUD showToast:@"请填写投诉人姓名" toView:self.currentVC.view];
        return;
    }
    if (self.complaintQQ.text.length == 0)
    {
        [MBProgressHUD showToast:@"请填写投诉人QQ" toView:self.currentVC.view];
        return;
    }
    if (self.complaintContent.text.length < 5)
    {
        [MBProgressHUD showToast:@"投诉内容至少5个字" toView:self.currentVC.view];
        return;
    }
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"base/feedback"];
    NSMutableDictionary * parmaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"member_id":[YYToolModel getUserdefultforKey:USERID],
    @"user_name": self.complaintUser.text,
    @"user_connect":self.complaintMobile.text,
    @"qq":self.complaintQQ.text,
    @"content":self.complaintContent.text,
    @"contact":self.complaintName.text,
    @"type":@"suggest"}];
    
    NSMutableArray * dataArray = [NSMutableArray array];
    for (HXPhotoModel * model in self.imagesArray)
    {
        NSData * data = UIImagePNGRepresentation(model.thumbPhoto);
        MYLog(@"==========%lu", (unsigned long)data.length);
        [dataArray addObject:data];
    }
    [SwpNetworking swpPOSTAddFiles:urlstr parameters:parmaDic fileName:@"imgs" fileDatas:dataArray swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject)
     {
         MYLog(@"===============%@", resultObject);
         if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
         {
             [YJProgressHUD showSuccess:@"提交成功" inview:self.currentVC.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.currentVC.navigationController popViewControllerAnimated:YES];
             });
         }
         else
         {
             [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"] toView:self.currentVC.view];
         }
     } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
         
     }];
}

#pragma mark - 添加图片
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
    
    self.imagesArray = [NSMutableArray arrayWithArray:allList];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    self.footerView_height.constant = CGRectGetMaxY(frame) + kPhotoViewMargin;
    [self layoutIfNeeded];
    self.containerView_height.constant = CGRectGetMaxY(self.tipView.frame);
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.photoMaxNum = 5;
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
@end
