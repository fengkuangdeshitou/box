//
//  PostCommentRequest.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "MyBaseRequest.h"

@interface PostCommentRequest:MyBaseRequest

@property (nonatomic, copy) NSString   *aweme_id;
@property (nonatomic, copy) NSString   *udid;
@property (nonatomic, copy) NSString   *text;

@end
