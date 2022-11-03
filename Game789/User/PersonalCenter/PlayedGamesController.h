//
//  PlayedGamesController.h
//  Game789
//
//  Created by Maiyou on 2018/11/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayedGamesController : BaseViewController

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, strong) UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
