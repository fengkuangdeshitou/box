//
//  MyActivityGuideListView.h
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityGuideListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) BaseViewController * currentVC;

@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSDictionary * gameInfo;

@end

NS_ASSUME_NONNULL_END
