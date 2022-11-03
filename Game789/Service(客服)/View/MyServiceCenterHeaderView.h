//
//  MyServiceCenterHeaderView.h
//  Game789
//
//  Created by Maiyou001 on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyServiceCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UILabel *showPublishWx;
@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
