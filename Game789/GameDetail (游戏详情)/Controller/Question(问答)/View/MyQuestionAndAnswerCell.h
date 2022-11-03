//
//  MyQuestionAndAnswerCell.h
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGetQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyQuestionAndAnswerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showQuestion;
@property (weak, nonatomic) IBOutlet UILabel *quesLabel1;
@property (weak, nonatomic) IBOutlet UILabel *quesLabel2;
@property (weak, nonatomic) IBOutlet UIView *questionView1;
@property (weak, nonatomic) IBOutlet UIView *questionView2;
@property (weak, nonatomic) IBOutlet UIView *questionVIew3;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *noAnswerTips;
@property (nonatomic, strong) MyGetQuestionModel * quesModel;

@end

NS_ASSUME_NONNULL_END
