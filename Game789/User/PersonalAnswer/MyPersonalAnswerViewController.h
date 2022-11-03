//
//  MyPersonalAnswerViewController.h
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPersonalAnswerViewController : BaseViewController

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, strong) UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
