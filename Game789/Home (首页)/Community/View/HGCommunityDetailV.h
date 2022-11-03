//
//  HGCommunityDetailV.h
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "SJVideoPlayer.h"

@protocol HGCommunityDetailVDelegate<NSObject>

- (void)onLikeChange:(Moment *)model;
- (void)onDisLikeChange:(Moment *)model;

@end

@interface HGCommunityDetailV : UIView

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *user_icon;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIView *imageViewList;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIImageView *userLevel;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCount;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showContent_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewList_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameName_top;

@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSDictionary * momentDic;
@property (nonatomic, assign) CGFloat  view_height;
@property (nonatomic, strong) Moment * moment;

@property (nonatomic, assign) BOOL isDesc;
@property (nonatomic, weak) id<HGCommunityDetailVDelegate>delegate;
@property (nonatomic, copy) void(^selectSortAction)(BOOL isDesc);
@property (nonatomic, strong) SJVideoPlayer *player;

@end

