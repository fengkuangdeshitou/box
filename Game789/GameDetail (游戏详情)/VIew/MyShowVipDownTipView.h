//
//  MyShowVipDownTipView.h
//  Game789
//
//  Created by Maiyou001 on 2021/6/10.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyShowVipDownTipView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgaeView_width;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, assign) BOOL isUserVip;
@property (nonatomic, assign) BOOL isBindUdid;
@property (nonatomic, copy) NSString * supremePayUrl;
@property (nonatomic, copy) void(^vipAppInstallBlock)(void);

@end

NS_ASSUME_NONNULL_END
