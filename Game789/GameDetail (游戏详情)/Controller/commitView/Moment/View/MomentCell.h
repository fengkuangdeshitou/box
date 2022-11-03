//
//  MomentCell.h
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "Comment.h"
#import "MMOperateMenuView.h"
#import "MMImageListView.h"

typedef void(^HiddenCommitPopView)(BOOL isHidden);

//#### 动态

@protocol MomentCellDelegate;
@interface MomentCell : UITableViewCell <MLLinkLabelDelegate>

// 头像
@property (nonatomic, strong) UIView *backView;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 状态
@property (nonatomic, strong) UIImageView *status_icon;
//金币
@property (nonatomic, strong) UIImageView *coinImageView;
@property (nonatomic, strong) UILabel *coinLab;
// 名称
@property (nonatomic, strong) UIImageView * commentCount;
@property (nonatomic, strong) UILabel *nameLab;
//会员等级
@property (nonatomic, strong) UIImageView * memberLevel;
@property (nonatomic, strong) UIImageView * memberMark;
// 评论数量icon
@property (nonatomic, strong) UIImageView *commentCountIcon;
// 名称
@property (nonatomic, strong) UILabel *showGameType;
// 时间
@property (nonatomic, strong) UILabel *timeLab;
// 设备名称
@property (nonatomic, strong) UILabel *deviceName;
// 点赞数量
@property (nonatomic, strong) MyLikeButton *likeBtn;
@property (nonatomic, strong) UILabel  *likeCount;
// 评论数量
@property (nonatomic, strong) UIImageView *commitBtn;
@property (nonatomic, strong) UILabel  *commitCount;
// 全文
@property (nonatomic, strong) UIButton *showAllBtn;
// 内容
@property (nonatomic, strong) MLLinkLabel *linkLabel;
// 图片
@property (nonatomic, strong) MMImageListView *imageListView;
// 赞和评论视图
@property (nonatomic, strong) UIView *commentView;
// 赞和评论视图背景
@property (nonatomic, strong) UIImageView *bgImageView;
// 操作视图
@property (nonatomic, strong) MMOperateMenuView *menuView;
@property (nonatomic, strong) UILabel  *nameRemark;

// 动态
@property (nonatomic, strong) Moment *moment;
// 代理
@property (nonatomic, assign) id<MomentCellDelegate> delegate;

@property (nonatomic, assign) BOOL  isPersonal;

@property (nonatomic, strong) UIViewController * currentVC;

@property (nonatomic, copy) HiddenCommitPopView hiddenCommitPopView;

@end

@protocol MomentCellDelegate <NSObject>

@optional

// 点击用户头像
- (void)didClickProfile:(MomentCell *)cell;
// 删除
- (void)didDeleteMoment:(MomentCell *)cell;
// 点赞
- (void)didLikeMoment:(MomentCell *)cell;
// 评论
- (void)didAddComment:(MomentCell *)cell;
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell;
// 选择评论
- (void)didSelectComment:(Comment *)comment;
// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText detail:(Comment *)comment;

@end


//#### 评论
@interface CommentLabel : UIView <MLLinkLabelDelegate>

// 内容Label
@property (nonatomic,strong) MLLinkLabel *linkLabel;
// 评论
@property (nonatomic,strong) Comment *comment;
// 点击评论高亮内容
@property (nonatomic, copy) void (^didClickLinkText)(MLLink *link , NSString *linkText, Comment *comment);
// 点击评论
@property (nonatomic, copy) void (^didClickText)(Comment *comment);

@end


