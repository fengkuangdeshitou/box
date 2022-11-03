//
//  MyAnswerHeaderView.h
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "MyGetQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAnswerHeaderView : BaseView

@property (nonatomic, strong) MyGetQuestionModel * quesModel;
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *showQuestion;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (nonatomic, assign) CGFloat viewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (nonatomic, strong) UIViewController * currentView;
@property (weak, nonatomic) IBOutlet UIImageView *memberLevel;
@property (weak, nonatomic) IBOutlet UIImageView *showMember;

@end

NS_ASSUME_NONNULL_END
