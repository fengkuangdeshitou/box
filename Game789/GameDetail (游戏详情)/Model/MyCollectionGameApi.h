//
//  MyCollectionGameApi.h
//  Game789
//
//  Created by Maiyou on 2019/10/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionGameApi : BaseRequest

@property (nonatomic, copy) NSString *maiyou_gameid;

@end

@interface MyCancleCollectionGameApi : BaseRequest

@property (nonatomic, copy) NSString *maiyou_gameid;

@end

NS_ASSUME_NONNULL_END
