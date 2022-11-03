//
//  CardMemberViewController.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMemberViewController : BaseViewController

@property(nonatomic,strong)NSDictionary * data;
@property(nonatomic,strong)UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
