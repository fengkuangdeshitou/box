//
//  GameDetailHeaderView.m
//  Game789
//
//  Created by Maiyou on 2018/11/5.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameDetailHeaderView.h"
#import "MyConsultQuestionViewController.h"
#import "GameDetailKaifuViewController.h"
#import "MyGetVoucherListApi.h"
#import "MyActivityGuideController.h"
#import "NoticeDetailViewController.h"
#import "MyVoucherListViewController.h"
#import "MyShowVoucherInfoCell.h"
#import "MyGameAllVouchersController.h"
#import "MyPushGameAllVouchersController.h"
#import "MyVoucherListModel.h"
#import "ShowVipTableController.h"
#import "MyGameGiftListController.h"

@class MyReceiveGameVoucherApi;

static SJEdgeControlButtonItemTag SJEdgeControlButtonItemTag_Share = 10;

@implementation GameDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"GameDetailHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.videoBackView_height.constant = kScreenW * 9 / 16;
//        [self showGameTypes];
        
        [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void *)[AVAudioSession sharedInstance]];
        self.gradientLayer = [CAGradientLayer layer];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == (__bridge void *)[AVAudioSession sharedInstance])
    {
        self.videoVoice.selected = YES;
        self.player.mute = NO;
        [DeviceInfo shareInstance].isOpenVoice = YES;
    }
}

- (void)volumeChanged:(NSNotification *)noti
{
    self.videoVoice.selected = YES;
    self.player.mute = NO;
}

- (void)creatVideoPlayer
{
    // create player of the lightweight type
    _player = [SJVideoPlayer lightweightPlayer];
    [self insertSubview:_player.view belowSubview:self.videoVoice];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.offset(0);
       make.leading.trailing.offset(0);
       make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
   
    WEAKSELF
//    _player.controlLayerDelegate = self;
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.dataDic[@"game_info"][@"video_url"]]];
    _player.hideBackButtonWhenOrientationIsPortrait = YES;
    _player.mute = ![DeviceInfo shareInstance].isOpenVoice;
    _player.enableFilmEditing = YES;
    _player.disableAutoRotation = YES;
    _player.playTimeDidChangeExeBlok = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        if (videoPlayer.currentTime == videoPlayer.totalTime)
        {
            [weakSelf.player replay];
        }
//        weakSelf.videoTimeLabel.text = [NSDate dateWithFormat:@"mm:ss" WithTS:videoPlayer.totalTime - videoPlayer.currentTime];
    };
//    self.videoTimeLabel.text = _player.totalTimeStr;
    self.videoVoice.selected = [DeviceInfo shareInstance].isOpenVoice;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 49)];
    customView.backgroundColor = [UIColor clearColor];
    SJEdgeControlButtonItem *customItem = [[SJEdgeControlButtonItem alloc] initWithCustomView:customView tag:SJEdgeControlButtonItemTag_Share/* 这个标记一定要与其他item区分开, 我这里为了方便就使用了同一个... */];
    [_player.defaultEdgeControlLayer.bottomAdapter addItem:customItem];
}

