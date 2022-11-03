//
//  MyShowProjectGameCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyShowProjectGameCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameIcon_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameIcon_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameIcon_width;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *showTag;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showGameType_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showGameType_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTag_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTag_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTag_right;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRemark_top;
/** banner 游戏大厅的精选 home 首页底部的游戏类型 detail 游戏详情底部 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
