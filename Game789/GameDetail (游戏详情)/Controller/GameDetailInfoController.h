//
//  GameDetailInfoController.h
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PreviewGameAction)(BOOL isReserved);

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailInfoController : BaseViewController

@property (nonatomic, copy) NSString * gameID;
@property (nonatomic, copy) NSString * maiyou_gameid;
/**  是否为预约  */
@property (nonatomic, assign) BOOL isReserve;
/**  是否为领券中心  */
@property (nonatomic, assign) BOOL isVoucherCenter;

@property (nonatomic, copy) PreviewGameAction previewAction;
// 1 直接下载
@property (nonatomic, copy) NSString * c;
// 是否显示活动弹框
@property (nonatomic, assign) BOOL isShowActivityAlert;
// 活动id
@property (nonatomic, copy) NSString * newid;

@end

NS_ASSUME_NONNULL_END
