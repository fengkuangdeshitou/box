//
//  MyGamePreviewCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGamePreviewCell : BaseTableViewCell < UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *reservedCount;
@property (weak, nonatomic) IBOutlet UILabel *reservedLabel;
@property (weak, nonatomic) IBOutlet UILabel *startingTime;
@property (weak, nonatomic) IBOutlet UIImageView *startingBgImg;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,weak)IBOutlet UIStackView * stackView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, copy) NSString * video_url;
@property (nonatomic, strong) NSArray * urlArray;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSMutableArray * imageArray;
/**  是否可以预约  */
@property (nonatomic, assign) BOOL isReservedSucess;

@property (nonatomic, copy) void(^PreviewGameAction)(BOOL isReserved);

@end

NS_ASSUME_NONNULL_END
