//
//  BPPCalendarModel.h
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dateBlock)(NSUInteger,NSUInteger);

@interface BPPCalendarModel : NSObject

@property (nonatomic, assign) NSUInteger index;
/** 上个月遗留天数   */
@property (nonatomic, strong) NSMutableArray *lastDayArray;
/** 当前月天数   */
@property (nonatomic, strong) NSMutableArray *currentDayArray;
/** 下个月补全天数   */
@property (nonatomic, strong) NSMutableArray *nextDayArray;


@property (nonatomic, copy) dateBlock block;

- (NSArray *)setDayArr;

- (NSArray *)nextMonthDataArr;

- (NSArray *)lastMonthDataArr;

@end
