//
//  GuidePageMaskView.h
//  Game789
//
//  Created by Maiyou on 2018/12/1.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseView.h"

typedef void (^PageMaskViewClick)();

NS_ASSUME_NONNULL_BEGIN

@interface GuidePageMaskView : BaseView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_bottom;
/**  底部  */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**  箭头  */
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
/**  文字描述  */
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, copy) PageMaskViewClick clickBlock;

@end

NS_ASSUME_NONNULL_END
