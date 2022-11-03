//
//  HomeNoticeTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "HomeNoticeTableViewCell.h"

@interface HomeNoticeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *retArray;

@property (assign,nonatomic) NSInteger tmpIndex;

@property (weak, nonatomic) IBOutlet UILabel *check;
/**  标题 有就显示没有显示 ‘活动合集’  */
@property (weak, nonatomic) IBOutlet UILabel *notice_title;
/**  标题 有就显示没有显示 ‘独家活动’  */
@property (weak, nonatomic) IBOutlet UILabel *notice_detail;

@end

@implementation HomeNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.index = 0;
    self.tmpIndex = 0;
    // Initialization code
        
    self.check.layer.masksToBounds = YES;
    self.check.layer.cornerRadius = 10;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {
//    self.iconImage.image = [UIImage imageNamed:dic[@"image"]];
    self.titleLabel.text = dic[@"title"];
}

- (void)setContentArray:(NSArray *)array {
    self.retArray = array;
    [self startNoticeChange];
}

- (void)startNoticeChange {
    if ([self.timer isValid] == YES) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)theTimer {
    if (self.retArray.count > 0 && self.tmpIndex < self.retArray.count) {
        NSDictionary *dic = [self.retArray objectAtIndex:self.tmpIndex];
        self.titleLabel.text = dic[@"news_title"];
        self.index = self.tmpIndex;
        //当前字段显示是否有值，有则显示没有固定字符串
        (![dic[@"act_title"] isBlankString]) ? (self.notice_title.text = @"act_title") : (self.notice_title.text = @"活动合集".localized);
        (![dic[@"act_type"] isBlankString]) ? (self.notice_title.text = @"act_type") : (self.notice_title.text = @"独家活动".localized);
    }

    self.tmpIndex++;
    if (self.tmpIndex > self.retArray.count) {
        self.tmpIndex = 0;
    }
}

@end
