//
//  MyUserReturnApi.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/2.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnApi : BaseRequest

@end

@interface MyUserReturnReceiveGiftApi : BaseRequest

@property (nonatomic,assign) NSInteger day;
@property (nonatomic,copy) NSString * pack_ids;

@end

NS_ASSUME_NONNULL_END
