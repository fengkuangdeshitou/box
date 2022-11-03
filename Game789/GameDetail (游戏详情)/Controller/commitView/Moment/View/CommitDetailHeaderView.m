//
//  CommitDetailHeaderView.m
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "CommitDetailHeaderView.h"
#import <MLLabel.h>
#import "MMImageListView.h"
#import "UserPersonalCenterController.h"

@implementation CommitDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"CommitDetailHeaderView" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    
    self.showContent.text = moment.content;
    self.showContent.textColor = moment.user_id.intValue == 928440 ? UIColor.redColor : kLinkTextColor;
    self.showTime.text = [Utility getDateFormatByTimestamp:[moment.time doubleValue]];
    
    self.userName.text = moment.user_nickname;
    self.userName.textColor = moment.user_id.intValue == 928440 ? UIColor.redColor : kLinkTextColor;

    [self.user_icon sd_setImageWithURL:[NSURL URLWithString:moment.user_icon] forState:0 placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    //金币
    if (moment.reward_intergral_amount.intValue > 0)
    {
        [self.showIntegral setTitle:[NSString stringWithFormat:@"%.f", moment.reward_intergral_amount.floatValue] forState:0];
        if (moment.reward_intergral_amount.floatValue >= 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_4");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#FA4D47"] forState:0];
        }else if (moment.reward_intergral_amount.floatValue >= 10 && moment.reward_intergral_amount.floatValue < 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_3");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
        }else if (moment.reward_intergral_amount.floatValue >= 5 && moment.reward_intergral_amount.floatValue < 10) {
            _coinImageView.image = MYGetImage(@"icon_reward_2");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
        }else {
            _coinImageView.image = MYGetImage(@"icon_reward_1");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
        }
    }
    else
    {
        self.showIntegral.hidden = YES;
        self.coinImageView.hidden = YES;
    }
    
    self.readCount.text = [NSString stringWithFormat:@"(%@%@)", @"阅读".localized, moment.view_count];
    
    CGSize attrStrSize = [YYToolModel sizeWithText:moment.content size:CGSizeMake(kScreenW - 30, MAXFLOAT) font:self.showContent.font];
    self.showContent_height.constant = attrStrSize.height + 8;
    
    CGFloat imageList_height = 0;
    if (moment.pic_list.count == 0)
    {
        self.imageViewList_height.constant = 0;
        self.imageViewList_top.constant = 0;
        self.frame = CGRectMake(0, 0, kScreenW, 70 + attrStrSize.height + 15 + 56);
    }
    else
    {
        MMImageListView * imageListView = [[MMImageListView alloc] initWithFrame:self.imageViewList.bounds];
        imageListView.isAll = YES;
        [self.imageViewList addSubview:imageListView];
        
        imageListView.moment = moment;
        self.imageViewList_height.constant = imageListView.height;
        
        imageList_height = imageListView.height;
        
        self.frame = CGRectMake(0, 0, kScreenW, 70 + attrStrSize.height + 10 + imageList_height + 15 + 56);
    }
    self.view_height = self.frame.size.height;
    
    if (moment.user_level.length >= 0)
    {
        self.memberLevelIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", moment.user_level.intValue]];
        self.member_icon.hidden = NO;
        self.memberLevelIcon.hidden = NO;
        self.member_icon.image = [UIImage imageNamed:@"hg_icon"];
        if (moment.user_level.integerValue == 0)
        {
            self.member_icon.hidden = YES;
        }
    }
    else
    {
        self.member_icon.hidden = YES;
        self.memberLevelIcon.hidden = YES;
    }
    [self layoutIfNeeded];
    
    if (!self.maskPath)
    {
        CGRect oldRect = _backView.bounds;
        oldRect.size.width = [UIScreen mainScreen].bounds.size.width;
        self.maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = self.maskPath.CGPath;
        maskLayer.frame = oldRect;
        _backView.layer.mask = maskLayer;
    }
}

#pragma mark - 查看积分规则
- (IBAction)showIntegralAction:(id)sender
{
    
}

#pragma mark - 查看用户个人信息
- (IBAction)viewUserDetailAction:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
    personal.user_id = _moment.user_id;
    personal.isHiddenBtn = YES;
    [self.currentVC.navigationController pushViewController:personal animated:YES];
}

@end
