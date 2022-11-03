//
//  GameCommitMoreViewController.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

@interface GameCommitDetailController : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString * commit_id;
@property (nonatomic, copy) NSString * game_name;

@end
