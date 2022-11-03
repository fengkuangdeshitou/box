//
//  ExclusiveContentViewController.h
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExclusiveContentViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,strong)NSDictionary * model;

@end

NS_ASSUME_NONNULL_END
