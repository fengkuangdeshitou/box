//
//  MyRecycleRecordsView.h
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "AuthAlertView.h"
#import "AdultAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecycleRecordsView : BaseView

<UITableViewDelegate, UITableViewDataSource, AuthAlertViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BaseViewController * currentVC;

@property (nonatomic, assign) NSInteger  pageNumber;
/**  是否可赎回 */
@property (nonatomic, copy) NSString *isRedeem;
/**  是否已赎回  */
@property (nonatomic, copy) NSString *isRedeemed;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;

@end

NS_ASSUME_NONNULL_END
