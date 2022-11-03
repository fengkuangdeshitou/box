//
//  MyNewGamesSectionView.h
//  Game789
//
//  Created by Maiyou on 2020/4/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNewGamesSectionView : BaseView

@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (nonatomic, strong) UIViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
