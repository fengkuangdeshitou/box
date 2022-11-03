//
//  MyMoreTransactionView.h
//  Game789
//
//  Created by Maiyou on 2019/2/28.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMoreTransactionView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView * topLineView;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
