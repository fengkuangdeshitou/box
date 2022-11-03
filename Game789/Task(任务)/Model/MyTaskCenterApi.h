//
//  MyTaskCenterApi.h
//  Game789
//
//  Created by Maiyou on 2020/10/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskCenterApi : BaseRequest

@end

@interface MyTaskCenterSignedApi : BaseRequest

@end

@interface MyTaskExchangeApi : BaseRequest

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *type;

@end

@interface MyGetTaskProgressApi : BaseRequest

@end

@interface MyFinishTaskGetCoinsApi : BaseRequest

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *novice;

@end

@interface NoviceDataAPI : BaseRequest

@end

@interface WelfareDataAPI : BaseRequest

@end

NS_ASSUME_NONNULL_END
