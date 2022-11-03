//
//  HGThemeModel.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGThemeModel : NSObject

@property (nonatomic, copy)   NSString  *dynamicId; //动态Id
@property (nonatomic, strong) NSDictionary *user; //发布动态用户
//@property (nonatomic, assign) DynType type;         //动态类型
@property (nonatomic, copy)   NSString *createtime;//发布时间
@property (nonatomic, copy)   NSString *publishTime;//发布时间
@property (nonatomic, copy)   NSString *content; //动态文本内容
@property (nonatomic, assign) int commentCount;     //评论数
@property (nonatomic, assign) int likeCount;        //点赞数
@property (nonatomic, assign) int agreeCount;        //点赞数
@property (nonatomic, assign) int disagreeCount;   //反对数
@property (nonatomic, assign) BOOL isLike;          //是否喜欢
//@property (nonatomic, assign) VisibleType visible;  //可见性
@property (nonatomic, strong) NSArray <NSURL *>*originalPicUrls; //原图像Url
@property (nonatomic, strong) NSArray <NSURL *>*thumbnailPicUrls;//缩略图Url
//@property (nonatomic, strong) YHWorkGroup *forwardModel;//上一条动态

@property (nonatomic, assign) BOOL isRepost;//转发
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@property (nonatomic, assign) BOOL showDeleteButton;
@property (nonatomic, assign) BOOL hiddenBotLine;//隐藏底部高度15的分隔线


@property (nonatomic, assign) int status;        //状态0：显示 1：不显示
@property (nonatomic, assign) int commentsCell;        //评论cell 0：有，1：没有
@property (nonatomic, strong) NSDictionary *video;//视频地址
@property (nonatomic, strong) NSString *themename;//主题

@property (nonatomic, assign) BOOL isAgreed;          //是否点赞
@property (nonatomic, assign) BOOL isDisagreed;          //是否反对

@property (nonatomic, strong) NSArray * comments;          //神评
@property (nonatomic, strong) NSArray * imgs;
@property (nonatomic, strong) NSString *showContentText;//主题

@end

NS_ASSUME_NONNULL_END
