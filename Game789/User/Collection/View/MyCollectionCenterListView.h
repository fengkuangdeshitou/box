//
//  MyCollectionCenterListView.h
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionCenterListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BaseViewController * currentVC;

@property (nonatomic, assign) NSInteger  pageNumber;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;

@end

NS_ASSUME_NONNULL_END
