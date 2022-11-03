//
//  MyVoucherListModel.h
//  Game789
//
//  Created by Maiyou on 2020/7/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherListModel : BaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, strong) NSDictionary *except_games;
@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, copy) NSString *game_name;
@property (nonatomic, copy) NSString *game_type;
@property (nonatomic, copy) NSString *game_types;
@property (nonatomic, copy) NSString *is_available;
@property (nonatomic, copy) NSString *is_expired;
@property (nonatomic, copy) NSString *is_used;
@property (nonatomic, copy) NSString *meet_amount;
@property (nonatomic, copy) NSString *received_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *use_type;
@property (nonatomic, copy) NSString *used_time;
@property (nonatomic, copy) NSString *is_received;
@property (nonatomic, copy) NSString *surplus_total;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *vip_grades;
@property (nonatomic, copy) NSString *vip_level;
@property (nonatomic, copy) NSString *vip_level_desc;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
