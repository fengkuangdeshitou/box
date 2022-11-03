//
//  HGThemeHeaderCell.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGThemeHeaderCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView * avatarImageView;
@property (nonatomic,weak) IBOutlet UILabel * nickNameLabel;
@property (nonatomic,weak) IBOutlet UILabel * timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
