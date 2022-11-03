//
//  MyGetAllGamesApi.h
//  Game789
//
//  Created by yangyongMac on 2020/2/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGetAllGamesApi : BaseRequest

@property (nonatomic, copy) NSString * gameName;

@end

NS_ASSUME_NONNULL_END
