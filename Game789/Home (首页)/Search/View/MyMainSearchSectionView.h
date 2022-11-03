//
//  MyMainSearchSectionView.h
//  Game789
//
//  Created by Maiyou on 2020/12/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMainSearchSectionView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTitle_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTitle_top;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

// 删除按钮点击事件
@property (nonatomic, copy) void(^deleteTagsBlock)(void);

@end

NS_ASSUME_NONNULL_END
