//
//  UserPayGoldViewController.h
//  Game789
//
//  Created by Maiyou on 2018/6/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

@interface UserPayGoldViewController : BaseViewController

/**  加载的URL   */
@property (nonatomic, copy) NSString * loadUrl;

/** 是否首页跳转 */
@property (nonatomic, assign) BOOL isHome;
/** 是否通顶显示 */
@property (nonatomic, assign) BOOL isFullScreen;
/**  是否为充值跳转  */
@property (nonatomic, assign) BOOL isRecharge;
/**  是否为会员跳转  */
@property (nonatomic, assign) BOOL isMember;
/**  是否为赎回小号  */
@property (nonatomic, assign) BOOL isRecycle;
/**  赎回小号支付地址  */
@property (nonatomic, copy) NSString *redeemUrl;
/**  是否为月卡跳转   */
@property (nonatomic, assign) BOOL isMonthCard;
/**  是否为新手福利跳转   */
@property (nonatomic, assign) BOOL isWelfare;
/**  是否为新手福利跳转   */
@property (nonatomic, assign) BOOL isNewWelfare;
/**  注册日期30天   */
@property (nonatomic, assign) BOOL reg_gt_30day_url;
/**  交易id   */
@property (nonatomic, copy) NSString * trade_id;

@end
