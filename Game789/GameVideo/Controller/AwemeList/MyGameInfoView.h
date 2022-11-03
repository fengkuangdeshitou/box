//
//  MyGameInfoView.h
//  Game789
//
//  Created by yangyongMac on 2020/2/21.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameInfoView : BaseView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonGradient;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLableText;
@property (weak, nonatomic) IBOutlet UIView *showLabelBgView;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (nonatomic, strong) NSDictionary *dataDic;
// 点击事件
@property (nonatomic, copy) void(^ViewGameInfoClick)(BOOL isDown);

@end

NS_ASSUME_NONNULL_END
