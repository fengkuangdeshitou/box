//
//  MyComplaintFeedbackView.h
//  Game789
//
//  Created by Maiyou on 2020/4/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyComplaintFeedbackView : BaseView <HXPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerView_height;
@property (weak, nonatomic) IBOutlet UITextField *complaintUser;
@property (weak, nonatomic) IBOutlet UITextField *complaintMobile;
@property (weak, nonatomic) IBOutlet UITextField *complaintName;
@property (weak, nonatomic) IBOutlet UITextField *complaintQQ;
@property (weak, nonatomic) IBOutlet UITextField *complaintContent;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, strong) NSMutableArray * imagesArray;
@property (nonatomic, strong) UIViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
