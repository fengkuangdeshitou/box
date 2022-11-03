//
//  GameCommentViewController.h
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameCommentViewController : BaseViewController

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
