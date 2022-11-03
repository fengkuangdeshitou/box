//
//  CommentResponse.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "BaseResponse.h"
#import "MyComment.h"

@interface CommentResponse:BaseResponse

@property (nonatomic, strong) MyComment    *data;

@end