#pragma mark - 设置显示类型
- (void)showGameTypes
{
    UIImageView *typeNameLabelImageView = [UIImageView new];
    typeNameLabelImageView.backgroundColor = [UIColor clearColor];
    typeNameLabelImageView.image = [UIImage imageNamed:@""];
    [self.game_icon addSubview:typeNameLabelImageView];
    
    self.typeNameLabelImageView = typeNameLabelImageView;
    [typeNameLabelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.game_icon.mas_centerX).offset(20);
        make.centerY.mas_equalTo(self.game_icon.mas_centerY).offset(-20);
        make.height.equalTo(@15);
        make.width.equalTo(self.game_icon.mas_width);
    }];
    
    UILabel *typeNameLabel = [UILabel new];
    typeNameLabel.backgroundColor = [UIColor colorWithRed:245/255.0 green:84/255.0 blue:64/255.0 alpha:1.0];
    typeNameLabel.textColor = [UIColor whiteColor];
    typeNameLabel.textAlignment = NSTextAlignmentCenter;
    typeNameLabel.font = [UIFont systemFontOfSize:12];
    typeNameLabel.text = @"BT";
    [self.typeNameLabelImageView addSubview:typeNameLabel];
    [typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    self.typeNameLabelImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.typeNameLabel = typeNameLabel;
    self.typeNameLabelImageView.transform = CGAffineTransformMakeRotation(M_PI/4);
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSDictionary * game_info = dataDic[@"game_info"];
    if (![game_info[@"video_url"] isBlankString])
    {
        //创建视频
        [self creatVideoPlayer];
    }
    else
    {
        self.videoVoice.hidden = YES;
    }
    [self.headerImageView yy_setImageWithURL:[NSURL URLWithString:game_info[@"banner_url"]] placeholder:MYGetImage(@"banner_photo")];
    
    //头像
    [self.game_icon yy_setImageWithURL:game_info[@"game_image"][@"thumb"] placeholder:MYGetImage(@"game_icon")];
    //名称
    self.showDesLabel.text = game_info[@"game_name"];
    //标记
    NSArray * sepArray = [NSArray array];
    if ([game_info[@"game_desc"] containsString:@"+"])
    {
        sepArray = [game_info[@"game_desc"] componentsSeparatedByString:@"+"];
        for (int i = 0; i < sepArray.count; i ++)
        {
            NSString * str = [NSString stringWithFormat:@"%@", sepArray[i]];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (i == 0)
            {
                self.showTag1.hidden = NO;
                self.showTag1.text  = [NSString stringWithFormat:@"%@", str];
            }
            else if (i == 1)
            {
                self.showTag2.hidden = NO;
                self.showTag2.text = [NSString stringWithFormat:@"%@", str];
            }
            else if (i == 2)
            {
                self.showTag3.hidden = NO;
                self.showTag3.text = [NSString stringWithFormat:@"%@", str];
            }
            else if (i == 3)
            {
                self.showTag4.hidden = NO;
                self.showTag4.text = [NSString stringWithFormat:@"%@", str];
            }
        }
        self.showDetail.hidden = YES;
    }
    else
    {
        self.showDetail.hidden = NO;
        self.showDetail.text = game_info[@"introduction"];
        NSArray * arr = @[@"#a7d676",@"#ffa95c",@"#ffc000",@"#79b8ff",@"#54C5CD"];
        self.showDetail.textColor = [UIColor colorWithHexString:arr[arc4random()%arr.count]];
        self.showTagView1.hidden = YES;
        self.showTagView2.hidden = YES;
        self.showTagView3.hidden = YES;
        self.showTagView4.hidden = YES;
    }
    
    NSString * nameRemark = game_info[@"nameRemark"];
    BOOL isNameRemark = [YYToolModel isBlankString:nameRemark];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", nameRemark];
    self.nameRemark.hidden = isNameRemark;
    
    //游戏类型,下载量,大小
    NSString * name = @"";
    NSArray * nameArray = game_info[@"game_classify_name"];
    for (int i = 0; i < nameArray.count; i ++)
    {
        ([name isEqualToString:@""]) ?
        (name = nameArray[i][@"tagname"]) :
        (name = [NSString stringWithFormat:@"%@ %@", name, nameArray[i][@"tagname"]]);
    }
    if ([game_info[@"game_species_type"] integerValue] != 3)
    {
        name = [name stringByAppendingString:[NSString stringWithFormat:@"｜%@%@｜%@", game_info[@"howManyPlay"], @"人在玩".localized, game_info[@"game_size"][@"ios_size"]]];
    }
    self.showGameType.text = name;
    
    //折扣显示/游戏类型
    CGFloat discount = [game_info[@"discount"] floatValue];
    NSInteger game_species_type = [game_info[@"game_species_type"] integerValue];
    if (game_species_type == 3)
    {
        self.searchDiscount.transform = CGAffineTransformMakeRotation(-M_PI_4);
        self.searchDiscount.text = @"H5";
        self.searchDiscountView.hidden = NO;
    }
    else if (game_species_type == 4)
    {
        self.typeNameLabel.hidden = YES;
    }
    else
    {
        if (discount < 1 && discount > 0)
        {
            CGFloat discount = [game_info[@"discount"] floatValue];
            self.searchDiscount.transform = CGAffineTransformMakeRotation(-M_PI_4);
            if (discount < 1 && discount > 0)
            {
                discount = discount * 10;
                self.searchDiscount.text = [NSString stringWithFormat:@"%.1f折", discount];
                self.searchDiscountView.hidden = NO;
            }else{
                self.searchDiscountView.hidden = YES;
            }
        }
        else
        {
            if (game_species_type == 2)
            {
                self.searchDiscount.transform = CGAffineTransformMakeRotation(-M_PI_4);
                self.searchDiscount.text = @"官方";
                self.searchDiscountView.hidden = NO;
            }
            else
            {
                self.searchDiscountView.hidden = YES;
            }
        }
    }
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dic in dataDic[@"voucherslist"])
    {
        MyVoucherListModel * model = [[MyVoucherListModel alloc] initWithDictionary:dic];
        [array addObject:model];
    }
    self.voucherArray = array;
    
    //显示代金券数量
    if ([dataDic[@"voucher_info"][@"num"] integerValue] > 0)
    {
        self.showVoucherNum.text = [NSString stringWithFormat:@"%@  ", dataDic[@"voucher_info"][@"num"]];
    }
    self.showVoucherNum.hidden = ![dataDic[@"voucher_info"][@"num"] boolValue];
    
    //礼包数量
    self.showGiftNum.text = [NSString stringWithFormat:@"%@  ", dataDic[@"packsNum"]];
    self.showGiftNum.hidden = ![dataDic[@"packsNum"] boolValue];
    //活动数量
    self.showActivityNum.text = [NSString stringWithFormat:@"%@  ", dataDic[@"activityNum"]];
    self.showActivityNum.hidden = ![dataDic[@"activityNum"] boolValue];
    
    self.showVipTitle.text = [NSString stringWithFormat:@"《%@》VIP表", game_info[@"game_name"]];
    
    NSDictionary * bottom_lable = dataDic[@"bottom_lable"];
    if (bottom_lable.count > 0) {
        self.left_content.text = [NSString stringWithFormat:@" %@ ",bottom_lable[@"left_content"]];
        self.right_content.text = bottom_lable[@"right_content"];
        int type = [bottom_lable[@"type"] intValue];
        self.left_content.backgroundColor = [UIColor colorWithHexString:type == 1 ? @"#FF8C50" : @"#9F9DFC"];
        self.right_content.textColor = self.left_content.backgroundColor;
        self.sortView.layer.borderWidth = 0.5;
        self.sortView.layer.borderColor = self.left_content.backgroundColor.CGColor;
        self.sortView_height.constant = 16;
    }else{
        self.sortView_height.constant = 0;
    }
    self.top_lable.text = dataDic[@"top_lable"];
    self.gradientView.hidden = self.top_lable.text.length == 0;
    if (self.top_lable.text.length == 0) {
        [self.gradientLayer removeFromSuperlayer];
        self.showDesLabel.attributedText = nil;
        self.showDesLabel.text = game_info[@"game_name"];
    }else{
        CGFloat gradientWidth = [self.top_lable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]} context:nil].size.width+8;
        self.gradientLayer.frame = CGRectMake(0, 0, gradientWidth, 16);
        self.gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#EEBE75"].CGColor,(id)[UIColor colorWithHexString:@"#FFE7BD"].CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
        self.gradientLayer.cornerRadius = 3;
        [self.gradientView.layer insertSublayer:self.gradientLayer atIndex:0];
        NSString * gamaname = game_info[@"game_name"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:gamaname];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = gradientWidth+5;
        [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, gamaname.length)];
        self.showDesLabel.attributedText = att;
    }
    
    [self layoutIfNeeded];
    
    CGFloat view_height = CGRectGetMaxY(self.bottomBackView.frame);
    
    self.height = view_height;
}

