//
//  MyTransferListApi.h
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTransferListApi : BaseRequest

@property (nonatomic, copy) NSString *searchText;

@end

@interface MyTransferDescApi : BaseRequest

@property (nonatomic, copy) NSString *detail_id;

@end

@interface MySubmitTransferApi : BaseRequest

@property (nonatomic, copy) NSDictionary *dataDic;

@end

@interface MyTransferDetailApi : BaseRequest

@property (nonatomic, copy) NSString *detail_id;

@end

@interface MyTransferRecordApi : BaseRequest

@property (nonatomic, copy) NSString *status;

@end

@interface MyTransferDeleteRecordApi : BaseRequest

@property (nonatomic, copy) NSString *detail_id;

@end


NS_ASSUME_NONNULL_END
