//
//  PersonalCenterApi.h
//  Game789
//
//  Created by Maiyou on 2018/11/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCenterApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end


@interface GetMyCommentApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end

@interface GetMyReplyApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end

@interface GetPlayedGamesApi : BaseRequest

@property (nonatomic, strong) NSString * user_id;

@end

NS_ASSUME_NONNULL_END
