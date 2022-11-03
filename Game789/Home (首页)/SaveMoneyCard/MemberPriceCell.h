//
//  MemberPriceCell.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MemberPriceCellDelegate <NSObject>

- (void)onSelectedGradeId:(NSString *)gradeid;

@end

@interface MemberPriceCell : UITableViewCell

@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,weak)id<MemberPriceCellDelegate>delegate;
@property(nonatomic,weak)IBOutlet UIButton * buyButton;

@end

NS_ASSUME_NONNULL_END
