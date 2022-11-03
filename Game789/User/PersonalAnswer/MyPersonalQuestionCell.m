//
//  MyPersonalQuestionCell.m
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyPersonalQuestionCell.h"

@implementation MyPersonalQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewGameDetail)];
    [self.showGameIcon addGestureRecognizer:tap];
}

- (void)viewGameDetail
{
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = self.quesModel.game_id;
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuesModel:(MyGetQuestionModel *)quesModel
{
    _quesModel = quesModel;
    
    NSArray * array = nil;
    if (self.isAnswer)
    {
        if ([YYToolModel isBlankString:quesModel.content])
        {
            self.questionView1.hidden = YES;
            self.questionView1_top.constant = 0;
            self.questionView1_bottom.constant = 5;
            
            self.quesLabel1.text = @"";
            self.showCount.text = @"暂无回答";
            self.showCount.textColor = FontColor99;
        }
        else
        {
            self.questionView1.hidden = NO;
            self.questionView1_top.constant = 5;
            self.questionView1_bottom.constant = 10;
            
            self.quesLabel1.text = quesModel.content;
            self.showCount.text = @"";
        }
        array = @[@"my_wd_da", @"my_wd_wen"];
        self.quesLabel1.text = quesModel.question;
        self.showQuestion.text = quesModel.content;
    }
    else
    {
        if ([quesModel.answers[@"count"] integerValue] == 0)
        {
            self.questionView1.hidden = YES;
            self.questionView1_top.constant = 0;
            self.questionView1_bottom.constant = 5;
            
            self.quesLabel1.text = @"";
            self.showCount.text = @"暂无回答";
            self.showCount.textColor = FontColor99;
        }
        else
        {
            self.questionView1.hidden = NO;
            self.questionView1_top.constant = 5;
            self.questionView1_bottom.constant = 10;
            
            NSDictionary * dic = quesModel.answers[@"list"][0];
            self.quesLabel1.text = dic[@"content"];
            
            self.showCount.text = [NSString stringWithFormat:@"查看全部%@个回答", quesModel.answers[@"count"]];
            self.showCount.textColor = MAIN_COLOR;
        }
        
        array = @[@"my_wd_wen", @"my_wd_da"];
        self.showQuestion.text = quesModel.question;
    }
    
    for (int i = 0; i < array.count; i ++)
    {
        UIImageView * imageView = [self viewWithTag:100 + i];
        imageView.image = MYGetImage(array[i]);
    }
    
    self.showTime.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:quesModel.time.doubleValue];
    
    [self.showGameIcon sd_setImageWithURL:[NSURL URLWithString:quesModel.game_image[@"thumb"]]];
    
    self.showGameName.text = quesModel.game_name;
    self.nameRemark.layer.cornerRadius = 3;
    self.nameRemark.layer.borderColor = [UIColor colorWithHexString:@"#E3B579"].CGColor;
    self.nameRemark.layer.borderWidth = 0.5;
    self.nameRemark.hidden = quesModel.nameRemark.length == 0;
    //显示游戏类型
    NSString * nameRemark = quesModel.nameRemark;
    if (![YYToolModel isBlankString:nameRemark])
    {
        self.nameRemark.text = [quesModel.nameRemark stringByAppendingString:@"  "];
    }
    
    self.showGameType.text = quesModel.game_classify_name;
}

@end
