//
//  SmallAccountApi.h
//  Game789
//
//  Created by Maiyou on 2018/8/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface SmallAccountApi : BaseRequest

@property (nonatomic, copy) NSString * game_id;
@property (nonatomic, copy) NSString * maiyou_gameid;

@property (nonatomic, copy) NSString * member_id;

@end
