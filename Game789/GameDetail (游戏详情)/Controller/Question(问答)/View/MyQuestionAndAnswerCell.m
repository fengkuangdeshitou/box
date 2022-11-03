//
//  MyQuestionAndAnswerCell.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyQuestionAndAnswerCell.h"

@implementation MyQuestionAndAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuesModel:(MyGetQuestionModel *)quesModel
{
    _quesModel = quesModel;
    
    if ([quesModel.answers[@"count"] integerValue] == 0)
    {
        self.questionView1.hidden = YES;
        self.questionView2.hidden = YES;
        self.questionVIew3.hidden = YES;
        self.noAnswerTips.hidden = NO;
    }
    else
    {
        self.questionView1.hidden = NO;
        self.questionVIew3.hidden = NO;
        self.noAnswerTips.hidden = YES;
        
        self.showCount.text = quesModel.answers[@"count"];
        NSDictionary * dic = quesModel.answers[@"list"][0];
        self.quesLabel1.text = dic[@"content"];
        if ([dic[@"is_official"] boolValue])
        {
            self.quesLabel1.textColor = [UIColor redColor];
        }
        else
        {
            self.quesLabel1.textColor = [UIColor colorWithHexString:@"333333"];
        }
        
        if ([quesModel.answers[@"count"] integerValue] == 1) {
            self.questionView2.hidden = YES;
        }
        else
        {
            self.questionView2.hidden = NO;
            NSDictionary * dic1 = quesModel.answers[@"list"][1];
            self.quesLabel2.text = dic1[@"content"];
            if ([dic1[@"is_official"] boolValue])
            {
                self.quesLabel2.textColor = [UIColor redColor];
            }
            else
            {
                self.quesLabel2.textColor = [UIColor colorWithHexString:@"333333"];
            }
        }
    }
    
    self.showQuestion.text = quesModel.question;
    
    self.showTime.text = [NSDate dateWithFormat:@"MM-dd" WithTS:quesModel.time.doubleValue];
}

@end
