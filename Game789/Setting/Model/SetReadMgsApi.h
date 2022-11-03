//
//  SetReadMgsApi.h
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface SetReadMgsApi : BaseRequest

@property (nonatomic, copy) NSString * message_id;
/**  1:设置已读 2：删除消息  */
@property (nonatomic, copy) NSString * operate_type;


@end
