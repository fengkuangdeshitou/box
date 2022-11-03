//
//  CommitDetailHeaderView.h
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface CommitDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *user_icon;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIView *imageViewList;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *readCount;
@property (weak, nonatomic) IBOutlet UIButton *showIntegral;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showContent_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewList_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewList_top;

@property (nonatomic,strong) UIBezierPath *maskPath;

@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) Moment * moment;
@property (nonatomic, assign) CGFloat  view_height;
@property (weak, nonatomic) IBOutlet UIImageView *member_icon;
@property (weak, nonatomic) IBOutlet UIImageView *memberLevelIcon;

@end

