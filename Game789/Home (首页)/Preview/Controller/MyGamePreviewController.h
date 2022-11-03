//
//  MyGamePreviewController.h
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGamePreviewController : BaseViewController

/**  是否为我的预约  */
@property (nonatomic, assign) BOOL isReserved;
/**  是否从首页预约游戏更多进来  */
@property (nonatomic, assign) BOOL isHomeMore;

@property (nonatomic, strong) UITableView * tableView;
// 修改预约状态
@property (nonatomic, copy) void(^changePreviewStatus)(void);

@end

NS_ASSUME_NONNULL_END
