//
//  MyVoucherListView.h
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BaseViewController * currentVC;

@property (nonatomic, assign) NSInteger  pageNumber;
/**  是否已过期  */
@property (nonatomic, copy) NSString *is_expired;
/**  是否已使用  */
@property (nonatomic, copy) NSString *is_used;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;

@end

NS_ASSUME_NONNULL_END
