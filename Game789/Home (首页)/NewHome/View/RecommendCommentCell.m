//
//  RecommendCommentCell.m
//  Game789
//
//  Created by maiyou on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RecommendCommentCell.h"

@interface RecommendCommentCell ()

@property(nonatomic,weak)IBOutlet UIImageView * avatar;
@property(nonatomic,weak)IBOutlet UIImageView * leven;
@property(nonatomic,weak)IBOutlet UILabel * nickName;
@property(nonatomic,weak)IBOutlet UILabel * commentNumber;
@property(nonatomic,weak)IBOutlet UILabel * content;
@property(nonatomic,weak)IBOutlet UILabel * device;
@property(nonatomic,weak)IBOutlet UIButton * agree;
@property(nonatomic,weak)IBOutlet UIButton * comment;
@property(nonatomic,weak)IBOutlet UIButton * more;

@end

@implementation RecommendCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:data[@"user_icon"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.content.numberOfLines = 4;
    self.content.text = data[@"content"];
    self.device.text = data[@"device_name"];
    [self.agree setTitle:[NSString stringWithFormat:@"%@",data[@"like_count"]] forState:UIControlStateNormal];
    self.nickName.text = data[@"user_nickname"];
    [self.comment setTitle:[NSString stringWithFormat:@"%@",data[@"reply_count"]] forState:UIControlStateNormal];
    self.leven.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@",data[@"user_level"]]];
    self.commentNumber.text = [NSString stringWithFormat:@"共发表%@个游戏评论",data[@"user_comment_count"]];
    CGFloat contentHeight = [self.content.text boundingRectWithSize:CGSizeMake(ScreenWidth-76, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    self.more.hidden = contentHeight < 75;
}

- (IBAction)gameDetail:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTuGameDetail" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
