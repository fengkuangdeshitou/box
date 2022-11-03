//
//  MyHomeTopFunctionCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeTopFunctionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImage_height;
@property (nonatomic, strong) NSIndexPath * indexPath;

@property (nonatomic, copy) void(^cellBtnBlock)(NSInteger index);
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
