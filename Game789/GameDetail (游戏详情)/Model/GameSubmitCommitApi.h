//
//  GameSubmitCommitApi.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface GameSubmitCommitApi : BaseRequest

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *topic_id;

@end
