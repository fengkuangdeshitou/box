//
//  MyVoucherCenterSearchView.h
//  Game789
//
//  Created by Maiyou on 2020/7/29.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherCenterSearchView : BaseView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;

// 点击搜索回调
@property (nonatomic, copy) void(^searchTextBlock)(NSString * text);

@end

NS_ASSUME_NONNULL_END
