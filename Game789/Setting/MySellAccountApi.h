//
//  MySellAccountApi.h
//  Game789
//
//  Created by Maiyou on 2020/4/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySellAccountApi : BaseRequest

@property (nonatomic, strong) NSData * imageData;

@property (nonatomic, copy) NSString * uploadType;

@end

NS_ASSUME_NONNULL_END
