//
//  MyCommentReplyController.h
//  Game789
//
//  Created by Maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentReplyController : BaseViewController

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, strong) UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
