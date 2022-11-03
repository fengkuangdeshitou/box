//
//  MyProjectGameApi.h
//  Game789
//
//  Created by Maiyou on 2018/12/6.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProjectGameApi : BaseRequest

/**  1:BT 2:折扣 3：H5 ，默认不传此参数则为BT游戏  */
@property (nonatomic, copy) NSString * game_species_type;

@end

NS_ASSUME_NONNULL_END
