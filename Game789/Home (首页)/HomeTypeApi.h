//
//  HomeTypeApi.h
//  Game789
//
//  Created by Maiyou on 2018/7/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface HomeTypeApi : BaseRequest

@end

@interface StageABTestApi : BaseRequest

@property (nonatomic, copy) NSString *ab_test_stage;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@end
