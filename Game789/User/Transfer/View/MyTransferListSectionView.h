//
//  MyTransferListSectionView.h
//  Game789
//
//  Created by Maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTransferListSectionView : BaseView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;

// 点击搜索
@property (nonatomic, copy) void(^searchTextBlock)(NSString *searchText);

@end

NS_ASSUME_NONNULL_END
