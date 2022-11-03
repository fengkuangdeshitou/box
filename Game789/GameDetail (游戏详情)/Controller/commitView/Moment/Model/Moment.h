//
//  Moment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  动态Model
//

#import <Foundation/Foundation.h>

@interface Moment : NSObject

// 显示'全文'/'收起'
@property (nonatomic,assign) BOOL isFullText;
// Moment对应cell高度
@property (nonatomic,assign) CGFloat rowHeight;

/**  评论id  */
@property (nonatomic,copy) NSString *Id;
/**  评论内容  */
@property (nonatomic,copy) NSString *content;
/**  评论时间  */
@property (nonatomic,copy) NSString *time;
/**  0：待审核 1：审核通过 -1：审核失败  */
@property (nonatomic,copy) NSString *status;
/**  评论回复数目  */
@property (nonatomic,copy) NSString *reply_count;
/**  评论喜欢数目  */
@property (nonatomic,copy) NSString *like_count;
/**  是否我喜欢  */
@property (nonatomic,copy) NSString *me_like;
/**  评论者用户id  */
@property (nonatomic,copy) NSString *user_id;
/**  评论者昵称  */
@property (nonatomic,copy) NSString *user_nickname;
/**  评论者等级  */
@property (nonatomic,copy) NSString *user_level;
/**  评论者图像  */
@property (nonatomic,copy) NSString *user_icon;
/**  评论图片列表  */
@property (nonatomic,copy) NSArray *pic_list;
/**  评论奖励金币数  */
@property (nonatomic,copy) NSString *reward_intergral_amount;
/**  阅读数  */
@property (nonatomic,copy) NSString *view_count;
/**  喜欢用户id列表（id,id,id）  */
@property (nonatomic,copy) NSArray *like_user_id_list;
/**  回复列表（默认取三条）  */
@property (nonatomic,copy) NSArray *reply_list;
/**  评论者发布的评论数量  */
@property (nonatomic, copy) NSString * user_comment_count;
/**  机型名称  */
@property (nonatomic, copy) NSString * device_name;
/**  游戏详情  */
@property (nonatomic, strong) NSDictionary * game_info;




/**  评论数目  */
@property (nonatomic,assign) NSInteger commentCount;
/**  评论喜欢数目  */
@property (nonatomic,assign) NSInteger agreeCount;
/**  评论不喜欢数目  */
@property (nonatomic,assign) NSInteger disagreeCount;
/**  喜欢  */
@property (nonatomic,assign) BOOL isAgreed;
/**  不喜欢  */
@property (nonatomic,assign) BOOL isDisagreed;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
