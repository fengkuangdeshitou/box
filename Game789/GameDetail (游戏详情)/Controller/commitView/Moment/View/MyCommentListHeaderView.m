//
//  MyCommentListHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCommentListHeaderView.h"
#import "MyConsultQuestionViewController.h"

@implementation MyCommentListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyCommentListHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = BackColor;
        
        self.selectedBtn = self.sortBtn;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSDictionary * game_info = dataDic[@"game_info"];
    
    self.questionCount.text = [NSString stringWithFormat:@"有%@人正在玩该游戏", game_info[@"played_count"]];
    self.showDesc.text = [NSString stringWithFormat:@"快来加入《%@》问答社区", game_info[@"game_name"]];
    
//    self.consultTitle.text = game_info[@"played_count"];
//    if ([game_info[@"question_count"] integerValue] == 0)
//    {
//        self.consultSubtitle.text = @"游戏好不好玩？怎么玩？赶紧请教大神吧！".localized;
//        self.consultSubtitle1.text = @"";
//        self.consultSubtitle2.text = @"";
//        self.questionCount.text = @"";
//        self.answerCount.text   =  @"";
//    }
//    else
//    {
//        self.questionCount.text = game_info[@"question_count"];
//        self.answerCount.text   = game_info[@"answer_count"];
//    }
}

- (IBAction)sortBtnClick:(id)sender
{
    UIButton * button = sender;
    if (self.selectedBtn != button)
    {
        self.selectedBtn.selected = NO;
        button.selected = YES;
        self.selectedBtn = button;
        NSString * sort = @"";
        if (button.tag == 200)
        {
            sort = @"new";
        }
        else if (button.tag == 300)
        {
            sort = @"hot";
        }
        
        if (self.selectSortAction)
        {
            self.selectSortAction(sort, button.tag);
        }
    }
}

- (IBAction)viewMoreQuestionClick:(id)sender
{
    MyConsultQuestionViewController * consult = [MyConsultQuestionViewController new];
    consult.gameId = self.dataDic[@"game_info"][@"game_id"];
    consult.gameInfo = self.dataDic[@"game_info"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:consult animated:YES];
}

@end
