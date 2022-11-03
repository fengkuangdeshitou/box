//
//  GoldMallModel.h
//  Game789
//
//  Created by maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoldMallModel : NSObject

/// id
@property(nonatomic,copy) NSString * Id;
/// 会员兑换需要的金币
@property(nonatomic,copy) NSString * vipBalance;
/// 非会员兑换需要的金币
@property(nonatomic,copy) NSString * generalBalance;
/// 代金券金额
@property(nonatomic,copy) NSString * amount;
/// 1 领取 0 没领取
@property(nonatomic,copy) NSString * received;
/// 代金券有效期(天)
@property(nonatomic,copy) NSString * days;
/// "全平台BT游戏可用"
@property(nonatomic,copy) NSString * desc;
/// "满减" label 如果为空则 不显示
@property(nonatomic,copy) NSString * label;
/// "满xx可用", 或"直接使用" 接口返回
@property(nonatomic,copy) NSString * useDesc;

@end

NS_ASSUME_NONNULL_END
