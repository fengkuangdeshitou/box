//
//  MyCustomServiceCell.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCustomServiceCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dottedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showQuestion_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showQuestion_bottom;
/** 是否显示具体内容 */
@property (nonatomic, assign) BOOL isShowContent;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, copy) void(^moreBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
