//
//  MyGameFeedbackView.h
//  Game789
//
//  Created by Maiyou on 2020/4/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "HXPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameFeedbackView : BaseView <HXPhotoViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceModel;
@property (weak, nonatomic) IBOutlet UITextField *enterGameName;
@property (weak, nonatomic) IBOutlet UITextField *enterQQ;
@property (weak, nonatomic) IBOutlet UITextField *enterMobile;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerView_height;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) NSString * gameName;
@property (nonatomic, strong) NSString * game_id;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) NSMutableArray *typesArray;
@property (nonatomic, strong) UIViewController * currentVC;


@end

NS_ASSUME_NONNULL_END
