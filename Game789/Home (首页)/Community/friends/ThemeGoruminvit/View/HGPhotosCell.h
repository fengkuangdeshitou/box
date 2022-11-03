//
//  HGContainerCell.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGPhotosCell : UITableViewCell

@property (nonatomic,strong)NSArray * thumbArray;
@property (nonatomic,strong)NSArray * originalArray;
@property (nonatomic,strong)NSMutableArray * imageArray;

@end

NS_ASSUME_NONNULL_END
