//
//  MemberInterestsAlertView.h
//  Game789
//
//  Created by maiyou on 2021/9/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberInterestsAlertView : UIView

+ (void)showMemberInterestsAlertViewWithData:(NSDictionary *)data scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
