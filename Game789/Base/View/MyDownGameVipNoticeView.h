//
//  MyDownGameVipNoticeView.h
//  Game789
//
//  Created by Maiyou on 2019/9/10.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDownGameVipNoticeView : UIView

// 关闭页面
@property (nonatomic, copy) void(^CloseView)();

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

NS_ASSUME_NONNULL_END
