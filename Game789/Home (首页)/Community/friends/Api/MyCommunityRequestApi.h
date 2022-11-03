//
//  MyCommunityRequestApi.h
//  Game789
//
//  Created by Maiyou on 2021/3/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommunityRequestApi : BaseRequest

@property (nonatomic, copy) NSString *themeid;

@end

@interface MyCommunityThemeRequestApi : BaseRequest

@end

@interface MyCommunityAddRequestApi : BaseRequest

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@interface MyCommunityDisagreeApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;

@end

@interface MyCommunityCancleDisagreeApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;

@end

@interface MyCommunityAgreeApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;

@end

@interface MyCommunityCancleAgreeApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;

@end

@interface MyCommunityDetailDataApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;

@end

@interface MyCommunityDetailListApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *sort;

@end

@interface MyCommunityAppraisalApi : BaseRequest

@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *replyid;

@end

@interface MyCommunityAppraisalAgreeApi : BaseRequest

@property (nonatomic, copy) NSString *replyId;

@end

@interface MyCommunityAppraisalCancleAgreeApi : BaseRequest

@property (nonatomic, copy) NSString *replyId;

@end

NS_ASSUME_NONNULL_END
