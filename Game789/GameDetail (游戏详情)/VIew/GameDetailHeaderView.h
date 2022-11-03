//
//  GameDetailHeaderView.h
//  Game789
//
//  Created by Maiyou on 2018/11/5.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailHeaderView : UIView <SJVideoPlayerControlLayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showTag1;
@property (weak, nonatomic) IBOutlet UILabel *showTag2;
@property (weak, nonatomic) IBOutlet UILabel *showTag3;
@property (weak, nonatomic) IBOutlet UILabel *showTag4;
@property (weak, nonatomic) IBOutlet UIView *showTagView1;
@property (weak, nonatomic) IBOutlet UIView *showTagView2;
@property (weak, nonatomic) IBOutlet UIView *showTagView3;
@property (weak, nonatomic) IBOutlet UIView *showTagView4;
@property (weak, nonatomic) IBOutlet UILabel *showDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *game_icon;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoBackView_height;
@property (weak, nonatomic) IBOutlet UIButton *videoVoice;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *showVoucherNum;
@property (weak, nonatomic) IBOutlet UILabel *showActivityNum;
@property (weak, nonatomic) IBOutlet UILabel *showGiftNum;
@property (weak, nonatomic) IBOutlet UILabel *showVipTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchDiscount;
@property (weak, nonatomic) IBOutlet UIView *searchDiscountView;


@property (nonatomic,strong) UIImageView *typeNameLabelImageView;
@property (nonatomic,strong) UILabel *typeNameLabel;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSArray * voucherArray;
//是否领取代金券
@property (nonatomic, assign) BOOL isReceivedVoucher;
@property (nonatomic, strong) SJVideoPlayer * player;


@property(nonatomic,weak)IBOutlet UILabel * top_lable;
@property(nonatomic,weak)IBOutlet UIView * gradientView;
@property(nonatomic,weak)IBOutlet UIView * sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortView_height;
@property(nonatomic,weak)IBOutlet UILabel * left_content;
@property(nonatomic,weak)IBOutlet UILabel * right_content;
@property(nonatomic,strong)CAGradientLayer * gradientLayer;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

//isVoucherList 是否为代金券列表点击进入游戏详情
- (void)getVoucherList:(BOOL)isVoucherList;

@end

NS_ASSUME_NONNULL_END
