//
//  HomeProjectDescCell.h
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeProjectDescCell : UITableViewCell

@property(nonatomic,strong) GameTableViewCell * gameCell;
@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property(nonatomic,strong) NSDictionary * data;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * radiusTop;

@end

NS_ASSUME_NONNULL_END
