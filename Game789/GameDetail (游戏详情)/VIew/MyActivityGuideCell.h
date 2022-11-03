//
//  MyActivityGuideCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityGuideCell : BaseTableViewCell

/** raiders    攻略
 activity    活动 */
@property (nonatomic, copy) NSString * type;

@property (weak, nonatomic) IBOutlet UIView *roundeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *showType;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *showStatusTitle;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
