//
//  HGShowWelfareCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGShowWelfareCell.h"
#import "MyRebateCenterController.h"
#import <CoreText/CoreText.h>

@implementation HGShowWelfareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
    [self.replyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
    self.replyBtn.hidden = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noticeBtnClick:)];
    [self.autoRebateView addGestureRecognizer:tap];
}

- (void)setIsBoth:(BOOL)isBoth
{
    _isBoth = isBoth;
    
    self.autoRebateView.hidden = !isBoth;
    self.replyBtn.hidden = YES;
    self.rebateText.text = @"双端互通";
}

- (void)setIsRebate:(BOOL)isRebate
{
    _isRebate = isRebate;
    
//    self.replyBtn.hidden = !isRebate;
}

- (void)setIsAutoRebate:(BOOL)isAutoRebate
{
    _isAutoRebate = isAutoRebate;

    self.autoRebateView.hidden = !self.isRebate;
    self.replyBtn.hidden = !isAutoRebate;
    self.rebateText.text = !isAutoRebate ? @"自动返利" : @"手动返利";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)noticeBtnClick:(id)sender
{
    UIViewController * vc = [YYToolModel getCurrentVC];
    NSString * str = @"";
    if (self.isRebate)
    {
        str = !self.isAutoRebate ? @"充值达到返利标准后，无须手动申请，游戏一般为次日0点会自动到账" : @"充值达到返利标准后，需要通过APP手动申请返利，提交审核后24小时内到账";
    }
    else if (self.isBoth)
    {
        str = @"双端互通就是游戏的数据在安卓端和苹果端都能进行角色互通共享的游戏!";
    }
    [vc jxt_showAlertWithTitle:@"温馨提示" message:str appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"我知道了");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

- (IBAction)moreBtnClick:(id)sender
{
    if (self.viewMoreContent)
    {
        self.viewMoreContent();
    }
}

- (IBAction)replyRebateBtnClick:(id)sender
{
    MyRebateCenterController * rebate = [MyRebateCenterController new];
    [[YYToolModel getCurrentVC].navigationController pushViewController:rebate animated:YES];;
}

+ (NSMutableAttributedString *)setTextSpace:(CGFloat)lineSpace Text:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [str length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

+ (CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font
{
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing =  lineSpacing;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGSize attSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL,CGSizeMake(width, CGFLOAT_MAX), NULL);
    CFRelease(frameSetter);
    
    return attSize.height;

}

@end
