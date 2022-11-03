//
//  MyGameDetailIntroBController.h
//  Game789
//
//  Created by Maiyou on 2021/3/18.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameDetailIntroBController : BaseViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary * dataDic;

// 查看当前评论
@property (nonatomic, copy) void(^viewMoreCommentsAction)(void);

@end

NS_ASSUME_NONNULL_END
