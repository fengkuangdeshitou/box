//
//  CommentApi.h
//  Game789
//
//  Created by Maiyou on 2018/10/31.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"


@interface CommentApi : BaseRequest

@end


@interface GetCommentDetailApi : BaseRequest

@property (nonatomic, copy) NSString * Id;

@end

@interface GetCommentListApi : BaseRequest

@property (nonatomic, copy) NSString * comment_id;

@end


@interface LikeCommentApi : BaseRequest

@property (nonatomic, copy) NSString * Id;

@end


@interface CommentForCommentApi : BaseRequest

/**  评论id  */
@property (nonatomic, copy) NSString * comment_id;
/**  回复id  */
@property (nonatomic, copy) NSString * reply_id;
/**  内容  */
@property (nonatomic, copy) NSString * content;

@end
