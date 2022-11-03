//
//  MyTryPlayListCell.h
//  Game789
//
//  Created by Maiyou on 2020/12/31.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZZCircleProgress.h"
#import "MyTryPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTryPlayListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showCoin;
@property (weak, nonatomic) IBOutlet UILabel *showTask;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (strong, nonatomic) ZZCircleProgress *progressView;
@property (nonatomic, strong) MyTryPlayModel *dataModel;

// 领取任务或者金币成功回调
@property (nonatomic, copy) void(^receivedActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
