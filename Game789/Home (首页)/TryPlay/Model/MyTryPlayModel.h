//
//  MyTryPlayModel.h
//  Game789
//
//  Created by Maiyou on 2021/1/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTryPlayModel : BaseModel

@property (nonatomic, copy) NSString *game_logo;
@property (nonatomic, copy) NSString *game_name;
@property (nonatomic, copy) NSString *require;
@property (nonatomic, copy) NSString *reward;
@property (nonatomic, copy) NSString *validity;
@property (nonatomic, copy) NSString *nameRemark;
@property (nonatomic, assign) NSInteger coin;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, assign) NSInteger gameid;
@property (nonatomic, assign) NSInteger is_complete;
@property (nonatomic, assign) NSInteger is_receive;
@property (nonatomic, assign) NSInteger is_receive_coin;
@property (nonatomic, assign) NSInteger require_id;
@property (nonatomic, assign) NSInteger start_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger surplus;
@property (nonatomic, assign) NSInteger total;

@end

NS_ASSUME_NONNULL_END
