//
//  MyGetQuestionApi.h
//  Game789
//
//  Created by Maiyou on 2019/3/1.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGetQuestionApi : BaseRequest

@property (nonatomic, copy) NSString * gameId;

@end

NS_ASSUME_NONNULL_END


@interface MyGetAnswerApi : BaseRequest

@property (nonatomic, copy) NSString * questionId;

@end

@interface MyGSubmitQuestionApi : BaseRequest

@property (nonatomic, copy) NSString * gameId;

@property (nonatomic, copy) NSString * question;

@end


@interface MySubmitAnswerApi : BaseRequest

@property (nonatomic, copy) NSString * questionId;

@property (nonatomic, copy) NSString * content;

@end
