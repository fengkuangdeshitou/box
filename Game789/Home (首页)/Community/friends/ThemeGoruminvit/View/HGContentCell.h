//
//  HGContentCell.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGContentCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * contentLabel;
@property (nonatomic,weak) IBOutlet UILabel * moreLabel;

@end

NS_ASSUME_NONNULL_END
