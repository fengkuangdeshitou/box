//
//  MyPopularityListCollectionCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/14.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPopularityListCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSDictionary * dataDic;


@end

NS_ASSUME_NONNULL_END
