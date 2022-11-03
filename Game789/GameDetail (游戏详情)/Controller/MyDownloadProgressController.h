//
//  MyDownloadProgressController.h
//  Game789
//
//  Created by Maiyou001 on 2022/4/28.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDownloadProgressController : UIViewController

// 取消
@property (nonatomic, copy) void(^cancleBtnClick)(void);
@property (nonatomic, assign) BOOL isCancle;

- (instancetype)initWithGameInfo:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
