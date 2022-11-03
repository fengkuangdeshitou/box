//
//  GetGameHallListApi.h
//  Game789
//
//  Created by Maiyou on 2018/7/26.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface GetGameHallListApi : BaseRequest

@property (nonatomic, strong) NSString *search_info;
/**  游戏类别  */
@property (nonatomic, strong) NSString *game_classify_type;
/**  游戏类型 BT 1 折扣 2 H5 3 GM 4  */
@property (nonatomic, copy) NSString *game_species_type;
/**  def:默认排序,new:最新上架,hot:热门游戏  */
@property (nonatomic, copy) NSString *sortType;

@end
