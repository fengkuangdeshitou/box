//
//  MyHomeGameListController.h
//  Game789
//
//  Created by Maiyou on 2020/7/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeGameListController : BaseViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView *topBackView;

- (void)homeViewOpen;

@end

NS_ASSUME_NONNULL_END
