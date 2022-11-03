//
//  GameCommentAPI.h
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameCommentAPI : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@property (nonatomic, strong) NSString * type;

@end

NS_ASSUME_NONNULL_END
