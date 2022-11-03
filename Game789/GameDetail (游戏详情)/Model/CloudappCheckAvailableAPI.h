//
//  CloudappCheckAvailableAPI.h
//  Game789
//
//  Created by maiyou on 2021/7/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudappCheckAvailableAPI : BaseRequest

@property (nonatomic,copy) NSString * gameid;
@property (nonatomic,copy) NSString * username;

@end

NS_ASSUME_NONNULL_END
