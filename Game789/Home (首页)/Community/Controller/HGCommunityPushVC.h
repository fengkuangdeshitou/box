//
//  HGCommunityPushVC.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^commentSuccessBack)();

@interface HGCommunityPushVC : BaseViewController

@property (nonatomic, assign) CGFloat currentScore;

@property (nonatomic, copy) commentSuccessBack commentSuccess;

@end
