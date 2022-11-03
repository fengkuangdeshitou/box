//
//  MySubmitRebateNotice.h
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySubmitRebateNoticeView : BaseView

@property (nonatomic, copy) NSString * showContent;
@property (nonatomic, copy) void(^submitRebateAction)(NSString *content);

@end

NS_ASSUME_NONNULL_END
