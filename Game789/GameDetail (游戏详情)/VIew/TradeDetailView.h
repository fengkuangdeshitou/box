//
//  TradeDetailView.h
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeDetailView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tradeArray;

@property (nonatomic, copy) NSString * game_id;
@property (nonatomic, strong) BaseViewController * currentVC;
@property (nonatomic, assign) NSInteger  pageNumber;

- (instancetype)initWithFrame:(CGRect)frame Game_id:(NSString *)game_id;

@end
