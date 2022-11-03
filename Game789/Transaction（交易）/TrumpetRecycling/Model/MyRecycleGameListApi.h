//
//  MyRecycleGameListApi.h
//  Game789
//
//  Created by yangyongMac on 2020/2/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecycleGameListApi : BaseRequest

@end

@interface MyRecycleGameAllXhApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;

@end

@interface MyRecycleXhApi : BaseRequest

/** 多个用逗号隔开 */
@property (nonatomic, copy) NSString * ids;

@end

@interface MyRecycleRecordsApi : BaseRequest

/** 是否可赎回 */
@property (nonatomic, copy) NSString * isRedeem;
/** 是否已赎回 */
@property (nonatomic, copy) NSString * isRedeemed;

@end

@interface MyTrumpetRedemptionApi : BaseRequest

/** 手机号 */
@property (nonatomic, copy) NSString * mobile;
/** 验证码 */
@property (nonatomic, copy) NSString * code;

@end

NS_ASSUME_NONNULL_END
