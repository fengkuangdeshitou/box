//
//  MyAllGameVideosApi.h
//  Game789
//
//  Created by yangyongMac on 2020/2/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAllGameVideosApi : BaseRequest

/** 是否加载足迹的数据 */
@property (nonatomic, copy) NSString * isTrack;

@end

NS_ASSUME_NONNULL_END
