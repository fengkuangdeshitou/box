//
//  MyBuyVipAlertView.h
//  Game789
//
//  Created by Maiyou001 on 2022/4/8.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBuyVipAlertView : UIView

@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,copy) NSString * supremePayUrl;

@end

NS_ASSUME_NONNULL_END
