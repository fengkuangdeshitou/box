//
//  HGGameDetailIntroController.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGGameDetailIntroController : BaseViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary * dataDic;

// 查看当前评论
@property (nonatomic, copy) void(^viewMoreCommentsAction)(void);

@end

NS_ASSUME_NONNULL_END
