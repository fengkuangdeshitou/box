//
//  HomeSectionSwitchCell.h
//  Game789
//
//  Created by Maiyou on 2018/11/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"


@protocol HomeSectionSwitchCellDelegate <NSObject>

- (void)selectSectionGameType:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HomeSectionSwitchCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView_left;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (nonatomic, copy) NSString * game_classType;
@property (nonatomic, strong) UIButton * selectedButton;

@property (nonatomic, weak) id <HomeSectionSwitchCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
