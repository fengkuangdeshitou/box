//
//  HGShowGameContentCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGShowGameContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong) CAShapeLayer *maskLayer;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *autoRebateView;
@property (weak, nonatomic) IBOutlet UILabel *rebateText;/** 是否为双端互通 */
@property (nonatomic, assign) BOOL isBoth;
// 查看更多的内容
@property (nonatomic, copy) void(^viewMoreContent)(void);

@end

NS_ASSUME_NONNULL_END
