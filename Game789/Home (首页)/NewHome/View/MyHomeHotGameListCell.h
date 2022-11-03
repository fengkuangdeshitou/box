//
//  MyHomeHotGameListCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMZBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeHotGameListCell : UICollectionViewCell

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * indexArray;
@property (nonatomic, strong) WMZBannerParam *param;
@property (nonatomic, strong) WMZBannerView * bannerView;

@end

NS_ASSUME_NONNULL_END
