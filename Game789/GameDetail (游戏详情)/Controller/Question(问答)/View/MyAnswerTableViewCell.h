//
//  MyAnswerTableViewCell.h
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGetQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIMG;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *memberLevel;
@property (weak, nonatomic) IBOutlet UIImageView *memberMark;
@property (weak, nonatomic) IBOutlet UILabel *guanMark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guanMark_right;
@property (nonatomic, strong) UIViewController * currentView;
@property (weak, nonatomic) IBOutlet UIButton *showIntegral;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (nonatomic, assign) BOOL isMyAnswer;
@property (nonatomic, strong) MyGetQuestionModel * answerModel;

@end

NS_ASSUME_NONNULL_END
