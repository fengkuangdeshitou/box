//
//  MyTaskCellModel.h
//  Game789
//
//  Created by Maiyou on 2020/10/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskCellModel : BaseModel
// 0 新手任务
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * coinNum;
@property (nonatomic, copy) NSString * imageName;
/** 是否完成   */
@property (nonatomic, assign) BOOL status;
/** 是否未领取   */
@property (nonatomic, assign) BOOL taked;
/** 任务的总数   */
@property (nonatomic, copy) NSString * total;
/** 完成的当前进度   */
@property (nonatomic, copy) NSString * progess;
/** 未完成按钮点击提示   */
@property (nonatomic, copy) NSString * tip;
/** 解析的key和领取请求的name   */
@property (nonatomic, copy) NSString * type;
/** 任务添加的金币 */
@property (nonatomic, copy) NSString * balance;
/** 弹窗提示   */
@property (nonatomic, copy) NSString * tips;
/** 按钮提示   */
@property (nonatomic, copy) NSString * btnTitle;
/** 点按钮弹提示的文字  */
@property (nonatomic, copy) NSString * alertMsg;
/** 事件类型 [ jump, msg, exchange]
 jump 是跳转的, 例如设置昵称
 msg  是仅提示的, 例如充值满100奖励
 exchange  是及时兑换类, 例如抖音关注, 微信关注  */
@property (nonatomic, copy) NSString * eventType;

@end

NS_ASSUME_NONNULL_END
