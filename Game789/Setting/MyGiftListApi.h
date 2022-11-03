//
//  GiftListApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/6.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface MyGiftListApi : BaseRequest
@property (nonatomic, strong) NSString *search_info;
@property (nonatomic, strong) NSString *game_classify_type;
@end
