//
//  MyGameHallListView.h
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameHallListView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * typeTableView;
@property (nonatomic, strong) NSIndexPath * typeSelectedIndex;
/**  分页页数  */
@property (nonatomic, assign) NSInteger  pageNumber;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;
/**  游戏类型 BT 1 折扣 2 H5 3 GM 4  */
@property (nonatomic, copy) NSString * game_species_type;
/** 游戏类别的id */
@property (nonatomic, copy) NSString *typeId;
/**  游戏类型数组  */
@property (nonatomic, strong) NSArray * typeArray;
/**  游戏列表  */
@property (nonatomic, strong) NSMutableArray * dataArray;
/**  精选游戏列表  */
@property (nonatomic, strong) NSArray * commendArray;
/**  精选banner列表  */
@property (nonatomic, strong) NSArray * bannerArray;
/** 搜索的信息 */
@property (nonatomic, copy) NSString *searchInfo;
/** 1:热门推荐；2：排行榜；3：新游榜; */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) BaseViewController * currentVC;
//获取游戏列表
- (void)gameTypeRequestList:(RequestData)block Hud:(BOOL)isShow;
- (void)gameMallParmasData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
