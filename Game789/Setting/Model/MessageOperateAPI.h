//
//  MessageOperateAPI.h
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageOperateAPI : BaseRequest

@property (nonatomic, copy) NSString * messageType;

@property (nonatomic, copy) NSString * operateType;

@end

NS_ASSUME_NONNULL_END
