//
//  HGShowGameContentCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGShowGameContentCell.h"

@implementation HGShowGameContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeBtnClick:)];
    [self.autoRebateView addGestureRecognizer:tap];
}

- (void)layoutSubviews
{
    self.backView.layer.mask = self.maskLayer;
}

- (void)setIsBoth:(BOOL)isBoth
{
    _isBoth = isBoth;
    
    self.autoRebateView.hidden = !isBoth;
    self.replyBtn.hidden = !isBoth;
    self.rebateText.text = @"双端互通";
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer)
    {
        _maskLayer = [[CAShapeLayer alloc] init];
    }
    
    CGRect oldRect = self.backView.bounds;
    oldRect.size.width = [UIScreen mainScreen].bounds.size.width - 30;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    _maskLayer.path = maskPath.CGPath;
    _maskLayer.frame = oldRect;
    
    return _maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreBtnClick:(id)sender
{
    if (self.viewMoreContent)
    {
        self.viewMoreContent();
    }
}

- (IBAction)noticeBtnClick:(id)sender
{
    UIViewController * vc = [YYToolModel getCurrentVC];
    [vc jxt_showAlertWithTitle:@"温馨提示" message:@"双端互通就是游戏的数据在安卓端和苹果端都能进行角色互通共享的游戏!" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"我知道了");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

@end
