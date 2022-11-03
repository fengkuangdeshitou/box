//
//  MyUserHeaderView.h
//  Game789
//
//  Created by Maiyou on 2019/10/18.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserHeaderView : BaseView

@property (nonatomic, strong) UIViewController * currentVC;
@property (weak, nonatomic) IBOutlet UIButton *iconImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *showMobile;
@property (weak, nonatomic) IBOutlet UILabel *platCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldCoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherNumLabel;
@property (nonatomic, weak) IBOutlet UIImageView * memberIcon;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userName_top;
@property (weak, nonatomic) IBOutlet UIButton *openMemberBtn;
@property (weak, nonatomic) IBOutlet UILabel *showMonthcardDesc;
@property (weak, nonatomic) IBOutlet UILabel *showExpireTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expireTimeCenterY;
@property (weak, nonatomic) IBOutlet UILabel *month_card_desc;
@property (weak, nonatomic) IBOutlet UILabel *vip_desc;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
