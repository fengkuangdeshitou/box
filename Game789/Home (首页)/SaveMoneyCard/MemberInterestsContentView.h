//
//  MemberInterestsContentView.h
//  Game789
//
//  Created by maiyou on 2021/9/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInterestsModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MemberInterestsContentViewDelegate <NSObject>

- (void)onDismiss;

@end

@interface MemberInterestsContentView : UIView

@property(nonatomic,strong) MemberInterestsModel * model;
@property(nonatomic,weak)id<MemberInterestsContentViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
