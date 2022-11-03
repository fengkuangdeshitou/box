//
//  MyPersonalQuestionCell.h
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyGetQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPersonalQuestionCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showQuestion;
@property (weak, nonatomic) IBOutlet UILabel *quesLabel1;
@property (weak, nonatomic) IBOutlet UILabel *quesLabel2;
@property (weak, nonatomic) IBOutlet UIView *questionView1;
@property (weak, nonatomic) IBOutlet UIView *questionVIew3;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *showGameIcon;
@property (weak, nonatomic) IBOutlet UILabel *showGameName;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionView1_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionView1_top;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, assign) BOOL isAnswer;
@property (nonatomic, strong) MyGetQuestionModel * quesModel;

@end

NS_ASSUME_NONNULL_END
