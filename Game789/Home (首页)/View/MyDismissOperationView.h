//
//  MyDismissOperationView.h
//  Game789
//
//  Created by Maiyou on 2020/4/7.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDismissOperationView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
