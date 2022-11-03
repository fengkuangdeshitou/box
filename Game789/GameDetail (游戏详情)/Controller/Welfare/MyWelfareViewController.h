//
//  MyWelfareViewController.h
//  Game789
//
//  Created by maiyou on 2021/3/10.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyWelfareViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, copy) void(^downloadGameBlock)(void);

@end

NS_ASSUME_NONNULL_END
