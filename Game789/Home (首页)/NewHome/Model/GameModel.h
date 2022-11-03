//
//  GameModel.h
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameModel : NSObject

@property(nonatomic,strong) NSDictionary * game_image;
@property(nonatomic,copy) NSString * game_name;
@property(nonatomic,copy) NSString * maiyou_gameid;
@property(nonatomic,copy) NSString * game_id;
@property(nonatomic,copy) NSString * game_classify_type;
@property(nonatomic,copy) NSString * introduction;
@property(nonatomic,copy) NSString * game_desc;
@property(nonatomic,copy) NSString * game_species_type;
@property(nonatomic,copy) NSString * discount;
@property(nonatomic,copy) NSString * howManyPlay;
@property(nonatomic,copy) NSString * kaifu_id;
@property(nonatomic,copy) NSString * kaifu_name;
@property(nonatomic,copy) NSString * kaifu_start_date;
@property(nonatomic,copy) NSString * fuli_desc;
@property(nonatomic,copy) NSString * is_ocp;
@property(nonatomic,copy) NSString * listType;
@property(nonatomic,strong) NSArray * game_classify_typeArray;
@property(nonatomic,strong) NSDictionary * game_size;
@property(nonatomic,copy) NSString * top_lable;
@property(nonatomic,strong) NSDictionary * bottom_lable;
@property(nonatomic,copy) NSString * bate_test_total;
@property(nonatomic,copy) NSString * nameRemark;
@property(nonatomic,assign)BOOL bate_has_joined;
@property(nonatomic,strong) NSArray * bate_list;
/// 默认高度
@property(nonatomic,assign) CGFloat cellHeight;
/// 游戏大厅
@property(nonatomic,assign) CGFloat hallCellHeight;
/// 排行榜
@property(nonatomic,assign) CGFloat rankingCellHeight;

@end

NS_ASSUME_NONNULL_END
