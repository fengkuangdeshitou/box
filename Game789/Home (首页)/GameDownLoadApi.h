//
//  GameDownLoadApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/23.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface GameDownLoadApi : BaseRequest

@property (strong, nonatomic) NSString *gameId;
@property (strong, nonatomic) NSString *urls;

@end
