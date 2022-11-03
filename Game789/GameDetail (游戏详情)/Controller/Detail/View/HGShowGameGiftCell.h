//
//  HGShowGameGiftCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGShowGameGiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCodeView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCodeView_top;
@property (weak, nonatomic) IBOutlet UIView *roundeView;
@property (weak, nonatomic) IBOutlet UIView *giftCodeView;
@property (weak, nonatomic) IBOutlet UIButton *receivedBtn;
@property (weak, nonatomic) IBOutlet UILabel *giftTitle;
@property (weak, nonatomic) IBOutlet UILabel *giftContent;
@property (weak, nonatomic) IBOutlet UILabel *giftCode;
@property (weak, nonatomic) IBOutlet UILabel *periodValidity;
@property (weak, nonatomic) IBOutlet UIImageView *vipGiftImageView;
@property (weak, nonatomic) IBOutlet UILabel *showVipLevel;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) void(^receiveGiftAction)(NSString * giftId);
@property (nonatomic, strong) UIViewController * vc;

@end

NS_ASSUME_NONNULL_END
