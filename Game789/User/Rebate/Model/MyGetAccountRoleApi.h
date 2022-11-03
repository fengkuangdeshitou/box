//
//  MyGetAccountRoleApi.h
//  Game789
//
//  Created by Maiyou on 2020/7/22.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGetAccountRoleApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;

@property (nonatomic, copy) NSString *userName;
@end

NS_ASSUME_NONNULL_END
