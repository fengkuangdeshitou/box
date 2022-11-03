//
//  GameReviewContainerView.m
//  Game789
//
//  Created by maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameReviewContainerView.h"
#import "YHSegmentView.h"
#import "PublishedCommentController.h"
#import "MyPersonalQuestionViewController.h"
#import "MyPersonalAnswerViewController.h"
#import "PlayedGamesController.h"
#import "MyCommentReplyController.h"

@interface GameReviewContainerView ()

@property(nonatomic,copy)NSString * user_id;

@end

@implementation GameReviewContainerView

- (void)requestWithUserid:(NSString *)userid{
    self.user_id = userid;
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:self.bounds ViewControllersArr:[self getArrayVCs] TitleArr:[self getArrayTitles] TitleNormalSize:14 TitleSelectedSize:16 SegmentStyle:YHSegementStyleIndicate ParentViewController:[YYToolModel getCurrentVC] ReturnIndexBlock:^(NSInteger index) {

    }];
    segmentView.yh_bgColor = [UIColor whiteColor];
    segmentView.yh_titleNormalColor = [UIColor colorWithHexString:@"#666666"];
    segmentView.yh_titleSelectedColor = [UIColor colorWithHexString:@"#282828"];
    segmentView.yh_indicateStyle = YHSegementIndicateStyleDefine;
    segmentView.yh_segmentIndicateWidth = 18;
    segmentView.yh_segmentIndicateBottom = 6;
    [segmentView setYh_defaultSelectIndex:0];
    [self addSubview:segmentView];
}

- (NSArray *)getArrayVCs
{
    PublishedCommentController *vc_1 = [[PublishedCommentController alloc] init];
    vc_1.user_id = self.user_id;
    vc_1.hiddenNavBar = YES;
    vc_1.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    MyPersonalQuestionViewController *vc_2 = [[MyPersonalQuestionViewController alloc] init];
    vc_2.user_id = self.user_id;
    vc_2.hiddenNavBar = YES;
    vc_2.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    MyPersonalAnswerViewController *vc_3 = [[MyPersonalAnswerViewController alloc] init];
    vc_3.user_id = self.user_id;
    vc_3.hiddenNavBar = YES;
    vc_3.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    MyCommentReplyController *vc_4          = [[MyCommentReplyController alloc] init];
    vc_4.user_id = self.user_id;
    vc_4.hiddenNavBar = YES;
    vc_4.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    return @[vc_1, vc_4, vc_2, vc_3];
}

- (NSArray *)getArrayTitles
{
    return @[@"发表的点评", @"我的回复", @"我的提问", @"我的回答"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
