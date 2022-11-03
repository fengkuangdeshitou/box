//
//  GameCommitMoreController.m
//  Game789
//
//  Created by Maiyou on 2018/10/26.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameCommitMoreController.h"
#import "CommitDetailView.h"

@interface GameCommitMoreController ()

@end

@implementation GameCommitMoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = self.game_name;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CommitDetailView * commitView = [[CommitDetailView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - hxBottomMargin) TopicId:self.topicId];
    commitView.currentVC = self;
    commitView.isFooterHidden = YES;
    commitView.game_name = self.game_name.length > 0 ? self.game_name : @"评论详情".localized;
    commitView.commitData = ^(NSArray *commentList, NSString *commitTotal) {
        
    };
    [self.view addSubview:commitView];
}


@end
