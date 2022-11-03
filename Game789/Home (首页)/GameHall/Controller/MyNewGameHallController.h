//
//  MyNewGameHallController.h
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "MyGameHallListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNewGameHallController : BaseViewController

/** 1:热门推荐；2：排行榜；3：新游榜; */
@property (nonatomic, copy) NSString *type;
/**  游戏类型 BT 1 折扣 2 H5 3 GM 4  */
@property (nonatomic, copy) NSString * game_species_type;
/**  游戏类别id  */
@property (nonatomic, copy) NSString *typeId;

@property (nonatomic, strong) MyGameHallListView * hallListView1;

@end

NS_ASSUME_NONNULL_END
