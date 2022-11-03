//
//  MyVoucherUseIntroView.h
//  Game789
//
//  Created by Maiyou on 2020/5/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherUseIntroView : BaseView <UITextViewDelegate>

@property (nonatomic, strong) NSDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
