//
//  GroupChatListRequest.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "MyBaseRequest.h"

@interface GroupChatListRequest:MyBaseRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end
