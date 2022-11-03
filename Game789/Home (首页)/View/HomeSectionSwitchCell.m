//
//  HomeSectionSwitchCell.m
//  Game789
//
//  Created by Maiyou on 2018/11/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "HomeSectionSwitchCell.h"
#import "GameSubsectionViewController.h"

@implementation HomeSectionSwitchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIButton * button = (UIButton *)[self viewWithTag:10];
    self.selectedButton = button;
    
    NSString * showDate = [YYToolModel getUserdefultforKey:@"SelectSectionGameType"];
    NSString * nowDate  = [NSDate getCurrentTimes:@"yyyy-MM-dd"];
    if (showDate == NULL || ![showDate isEqualToString:nowDate])
    {
        self.redView.hidden = NO;
    }
    else
    {
        self.redView.hidden = YES;
    }
}

- (IBAction)switchButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if (button != self.selectedButton)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView_left.constant = button.tag == 10 ? button.x : button.width + 25;
        }];
        [self.selectedButton setTitleColor:[UIColor darkTextColor] forState:0];
        [button setTitleColor:[UIColor colorWithHexString:@"#FF802F"] forState:0];
        self.selectedButton = button;
        
        if (button.tag == 11)
        {
            if (!self.redView.hidden)
            {
                self.redView.hidden = YES;
                NSString * nowDate  = [NSDate getCurrentTimes:@"yyyy-MM-dd"];
                [YYToolModel saveUserdefultValue:nowDate forKey:@"SelectSectionGameType"];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectSectionGameType:)])
        {
            [self.delegate selectSectionGameType:button.tag];
        }
    }
}


- (IBAction)pushRankList:(id)sender
{
    GameSubsectionViewController * game = [[GameSubsectionViewController alloc]init];
    game.hidesBottomBarWhenPushed = YES;
    game.isShowBack = YES;
    game.classType = self.game_classType;
    [self.currentVC.navigationController pushViewController:game animated:YES];
}
@end
