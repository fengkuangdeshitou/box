//
//  MyGetVoucherListApi.h
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

//我的代金券列表
@interface MyGetVoucherListApi : BaseRequest
/**  是否已过期  */
@property (nonatomic, copy) NSString *is_expired;
/**  是否已使用  */
@property (nonatomic, copy) NSString *is_used;

@end


//领取代金券
@interface MyReceiveGameVoucherApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;

@property (nonatomic, copy) NSString *voucher_id;

@end


//可领取代金券列表
@interface MyReceiveVouchersListApi : BaseRequest

@property (nonatomic, copy) NSString *game_id;

@end

NS_ASSUME_NONNULL_END
