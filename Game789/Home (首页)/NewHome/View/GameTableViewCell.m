//
//  GameTableViewCell.m
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameTableViewCell.h"

@interface GameTableViewCell ()

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * logo;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * discountView_width;
@property(nonatomic,weak)IBOutlet UIStackView * stackView;
@property(nonatomic,weak)IBOutlet UIStackView * stackView1;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property(nonatomic,weak)IBOutlet UIView * discountView;
@property(nonatomic,weak)IBOutlet UILabel * discount;
@property(nonatomic,weak)IBOutlet UIView * searchDiscountView;
@property(nonatomic,weak)IBOutlet UILabel * searchDiscount;

@property (weak, nonatomic) IBOutlet UILabel *showTime1;
@property (weak, nonatomic) IBOutlet UILabel *showTime2;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *anthImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authImageView_width;
@property (weak, nonatomic) IBOutlet UILabel *playGames;
@property (weak, nonatomic) IBOutlet UILabel *kaifuTime;

@property (weak, nonatomic) IBOutlet UIImageView *newsGameRank;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankLabel_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankLabel_right;

@property(nonatomic,weak)IBOutlet UILabel * top_lable;
@property(nonatomic,weak)IBOutlet UIView * gradientView;
@property(nonatomic,weak)IBOutlet UIView * sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortView_top;
@property(nonatomic,weak)IBOutlet UILabel * left_content;
@property(nonatomic,weak)IBOutlet UILabel * right_content;
@property(nonatomic,strong)CAGradientLayer * gradientLayer;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@end

@implementation GameTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.newsGameRank.hidden = YES;
    self.rankLabel.hidden = YES;
    self.rankLabel_right.constant = 0;
    self.rankLabel_width.constant = 0;
    self.gradientLayer = [CAGradientLayer layer];
}

- (void)setListType:(NSString *)listType
{
    [super setListType:listType];
    
    if (listType.integerValue == 8)
    {//一周新游top
        self.rankImageView.hidden = NO;
        self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"top_game_rank_%ld", self.indexPath.section + 1]];
    }
    else
    {
        self.rankImageView.hidden = YES;
    }
    
    if (listType.integerValue == 2 || listType.integerValue == 3 || listType.integerValue == 4)
    {//热门榜 新游榜
        self.rankLabel.hidden = NO;
        self.newsGameRank.hidden = self.indexPath.section < 3 ? NO : YES;
        self.rankLabel_right.constant = 8;
        self.rankLabel_width.constant = 15;
    }
    else
    {
        self.rankLabel.hidden = YES;
        self.newsGameRank.hidden = YES;
        self.rankLabel_right.constant = 0;
        self.rankLabel_width.constant = 0;
    }
    
    if (listType.integerValue == 6)
    {//今日首发
        self.timeBackView.hidden = NO;
    }
    
    //view底部加10pt，今日首发有用到
    if (listType.integerValue == 6 || listType.integerValue == 999)
    {
        self.radiusView_bottom.constant = 10;
    }
    else
    {
        self.radiusView_bottom.constant = 0;
    }
    //搜索
    if (listType.integerValue == 7) {
        self.discount_width.constant = 0;
    }else{
        self.discount_width.constant = 53;
    }
}

