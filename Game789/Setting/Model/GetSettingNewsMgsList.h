//
//  GetSettingNewsMgsList.h
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface GetSettingNewsMgsList : BaseRequest

@property (nonatomic, copy) NSString * read_tag;

@end


@interface ReceivingGoldCoinsAPI : BaseRequest

@property (nonatomic, copy) NSString * message_params;

@end


@interface GetChatMessageAPI : BaseRequest

@property (nonatomic, copy) NSString * Id;

@end


@interface SendChatMessageAPI : BaseRequest

@property (nonatomic, copy) NSString * taskId;
@property (nonatomic, copy) NSString * toUid;
@property (nonatomic, copy) NSString * content;

@end
