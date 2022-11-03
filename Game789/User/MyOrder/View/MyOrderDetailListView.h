//
//  MyOrderDetailListView.h
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "MyOrderDetailSectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDetailListView : BaseView

<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) MyOrderDetailSectionView *sectionView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BaseViewController * currentVC;

@property (nonatomic, assign) NSInteger  pageNumber;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;

@end

NS_ASSUME_NONNULL_END
