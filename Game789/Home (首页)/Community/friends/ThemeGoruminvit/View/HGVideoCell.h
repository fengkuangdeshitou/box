//
//  HGVideoCell.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPlayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGVideoCell : UITableViewCell

@property(nonatomic,strong)SJPlayView * videoView;
@property(nonatomic,strong)NSDictionary * video;

@end

NS_ASSUME_NONNULL_END
