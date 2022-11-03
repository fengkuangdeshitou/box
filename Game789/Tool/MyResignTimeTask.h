//
//  MyResignTimeTask.h
//  Game789
//
//  Created by Maiyou on 2019/9/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyResignTimeTaskDelegate <NSObject>

@optional // 可选实现的方法

- (void)resignTimingWithDownIpa:(CGFloat)progress;

@end

@interface MyResignTimeTask : NSObject

@property(nonatomic, weak) id <MyResignTimeTaskDelegate> delegate;

@property (nonatomic, strong) NSTimer * resginTimer;
/** 个人签名所需要的时间 */
@property (nonatomic, assign) CGFloat resginCount;
@property (nonatomic, assign) CGFloat resginProgress;
/** maiyou_gameid */
@property (nonatomic, copy) NSString * maiyou_gameid;
/** 下载当前游戏所需要的信息 */
@property (nonatomic, strong) NSDictionary * dataDic;
/** 下载当前游戏的下载地址 */
@property (nonatomic, copy) NSString * url;
/** 是否正在签名 */
@property (nonatomic, assign) BOOL isResign;
/** 签名显示不同的状态 */
@property (nonatomic, copy) NSString * statusTitle;

+ (MyResignTimeTask *)sharedManager;

//开始
- (void)timingStart;

//暂停
- (void)timingPause;

@end

NS_ASSUME_NONNULL_END
