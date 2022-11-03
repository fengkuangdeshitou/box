//
//  HGGameGiftListController.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGGameGiftListController : BaseViewController

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, copy) NSString *gameId;

@end

NS_ASSUME_NONNULL_END
