//
//  MyTryPlayApi.h
//  Game789
//
//  Created by Maiyou on 2021/1/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTryPlayApi : BaseRequest

@end

//领取任务
@interface MyReceiveTaskApi : BaseRequest

@property (nonatomic, copy) NSString *taskId;

@end

//领取金币
@interface MyReceiveCoinsApi : BaseRequest

@property (nonatomic, copy) NSString *taskId;

@end

NS_ASSUME_NONNULL_END
