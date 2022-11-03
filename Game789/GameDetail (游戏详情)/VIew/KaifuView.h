//
//  KaifuView.h
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaifuView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * kaifuArray;
@property (nonatomic, strong) NSDictionary * game_info;

@end
