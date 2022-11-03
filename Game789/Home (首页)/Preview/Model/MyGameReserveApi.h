//
//  MyGameReserveApi.h
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameReserveApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;

@property (nonatomic, copy) NSString *reserveType;

@end

@interface MyCancleGameReserveApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;


@end

NS_ASSUME_NONNULL_END
