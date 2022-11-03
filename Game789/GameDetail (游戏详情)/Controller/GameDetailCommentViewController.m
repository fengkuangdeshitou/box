//
//  GameDetailCommentViewController.m
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameDetailCommentViewController.h"

@interface GameDetailCommentViewController ()

@end

@implementation GameDetailCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CommitDetailView * commitView = [[CommitDetailView alloc] initWithFrame:self.view.bounds TopicId:self.dataDic[@"comment_topic_id"]];
    commitView.currentVC = self;
    commitView.dataDic = self.dataDic;
    commitView.isShowQuestion = YES;
    commitView.game_name = self.dataDic[@"game_info"][@"game_name"];
    commitView.isFooterHidden = YES;
    commitView.commitData = ^(NSArray *commentList, NSString *commitTotal) {
        
    };
    [self.view addSubview:commitView];
    self.commitView = commitView;
}

@end
