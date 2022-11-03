//
//  MyDownloadVipGameApi.h
//  Game789
//
//  Created by Maiyou on 2019/7/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDownloadVipGameApi : BaseRequest

@property (nonatomic, copy) NSString *gameid;

@end

@interface MyNewDownloadVipGameApi : BaseRequest

@property (nonatomic, copy) NSString *gameid;

@end

NS_ASSUME_NONNULL_END
