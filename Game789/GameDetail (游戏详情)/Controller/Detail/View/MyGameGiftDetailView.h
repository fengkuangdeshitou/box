//
//  MyGameGiftDetailView.h
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameGiftDetailView : BaseView

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *showGiftName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showGiftContent;
@property (weak, nonatomic) IBOutlet UILabel *showGiftDesc;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (nonatomic, strong) UIViewController * vc;

//领取成功
@property (nonatomic, copy) void(^receivedGiftCodeBlock)(void);

/** 是否可以领取   */
@property (nonatomic, assign) BOOL isReceived;
@property (nonatomic, copy) NSString *gift_id;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
