//
//  GameCircleContainerView.m
//  Game789
//
//  Created by maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameCircleContainerView.h"
#import "YHSegmentView.h"
#import "GameCommentViewController.h"

@interface GameCircleContainerView ()

@property(nonatomic,copy)NSString * user_id;

@end

@implementation GameCircleContainerView

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
    GameCommentViewController *vc_1 = [[GameCommentViewController alloc] init];
    vc_1.type = @"topic";
    vc_1.user_id = self.user_id;
    vc_1.hiddenNavBar = YES;
    vc_1.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    
    GameCommentViewController *vc_2 = [[GameCommentViewController alloc] init];
    vc_2.type = @"comments";
    vc_2.user_id = self.user_id;
    vc_2.hiddenNavBar = YES;
    vc_2.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    
    GameCommentViewController *vc_3 = [[GameCommentViewController alloc] init];
    vc_3.user_id = self.user_id;
    vc_3.type = @"reply";
    vc_3.hiddenNavBar = YES;
    vc_3.tableView.frame = CGRectMake(0, 0, kScreenW, self.height-47);
    
    
    return @[vc_1, vc_2, vc_3];
}

- (NSArray *)getArrayTitles
{
    return @[@"发布的话题", @"我的评论", @"我的回复"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
