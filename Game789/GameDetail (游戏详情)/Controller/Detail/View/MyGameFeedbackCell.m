//
//  MyGameFeedbackCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameFeedbackCell.h"
#import "MyFeedbackViewController.h"

@implementation MyGameFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedbackClick)];
    [self.backView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)feedbackClick
{
    MyFeedbackViewController * feedback = [MyFeedbackViewController new];
    feedback.game_id = self.gameId;
    feedback.gameName = self.gameName;
    [[YYToolModel getCurrentVC].navigationController pushViewController:feedback animated:YES];
}

@end
