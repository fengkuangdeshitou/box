//
//  MyGameHallTypeView.h
//  Game789
//
//  Created by Maiyou on 2020/9/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGameHallTypeView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn3;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeBtn2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeBtn3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (nonatomic, strong) UIButton * selectedButton;
/**  1 bt 2 折扣 3 h5  */
@property (nonatomic, copy) NSString *gameSpeciesType;

// 类型选择
@property (nonatomic, copy) void(^selectGameTypeBlock)(NSString *type, NSString *title);

- (void)showView;
- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
