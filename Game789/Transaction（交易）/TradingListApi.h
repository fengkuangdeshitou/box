//
//  TradingListApi.h
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface TradingListApi : BaseRequest

@property (nonatomic, copy) NSString * trade_type;

@property (nonatomic, copy) NSString * game_device_type;

@property (nonatomic, copy) NSString * game_name;

@property (nonatomic, copy) NSString * search_type;

@property (nonatomic, copy) NSString * sort_type;

@property (nonatomic, copy) NSString * buy_member_id;

@property (nonatomic, copy) NSString * game_id;
/**  卖家ID 随便传只要有传就可以,内部已经取了值  */
@property (nonatomic, copy) NSString * member_id;
/**  1：BT 2:折扣 3：H5 4:GM，默认不传取全部  */
@property (nonatomic, copy) NSString * game_species_type;
/**  交易精选  传1为精选 不传或者传0为默认  */
@property (nonatomic, copy) NSString * trade_featured;
/**  最新发布交易 传1为最新 不传或者传0为默认  */
@property (nonatomic, copy) NSString * trade_new_publish;
/**  性价比高 传1为性价比高筛选 不传或者传0为默认  */
@property (nonatomic, copy) NSString * trade_cost_effective;
/**  筛选价格区间  传例如：100-1000（最低-最高）  */
@property (nonatomic, copy) NSString * trade_price_range;
/**  游戏类型id  筛选游戏类型  */
@property (nonatomic, copy) NSString * game_classify_id;

@end
