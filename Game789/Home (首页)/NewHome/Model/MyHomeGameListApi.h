//
//  MyHomeGameListApi.h
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeGameListApi : BaseRequest

@end

@interface MyGetAllVouchersApi : BaseRequest

@property (nonatomic, copy) NSString *text;

@end

@interface MyGetRecentGameVouchersApi : BaseRequest

@end

@interface MyGetSelectLikeTypeApi : BaseRequest

@end


@interface MySaveLikeTypeApi : BaseRequest

@property (nonatomic, copy) NSString *tags;

@end

@interface MyGetProjectGameApi : BaseRequest

@property (nonatomic, copy) NSString *project_id;

@end

@interface MyPromotionActivationApi : BaseRequest

@end

@interface TKApi : BaseRequest

@end


NS_ASSUME_NONNULL_END
