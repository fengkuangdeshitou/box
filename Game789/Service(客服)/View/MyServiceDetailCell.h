//
//  MyServiceDetailCell.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyServiceDetailCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitle;

@property (weak, nonatomic) IBOutlet UILabel *showContent;

@end

NS_ASSUME_NONNULL_END
