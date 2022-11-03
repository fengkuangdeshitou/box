//
//  CardMemberHeaderView.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyCardHeaderView : UIView

@property(nonatomic,weak)IBOutlet UIImageView * levelImageView;
@property(nonatomic,weak)IBOutlet UIButton * button;
@property(nonatomic,weak)IBOutlet UILabel * time;
@property(nonatomic,strong)NSDictionary * data;

@end

NS_ASSUME_NONNULL_END
