//
//  Comment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  评论Model
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

// 正文
//@property (nonatomic,copy) NSString *text;
//// 发布者名字
//@property (nonatomic,copy) NSString *userName;
//// 发布时间戳
//@property (nonatomic,assign) long long time;
//// 关联动态的PK
//@property (nonatomic,assign) int pk;


/**  id  */
@property (nonatomic,copy) NSString * Id;
/**  评论者id  */
@property (nonatomic,copy) NSString * user_id;
/**  评论者昵称  */
@property (nonatomic,copy) NSString * user_nickname;
/**  内容  */
@property (nonatomic,copy) NSString * content;
/**  评论时间  */
@property (nonatomic,copy) NSString * time;
/**  喜欢数  */
@property (nonatomic,copy) NSString * like_count;
/**  是否自己喜欢 0 未喜欢 1 喜欢  */
@property (nonatomic,copy) NSString * me_like;
/**  评论id  */
@property (nonatomic,copy) NSString * comment_id;
/**  回复id  */
@property (nonatomic,copy) NSString * reply_id;
/**  被评论者id  */
@property (nonatomic,copy) NSString * reply_user_id;
/**  被评论者昵称  */
@property (nonatomic,copy) NSString * reply_nickname;
/**  评论者图像  */
@property (nonatomic,copy) NSString * user_logo;
/**  被评论者图像  */
@property (nonatomic,copy) NSString * reply_logo;
/**  0：待审核 1：审核通过 -1：审核失败  */
@property (nonatomic,copy) NSString * status;
/**  评论者发布的评论数量  */
@property (nonatomic, copy) NSString * user_comment_count;
/**  评论者等级  */
@property (nonatomic,copy) NSString *user_level;
/**  机型名称  */
@property (nonatomic, copy) NSString * device_name;

@property (nonatomic, copy) NSString *reward_intergral_amount;
/**  游戏详情  */
@property (nonatomic, strong) NSDictionary * game_info;
/** 评论者图像  */
@property (nonatomic,copy) NSString * user_icon;
/**  回复数量  */
@property (nonatomic, copy) NSString * reply_count;
/**  是否为回复评论的评论  */
@property (nonatomic, assign) BOOL  isReplyComment;
// Moment对应cell高度
@property (nonatomic,assign) CGFloat rowHeight;



/** 用户信息 */
@property (nonatomic, strong) NSDictionary * user;
/** 回复用户信息 */
@property (nonatomic, strong) NSDictionary * replyUser;
/**  是否点赞  */
@property (nonatomic,assign) BOOL isAgreed;
/** 评论数 */
@property (nonatomic, assign) NSInteger agreeCount;
/** 评论数 */
@property (nonatomic, assign) NSInteger agree_count;

@property (nonatomic, assign) NSInteger disagree_count;

@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *nick_name;

@property (nonatomic,copy) NSString *from_content;

@property (nonatomic,copy) NSString *from_nick_name;

@property (nonatomic,copy) NSString *theme_name;

@property (nonatomic,copy) NSString *create_time;

@property (nonatomic,copy) NSString *foruminviteid;

@property (nonatomic,copy) NSString *themeid;

@property (nonatomic,copy) NSString *type;

@property (nonatomic, assign) BOOL  isOpen;
/**  评论评论时间  */
@property (nonatomic,copy) NSString *createtime;

@property (nonatomic, assign) BOOL  isGodCom;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
