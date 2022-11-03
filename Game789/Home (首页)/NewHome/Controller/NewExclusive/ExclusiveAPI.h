//
//  ExclusiveAPI.h
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExclusiveAPI : BaseRequest

@end

@interface ExclusiveReceiveAPI : BaseRequest

@property(nonatomic,copy)NSString * type1;
@property(nonatomic,copy)NSString * pack_ids;


@end



NS_ASSUME_NONNULL_END
