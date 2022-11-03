//
//  KaiFuApiList.h
//  Game789
//
//  Created by xinpenghui on 2017/9/6.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface KaiFuApiList : BaseRequest

@property (nonatomic, copy) NSString * kf_start_time;
/**  查询哪天的开服游戏，2020-08-26  */
@property (nonatomic, copy) NSString * kaifu_date;

@property (nonatomic, copy) NSString * search_info;
/**  游戏的分类  */
@property (nonatomic, copy) NSString *game_classify_id;

@end
