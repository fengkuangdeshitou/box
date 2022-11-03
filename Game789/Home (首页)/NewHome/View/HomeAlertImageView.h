//
//  HomeAlertImageView.h
//  Game789
//
//  Created by maiyou on 2022/10/18.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeAlertImageView : YYAnimatedImageView

@property(nonatomic,copy)void(^didBlock)(void);

@end

NS_ASSUME_NONNULL_END
