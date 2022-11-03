//
//  MyPersonalQuestionAndAnswerApi.h
//  Game789
//
//  Created by Maiyou on 2019/3/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPersonalQuestionApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end

NS_ASSUME_NONNULL_END


@interface MyPersonalAnswerApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end
