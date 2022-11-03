//
//  GameDetailApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/11.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface GameDetailApi : BaseRequest

@property (copy, nonatomic) NSString *gameId;
@property (nonatomic, copy) NSString *maiyou_gameid;

@end

@interface GetGameGiftApi : BaseRequest

@property (copy, nonatomic) NSString *gameId;

@end

@interface GetGameVoucherListApi : BaseRequest

@property (copy, nonatomic) NSString *gameId;

@end
