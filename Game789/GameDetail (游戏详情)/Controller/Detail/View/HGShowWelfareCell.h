//
//  HGShowWelfareCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGShowWelfareCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *autoRebateView;
@property (weak, nonatomic) IBOutlet UILabel *rebateText;
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 是否为双端互通 */
@property (nonatomic, assign) BOOL isBoth;
/** 是否为返利的展示 */
@property (nonatomic, assign) BOOL isRebate;
/** 是否为自动返利 */
@property (nonatomic, assign) BOOL isAutoRebate;
// 查看更多的内容
@property (nonatomic, copy) void(^viewMoreContent)(void);

+ (NSMutableAttributedString *)setTextSpace:(CGFloat)lineSpace Text:(NSString *)str;

+ (CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                       withFont:(CGFloat)font;

@end

NS_ASSUME_NONNULL_END
