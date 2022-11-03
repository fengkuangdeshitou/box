//
//  MyGameDownLoadView.h
//  Game789
//
//  Created by Maiyou on 2019/1/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGameDownLoadView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * cacheDataList;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSMutableArray * selectedArray;
@property (nonatomic, assign) BOOL isEdit;

- (void)reloadDownLoadData;

@end

NS_ASSUME_NONNULL_END
