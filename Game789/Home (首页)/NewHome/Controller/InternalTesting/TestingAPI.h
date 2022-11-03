//
//  TestingAPI.h
//  Game789
//
//  Created by maiyou on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestingAPI : BaseRequest

@property(nonatomic,strong) NSString * Id;

@end

@interface JoinTestingAPI : BaseRequest

@property(nonatomic,strong) NSString * type;
@property(nonatomic,strong) NSString * packid;
@property(nonatomic,strong) NSString * maiyou_gameid;

@end

NS_ASSUME_NONNULL_END
