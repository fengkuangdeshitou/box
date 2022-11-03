//
//  MessageHeaderCell.m
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MessageHeaderCell.h"

@interface MessageHeaderCell ()

@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;
@property(nonatomic,weak)IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)IBOutlet UILabel * messageNumberLabel;
@property(nonatomic,weak)IBOutlet UIView * numberBackView;

@end

@implementation MessageHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberBackView.layer.cornerRadius = self.numberBackView.height/2;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"message_%@",data[@"type"]]];
    self.titleLabel.text = data[@"title"];
    
    NSInteger message_total = [data[@"message_total"] integerValue];
    self.messageNumberLabel.text = [NSString stringWithFormat:@"%ld",message_total];
    if (message_total == 0) {
        self.messageNumberLabel.hidden = YES;
        self.numberBackView.hidden = YES;
        self.contentLabel.text = @"暂无新消息通知".localized;
        self.timeLabel.text = @"";
    }else{
        self.messageNumberLabel.hidden = NO;
        self.numberBackView.hidden = NO;
        self.contentLabel.text = @"您有新的消息通知".localized;
        self.timeLabel.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[data[@"message_time"] doubleValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
