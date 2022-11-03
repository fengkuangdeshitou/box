//
//  XKBGRunManager.h
//  Game789
//
//  Created by Maiyou on 2019/2/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKBGRunManager : NSObject

+ (XKBGRunManager *)sharedManager;

/**
 开启后台运行
 */
- (void)startBGRun;

/**
 关闭后台运行
 */
- (void)stopBGRun;

@end

NS_ASSUME_NONNULL_END