- (IBAction)videoVoiceBtnClick:(id)sender
{
    UIButton * button = sender;
    
    self.player.mute = !self.player.isMute;
    button.selected  = !self.player.isMute;
    [DeviceInfo shareInstance].isOpenVoice = button.isSelected;
}

#pragma mark - 查看vip表
- (IBAction)viewGameVipDetail
{
    NSArray * array = self.dataDic[@"game_info"][@"game_feature_list"];
    NSDictionary * dic = [array objectAtIndex:2];
    ShowVipTableController * vipTable = [ShowVipTableController new];
    vipTable.showText = [dic objectForKey:@"content"];
    vipTable.navBar.title = [dic objectForKey:@"title"];
    [self.currentVC.navigationController pushViewController:vipTable animated:YES];
}

#pragma mark — 查看更多的活动
- (IBAction)activityMoreClick
{
    [MyAOPManager gameRelateStatistic:@"ClickGameActivities" GameInfo:self.dataDic[@"game_info"] Add:@{}];
    
    MyActivityGuideController * guide = [MyActivityGuideController new];
    guide.game_id = self.dataDic[@"game_info"][@"game_id"];;
    guide.gameInfo = self.dataDic[@"game_info"];
//    guide.introduction_count = [self.dataDic[@"introduction_count"] intValue];
    [self.currentVC.navigationController pushViewController:guide animated:YES];
}

