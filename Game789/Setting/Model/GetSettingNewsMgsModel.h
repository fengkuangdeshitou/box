//
//  GetSettingNewsMgsModel.h
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetSettingNewsMgsModel : NSObject

@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * avatar;

@property (nonatomic, copy) NSString * from_avatar;

@property (nonatomic, copy) NSString * userid;

@property (nonatomic, copy) NSString * nick_name;

@property (nonatomic, copy) NSString * from_nick_name;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * link_route;

@property (nonatomic, copy) NSString * link_value;

@property (nonatomic, copy) NSString * message_id;

@property (nonatomic, copy) NSString * message_mixid;

@property (nonatomic, copy) NSString * message_time;

@property (nonatomic, copy) NSString * read_tag;

@property (nonatomic, copy) NSString * question_id;

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, copy) NSString * question;

@property (nonatomic, copy) NSString * user_nickname;

@property (nonatomic, copy) NSString * user_icon;

@property (nonatomic, copy) NSString * user_level;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * game_name;
/**  0:默认原来的 1：意见反馈 2：接受金币发放  */
@property (nonatomic, copy) NSString * message_type;
/**  message_type为1对应意见反馈ID,message_type为2对应金币发放ID  */
@property (nonatomic, copy) NSString * message_params;


@property (nonatomic, copy) NSString * supremePayUrl;
@property (nonatomic,strong) NSDictionary *vipSignMenu;

@end


@interface MyChatMessageModel : NSObject

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * messageType;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) NSDictionary * gameInfo;
//@property (nonatomic, strong) NSDictionary * info;
@property (nonatomic, copy) NSString * agentAvatar;
@property (nonatomic, copy) NSString * agentName;
@property (nonatomic, copy) NSString * playName;
@property (nonatomic, copy) NSString * playUid;
@property (nonatomic, copy) NSString * taskId;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * userAvatar;

@end
