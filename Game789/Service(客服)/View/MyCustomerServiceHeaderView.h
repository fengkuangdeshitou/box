//
//  MyCustomerServiceHeaderView.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCustomerServiceHeaderView : BaseView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBgImage_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTitle_top;
@property (weak, nonatomic) IBOutlet UILabel *showQQ;
@property (weak, nonatomic) IBOutlet UILabel *showWx;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UILabel *showOnlineTime;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
