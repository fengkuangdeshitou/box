//
//  WelfareCentreUserInfoHeaderView.h
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelfareCentreUserInfoHeaderView : UICollectionReusableView

@property(nonatomic,strong) NSDictionary * data;
@property(nonatomic,weak)IBOutlet UIButton * sign;

@end

NS_ASSUME_NONNULL_END
