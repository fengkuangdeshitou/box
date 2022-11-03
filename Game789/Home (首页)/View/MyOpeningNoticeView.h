//
//  MyOpeningNoticeView.h
//  Game789
//
//  Created by Maiyou on 2019/11/9.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOpeningNoticeView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UITextView *showContent;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSDictionary * dataDic;
// 点击回调
@property (nonatomic, copy) void(^ClickActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
