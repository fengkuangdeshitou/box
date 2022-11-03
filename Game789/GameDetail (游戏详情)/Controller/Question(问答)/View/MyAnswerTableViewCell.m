//
//  MyAnswerTableViewCell.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyAnswerTableViewCell.h"
#import "UserPersonalCenterController.h"

@implementation MyAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewUserCenter)];
    [self.iconIMG addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAnswerModel:(MyGetQuestionModel *)answerModel
{
    _answerModel = answerModel;
    
    self.userName.text = answerModel.user_nickname;
    
    [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:answerModel.user_icon] placeholderImage:MYGetImage(@"game_icon")];
    
    self.contentText.text = answerModel.content;
    
    self.timeLabel.text = [NSDate dateWithFormat:@"MM月dd日" WithTS:answerModel.time.doubleValue];
    
    if (answerModel.user_level.length > 0)
    {
        self.memberLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", answerModel.user_level.intValue]];
        self.memberMark.hidden = NO;
        self.memberLevel.hidden = NO;
        self.memberMark.image = [UIImage imageNamed:@"hg_icon"];
        if (answerModel.user_level.integerValue == 0)
        {
            self.memberMark.hidden = YES;
        }
    }
    else
    {
        self.memberMark.hidden = YES;
        self.memberLevel.hidden = YES;
    }
    
    if (answerModel.is_official.boolValue)
    {
        self.guanMark.hidden = NO;
        self.guanMark_right.constant = 5;
        self.guanMark.text = @" 官 ".localized;
        
        self.userName.textColor = [UIColor redColor];
        self.contentText.textColor = [UIColor redColor];
        
        self.memberMark.hidden = YES;
        self.memberLevel.hidden = YES;
    }
    else
    {
        self.guanMark.hidden = YES;
        self.guanMark_right.constant = 0;
        self.guanMark.text = @"";
        
        self.userName.textColor = [UIColor colorWithHexString:@"#666666"];
        self.contentText.textColor = [UIColor colorWithHexString:@"#0B1611"];
    }
    
    if (self.isMyAnswer)
    {
        self.memberMark.hidden = YES;
        self.memberLevel.hidden = YES;
        
        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:answerModel.game_image[@"thumb"]]];
        
        self.userName.text = answerModel.game_name;
        
        
        self.guanMark.hidden = YES;
        self.guanMark.text = @"";
        self.guanMark_right.constant = 0;
        self.userName.textColor = [UIColor colorWithHexString:@"#666666"];
        self.contentText.textColor = [UIColor colorWithHexString:@"#0B1611"];
    }
    //金币
    if (answerModel.reward_intergral_amount.intValue > 0)
    {
        [self.showIntegral setTitle:[NSString stringWithFormat:@"%.f", answerModel.reward_intergral_amount.floatValue] forState:0];
        if (answerModel.reward_intergral_amount.floatValue >= 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_4");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#FA4D47"] forState:0];
        }else if (answerModel.reward_intergral_amount.floatValue >= 10 && answerModel.reward_intergral_amount.floatValue < 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_3");
            [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
        }else if (answerModel.reward_intergral_amount.floatValue >= 5 && answerModel.reward_intergral_amount.floatValue < 10) {
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
}

- (void)viewUserCenter
{
    if (!self.isMyAnswer & !self.answerModel.is_official.boolValue)
    {
        if (![YYToolModel isAlreadyLogin]) return;
        UserPersonalCenterController * user = [UserPersonalCenterController new];
        user.user_id = self.answerModel.user_id;
        user.isHiddenBtn = YES;
        [self.currentView.navigationController pushViewController:user animated:YES];
    }
}

@end
