//
//  MessageCell.m
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property(nonatomic,weak)IBOutlet UIImageView * headerImageView;
@property(nonatomic,weak)IBOutlet UILabel * showTitle;
@property(nonatomic,weak)IBOutlet UILabel * showContent;
@property(nonatomic,weak)IBOutlet UILabel * showTime;
@property(nonatomic,weak)IBOutlet UILabel * nickName;
@property(nonatomic,weak)IBOutlet UIView * readTagView;

@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GetSettingNewsMgsModel *)model{
    _model = model;
    
    self.showTitle.text = model.title;
    self.showContent.text = model.content;
    
    if ([model.type isEqualToString:@"topic"]) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.from_avatar] placeholderImage:MYGetImage(@"avatar_default")];
        self.nickName.text = model.from_nick_name;
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:MYGetImage(@"avatar_default")];
        self.nickName.text = model.nick_name;
    }
    
    NSString * time = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[model.message_time floatValue]];
    self.showTime.text = time;
    
    NSInteger isRead = model.read_tag.integerValue;
    // 1 已读
    self.readTagView.hidden = isRead == 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
