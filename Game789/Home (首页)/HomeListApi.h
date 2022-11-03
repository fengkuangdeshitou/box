//
//  HomeListApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/5.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface HomeListApi : BaseRequest
@property (nonatomic, assign) BOOL  stautsNav;
@property (nonatomic, strong) NSString *search_info;
@property (nonatomic, strong) NSString *game_classify_type;
@property (nonatomic, assign) BOOL isSearch;

@end

@interface SearchApi : BaseRequest
@property (nonatomic, strong) NSString *search_info;
@property (nonatomic, strong) NSString *game_species_type;
@property (nonatomic, assign) BOOL isSearch;

@end
