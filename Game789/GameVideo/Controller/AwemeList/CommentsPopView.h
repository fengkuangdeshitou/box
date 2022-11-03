//
//  CommentsPopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsPopView:UIView

@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UILabel           *label;
@property (nonatomic, strong) UIImageView       *close;

- (instancetype)initWithAwemeId:(NSDictionary *)dataDic;
- (void)show;
- (void)dismiss;

@end


@class MyComment;
@interface CommentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIImageView        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;

-(void)initData:(MyComment *)comment;
+(CGFloat)cellHeight:(MyComment *)comment;

@end



@protocol CommentTextViewDelegate

@required

-(void)onSendText:(NSString *)text;
-(void)dismissCommentsPopView;

@end


@interface CommentTextView : UIView

@property (nonatomic, strong) UIView                         *container;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) UIButton                       *sendButton;
@property (nonatomic, strong) UIViewController               *currentVC;
@property (nonatomic, strong) id<CommentTextViewDelegate>    delegate;

- (void)show;
- (void)dismiss;

@end
