//
//  MyTransferRecordListView.h
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTransferRecordListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger  pageNumber;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) BaseViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
