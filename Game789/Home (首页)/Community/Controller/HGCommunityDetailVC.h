//
//  GameCommitMoreViewController.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

@protocol HGCommunityDetailVCDelegate<NSObject>

- (void)communityDetailDidChangeLikeStatus:(Moment *)model;
- (void)communityDetailDidChangeDisLikeStatus:(Moment *)model;

@end

@interface HGCommunityDetailVC : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString * commit_id; //论坛id
@property (nonatomic, copy) NSString * game_name;
@property (nonatomic, weak) id<HGCommunityDetailVCDelegate>delegate;
@property (nonatomic, copy) void(^commentRelateActionRefresh)(void);

@end
