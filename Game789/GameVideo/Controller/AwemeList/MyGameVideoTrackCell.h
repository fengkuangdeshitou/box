//
//  MyGameVideoTrackCell.h
//  Game789
//
//  Created by Maiyou on 2020/4/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Aweme.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameVideoTrackCell : UICollectionViewCell

@property (nonatomic, strong) Aweme * aweme;

@property (weak, nonatomic) IBOutlet UIImageView *gameVideoIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet UILabel *downloadCount;
@property (weak, nonatomic) IBOutlet UILabel *addTime;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *showContent;

@end

NS_ASSUME_NONNULL_END