#pragma mark - 查看更多礼包
- (IBAction)giftMoreClick
{
    [MyAOPManager gameRelateStatistic:@"ClickGiftBagModule" GameInfo:self.dataDic[@"game_info"] Add:@{}];
    
     if ([self.dataDic[@"packsNum"] integerValue] <= 0)
     {
         [MBProgressHUD showToast:@"暂无可领取礼包" toView:self.currentVC.view];
         return;
     }
    
    MyGameGiftListController * gift = [MyGameGiftListController new];
    gift.gameId = self.dataDic[@"game_info"][@"game_id"];
    [self.currentVC.navigationController pushViewController:gift animated:YES];
}

- (IBAction)moreVoucherBtnClick:(id)sender
{
    if ([self.dataDic[@"voucher_info"][@"num"] integerValue] <= 0)
    {
        [MBProgressHUD showToast:@"暂无可领取代金券" toView:self.currentVC.view];
        return;
    }
//    [MyAOPManager gameRelateStatistic:@"ClickVoucherModule" GameInfo:self.dataDic[@"game_info"] Add:@{@"ab_test1":self.dataDic[@"ab_test_game_detail_welfare"]}];
    
    [self getVoucherList:NO];
}

- (void)getVoucherList:(BOOL)isVoucherList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTipBarView" object:nil];
    NSDictionary * game_info = self.dataDic[@"game_info"];
    
    if (isVoucherList)
    {
        MyGameAllVouchersController * voucher = [[MyGameAllVouchersController alloc] init];
        voucher.dataDic = self.dataDic;
        voucher.receivedVoucherAction = ^(NSArray * _Nonnull array, MyVoucherListModel * _Nonnull model) {
            [MyAOPManager gameRelateStatistic:@"ClickToGetVoucher" GameInfo:game_info Add:@{}];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refrefshGiftNotification" object:nil];
        };
        [self.currentVC presentViewController:voucher animated:YES completion:^{
            
        }];
    }
    else{
        MyPushGameAllVouchersController * voucher = [MyPushGameAllVouchersController new];
        voucher.dataDic = self.dataDic;
        voucher.receivedVoucherAction = ^(NSArray * _Nonnull array, MyVoucherListModel * _Nonnull model) {
            [MyAOPManager gameRelateStatistic:@"ClickToGetAReplacementCoupon" GameInfo:game_info Add:@{}];
        };
        [self.currentVC.navigationController pushViewController:voucher animated:YES];
    }
}

@end