- (void)setModelDic:(NSDictionary *)dic
{
    dic = [dic deleteAllNullValue];
    
    [super setModelDic:dic];
    
    self.gameModel = [GameModel mj_objectWithKeyValues:dic];
    NSString *url = self.gameModel.game_image[@"thumb"];
    [self.logo yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    if (self.logoImageViewRadius > 0) {
        self.logo.layer.cornerRadius = self.logoImageViewRadius;
    }
    
    for (UILabel * label in self.stackView.subviews) {
        label.text = @"";
    }
    for (int i=0; i<self.gameModel.game_classify_typeArray.count; i++) {
        UILabel * label = [self.stackView viewWithTag:i+10];
        label.text = [NSString stringWithFormat:@"%@",self.gameModel.game_classify_typeArray[i]];
    }
    
    //多少人在玩
    self.playGames.text = [NSString stringWithFormat:@"｜%@人在玩", self.gameModel.howManyPlay];
    
    BOOL isNameRemark = [YYToolModel isBlankString:self.gameModel.nameRemark];
    self.nameRemark.text = !isNameRemark ? [NSString stringWithFormat:@"%@  ", self.gameModel.nameRemark] : @"";
    self.nameRemark.hidden = isNameRemark;
    
    //有描述显示描述，没有显示福利标签
    for (UILabel * label in self.stackView1.subviews) {
        label.text = @"";
    }
    if (self.gameModel.introduction.length > 0) {
        self.desc.text = self.gameModel.introduction;
        self.desc.hidden = NO;
        self.stackView1.hidden = YES;
        NSArray * arr = @[@"#a7d676",@"#ffa95c",@"#ffc000",@"#79b8ff",@"#54C5CD"];
        self.desc.textColor = [UIColor colorWithHexString:arr[arc4random()%arr.count]];
        
    }else{
        self.desc.hidden = YES;
        self.stackView1.hidden = NO;
        NSArray * array = [self.gameModel.game_desc componentsSeparatedByString:@"+"];
        for (int i = 0; i<array.count; i++) {
            UILabel * label = [self.stackView1 viewWithTag:i+20];
            label.text = [NSString stringWithFormat:@"%@",array[i]];
        }
    }
    //是否显示折扣
    CGFloat discount = [self.gameModel.discount floatValue];
    discount = discount * 10;
    if (self.gameModel.listType.intValue == 7) {
        self.discountView_width.constant = 0;
        self.discountView.hidden = true;
        if (self.gameModel.game_species_type.intValue == 2) {
            self.searchDiscount.transform = CGAffineTransformMakeRotation(-M_PI_4);
            if (discount < 10 && discount > 0)
            {
                self.searchDiscount.text = [NSString stringWithFormat:@"%@折", [NSNumber numberWithFloat:discount]];
                self.searchDiscountView.hidden = NO;
            }else if (discount == 10){
                self.searchDiscount.text = @"官方";
                self.searchDiscountView.hidden = NO;
            }else{
                self.searchDiscountView.hidden = YES;
            }
        }else if (self.gameModel.game_species_type.intValue == 3) {
            self.searchDiscount.text = @"H5";
            self.searchDiscountView.hidden = NO;
        }
        else{
            self.searchDiscountView.hidden = YES;
        }
    }else{
        if (self.gameModel.game_species_type.intValue == 2) {
            if (discount < 10 && discount > 0)
            {
                self.discount.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:discount]];
                self.discountView.hidden = NO;
                self.discountView_width.constant = 53;
            }else{
                self.discountView.hidden = YES;
                self.discountView_width.constant = 0;
            }
        }else{
            self.discountView.hidden = YES;
            self.discountView_width.constant = 0;
        }
    }
    //新游首发，今日首发显示时间
    if (self.listType.intValue == 6)
    {
        NSString * startTime = dic[@"start_time"];
        if ([startTime containsString:@":"])
        {
            NSArray * array = [startTime componentsSeparatedByString:@":"];
            self.showTime1.text = array[0];
            self.showTime2.text = array[1];
        }
    }
    
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", self.indexPath.section + 1];
    
    //前三显示图片数字
    if ((self.listType.integerValue == 2 || self.listType.integerValue == 3 || self.listType.integerValue == 4) && self.indexPath.section < 3)
    {
        self.newsGameRank.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_game_rank%ld", self.indexPath.section + 1]];
    }
    
    //搜搜显示正版授权
    BOOL is_ocp = [dic[@"is_ocp"] boolValue];
    if (self.listType.intValue == 7 && is_ocp)
    {
        self.anthImageView.hidden = NO;
    }
    else
    {
        self.anthImageView.hidden = YES;
    }
    //适配开服表专用
    if (self.kaifuType)
    {
        self.playGames.text = [NSString stringWithFormat:@"｜%@", self.gameModel.game_size[@"ios_size"]];
        
        self.stackView1.hidden = YES;
        self.desc.hidden = NO;
        self.desc.text = self.gameModel.kaifu_name;
        self.desc.textColor = [UIColor colorWithHexString:@"#FF5E00"];
        self.kaifuTime.text = self.kaifuType.intValue == 30 ? [NSString stringWithFormat:@" %@ ", [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:self.gameModel.kaifu_start_date.floatValue]] : @"";
    }
    if (self.gameModel.bottom_lable.count > 0) {
        self.left_content.text = [NSString stringWithFormat:@" %@ ",self.gameModel.bottom_lable[@"left_content"]];
        self.right_content.text = self.gameModel.bottom_lable[@"right_content"];
        int type = [self.gameModel.bottom_lable[@"type"] intValue];
        self.left_content.backgroundColor = [UIColor colorWithHexString:type == 1 ? @"#FF8C50" : @"#9F9DFC"];
        self.right_content.textColor = self.left_content.backgroundColor;
        self.sortView.layer.borderWidth = 0.5;
        self.sortView.layer.borderColor = self.left_content.backgroundColor.CGColor;
        self.sortView_height.constant = 16;
        self.sortView_top.constant = 6.5;
    }else{
        self.sortView_height.constant = 0;
        self.sortView_top.constant = 0;
    }
    self.top_lable.text = self.gameModel.top_lable;
    self.gradientView.hidden = self.gameModel.top_lable.length == 0;
    if (self.gameModel.top_lable.length == 0) {
        [self.gradientLayer removeFromSuperlayer];
        self.gamaname.attributedText = nil;
        self.gamaname.text = self.gameModel.game_name;
    }else{
        CGFloat gradientWidth = [self.top_lable.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]} context:nil].size.width+8;
        self.gradientLayer.frame = CGRectMake(0, 0, gradientWidth, 16);
        self.gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#EEBE75"].CGColor,(id)[UIColor colorWithHexString:@"#FFE7BD"].CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
        self.gradientLayer.cornerRadius = 3;
        [self.gradientView.layer insertSublayer:self.gradientLayer atIndex:0];
        NSString * gamaname = dic[@"game_name"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:gamaname];
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = gradientWidth+6;
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(style.firstLineHeadIndent, 14)];
        NSAttributedString * blankImageAtt = [NSAttributedString attributedStringWithAttachment:attachment];
        [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, gamaname.length)];
        [att addAttribute:NSAttachmentAttributeName value:attachment range:NSMakeRange(0, gamaname.length)];
        [att insertAttributedString:blankImageAtt atIndex:0];
        self.gamaname.attributedText = att;
    }
    
    if (self.updateFrameBlock) {
        self.updateFrameBlock(self.gameModel.cellHeight);
    }
}

- (CGFloat)cellHeight{
    return self.gameModel.cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
