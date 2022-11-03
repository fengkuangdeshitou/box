//
//  MySubmitRebateFooterView.h
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySubmitRebateFooterView : BaseView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *showCount;

@property (nonatomic, copy) void(^submitRebateAction)(NSString *content);

@end

NS_ASSUME_NONNULL_END
