//
//  CommitReplyView.h
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommentSuccess) (NSString * _Nullable content);

NS_ASSUME_NONNULL_BEGIN

@interface CommitReplyView : UIView <UITextViewDelegate>

@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UITextView *enterText;
@property (weak, nonatomic) UIButton *sendMessage;

@property(nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat  tabHeight;

@property (nonatomic, copy) NSString * comment_id;
@property (nonatomic, copy) NSString * reply_id;
@property (nonatomic, copy) NSString * reply_placeHolder;
@property (nonatomic, copy) CommentSuccess commentSuccess;

/** 判断是否为社区回复评论  */
@property (nonatomic, assign) BOOL isCommunity;

@end

NS_ASSUME_NONNULL_END
