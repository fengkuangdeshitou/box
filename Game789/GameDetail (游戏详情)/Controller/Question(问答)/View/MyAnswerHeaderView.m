//
//  MyAnswerHeaderView.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyAnswerHeaderView.h"
#import "UserPersonalCenterController.h"

@implementation MyAnswerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAnswerHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setQuesModel:(MyGetQuestionModel *)quesModel
{
    _quesModel = quesModel;
    
    self.showQuestion.text = quesModel.question;
    
    self.userName.text = quesModel.user_nickname;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:quesModel.user_icon] forState:0];
    
    self.showCount.text = quesModel.answers[@"count"];
    
    self.showTime.text = [NSDate dateWithFormat:@"MM月dd日" WithTS:quesModel.message_time.doubleValue];
    
    [self layoutIfNeeded];
    
    self.height = CGRectGetMaxY(self.bottomLineView.frame);
    
    self.memberLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@", quesModel.user_level]];
    
    if (quesModel.user_level.integerValue == 0)
    {
        self.showMember.hidden = YES;
    }
}

- (IBAction)viewUserCenterClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * user = [UserPersonalCenterController new];
    user.user_id = self.quesModel.user_id;
    user.isHiddenBtn = YES;
    [self.currentView.navigationController pushViewController:user animated:YES];
}

@end
