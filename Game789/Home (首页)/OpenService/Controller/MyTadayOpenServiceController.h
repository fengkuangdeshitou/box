//
//  MyTadayOpenServiceController.h
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTadayOpenServiceController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
/** 10 今日开服 20 即将开服 30 历史开服 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *game_classify_id;
@property (nonatomic, assign) BOOL isAllLoad;

- (void)kaiFuApiRequest:(RequestData)block Hud:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
