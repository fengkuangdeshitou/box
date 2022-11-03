//
//  HGCommunicityTopicV.h
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopicBlock)(NSString * _Nullable name, NSString * _Nullable titleId);

NS_ASSUME_NONNULL_BEGIN

@interface HGCommunicityTopicV : UIView
@property (nonatomic, copy)TopicBlock topicBlock;
@end

NS_ASSUME_NONNULL_END
