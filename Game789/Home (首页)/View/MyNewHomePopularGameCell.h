//
//  MyNewHomePopularGameCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNewHomePopularGameCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameType;

@end

NS_ASSUME_NONNULL_END
