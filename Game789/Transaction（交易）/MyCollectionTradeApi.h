//
//  MyCollectionTradeApi.h
//  Game789
//
//  Created by Maiyou on 2019/10/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionTradeApi : BaseRequest

@property (nonatomic, copy) NSString *tradeId;

@end

@interface MyCancleCollectionTradeApi : BaseRequest

@property (nonatomic, copy) NSString *tradeId;

@end

NS_ASSUME_NONNULL_END
