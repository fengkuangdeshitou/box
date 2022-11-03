//
//  MyGameHallSortSectionView.h
//  Game789
//
//  Created by Maiyou on 2020/7/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameHallSortSectionView : BaseView

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (strong, nonatomic) UIButton *selectedBtn;

// 点击筛选回调
@property (nonatomic, copy) void(^sortValueChangedAction)(NSString *value);

@end

NS_ASSUME_NONNULL_END
