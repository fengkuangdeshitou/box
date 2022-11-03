//
//  MyGameFeedbackView.m
//  Game789
//
//  Created by Maiyou on 2020/4/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameFeedbackView.h"
#import "MyAllGameListController.h"

static const CGFloat kPhotoViewMargin = 20.0;

@implementation MyGameFeedbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameFeedbackView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        [self prepareBasic];

        [self creatPhotoPickview];
    }
    return self;
}

- (void)setGame_id:(NSString *)game_id
{
    _game_id = game_id;
}

- (void)setGameName:(NSString *)gameName
{
    _gameName = gameName;
    
    self.enterGameName.text = self.gameName;
    self.textView.zw_placeHolder = [NSString stringWithFormat:@"%@%@%@", @"请描述您在玩".localized, self.gameName, @"游戏中遇到的问题或向我们提出修改建议，我们会尽快进行处理！".localized];
    self.textView.backgroundColor = [UIColor whiteColor];
}

- (void)prepareBasic
{
    for (int i = 0; i < 9; i ++)
    {
        UIButton * button = (UIButton *)[self viewWithTag:100 + i];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    }
    
    self.typesArray = [NSMutableArray array];
    self.enterGameName.delegate = self;
    [self.enterQQ addTarget:self action:@selector(enterQQEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textView.delegate = self;
    self.deviceModel.text = [DeviceInfo shareInstance].deviceModel;
    
    self.containerView_height.constant = CGRectGetMaxY(self.footerView.frame);
    self.backgroundColor = [UIColor whiteColor];
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

- (IBAction)typeBtnClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !button.selected;
    
    NSString * title = button.titleLabel.text;
    if (button.selected && ![self.typesArray containsObject:title])
    {
        [self.typesArray addObject:title];
    }
    else if (!button.selected && [self.typesArray containsObject:title])
    {
        [self.typesArray removeObject:title];
    }
}

- (IBAction)sureSubmitClick:(id)sender
{
    if (self.gameName.length == 0)
    {
        [MBProgressHUD showToast:@"请选择要投诉的游戏" toView:self.currentVC.view];
        return;
    }
    if (self.enterQQ.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入QQ" toView:self.currentVC.view];
        return;
    }
    if (self.typesArray.count == 0)
    {
        [MBProgressHUD showToast:@"请选择举报类型" toView:self.currentVC.view];
        return;
    }
    if (self.textView.text.length < 5)
    {
        [MBProgressHUD showToast:@"反馈内容至少5个字" toView:self.currentVC.view];
        return;
    }
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"base/feedback"];
    NSMutableDictionary * parmaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"member_id":[YYToolModel getUserdefultforKey:USERID],
    @"game_id":!self.game_id ? @"" : self.game_id,
    @"content":self.textView.text,
    @"qq":self.enterQQ.text,
    @"selected_type":self.typesArray,
    @"contact":self.enterMobile.text}];
    self.game_id ? [parmaDic setValue:@"game" forKey:@"type"] : [parmaDic setValue:@"suggest" forKey:@"type"];
    
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

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.enterGameName)
    {
        MyAllGameListController * gameList = [MyAllGameListController new];
        gameList.selectGame = ^(NSDictionary *dic) {
            self.enterGameName.text = dic[@"gamename"];
            self.game_id = dic[@"gameid"];
            self.gameName = dic[@"gamename"];
        };
        [self.currentVC.navigationController pushViewController:gameList animated:YES];
        return NO;
    }
    return YES;
}

- (void)enterQQEditingChanged:(UITextField *)textField
{
    if (textField.text.length > 11)
    {
        textField.text = [textField.text substringToIndex:11];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    //限制字数不能超过140
    if (str.length > 140)
    {
        textView.text = [str substringWithRange:NSMakeRange(0, 140)];
    }
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
    self.containerView_height.constant = CGRectGetMaxY(self.footerView.frame);
    
    MYLog(@"---------%f", CGRectGetMaxY(self.footerView.frame));
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
