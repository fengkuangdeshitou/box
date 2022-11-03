//
//  MyGetQuestionModel.h
//  Game789
//
//  Created by Maiyou on 2019/3/1.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGetQuestionModel : NSObject

@property (nonatomic, copy) NSString * game_id;

@property (nonatomic, copy) NSString * question_id;

@property (nonatomic, copy) NSString * ip;
//问题内容
@property (nonatomic, copy) NSString * question;
//回答内容
@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * status;

@property (nonatomic, copy) NSString * time;

@property (nonatomic, copy) NSString * message_time;

@property (nonatomic, copy) NSString * user_icon;

@property (nonatomic, copy) NSString * user_id;

@property (nonatomic, copy) NSString * user_nickname;

@property (nonatomic, copy) NSString * user_level;

@property (nonatomic, copy) NSString * played;

@property (nonatomic, copy) NSDictionary * game_image;

@property (nonatomic, copy) NSString * game_name;

@property (nonatomic, copy) NSString * game_classify_name;

@property (nonatomic, copy) NSString * reward_intergral_amount;

@property (nonatomic,copy) NSString * nameRemark;

@property (nonatomic, strong) NSDictionary * answers;
/**  是否为官方回答（0：否 1：是）  */
@property (nonatomic, strong) NSString * is_official;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
