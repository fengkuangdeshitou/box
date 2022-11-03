//
//  MyGMGameListView.h
//  Game789
//
//  Created by Maiyou on 2019/5/29.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGMGameListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL isLoadData;

- (instancetype)initWithFrame:(CGRect)frame Tag:(NSInteger)tag;

- (void)listRequest;

@end

NS_ASSUME_NONNULL_END
