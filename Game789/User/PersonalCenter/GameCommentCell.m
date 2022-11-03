//
//  GameCommentCell.m
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameCommentCell.h"
#import "MLLinkLabel.h"
#import "HGThemeGoruminvitViewController.h"
#import "UserPersonalCenterController.h"

@interface GameCommentCell () <MLLinkLabelDelegate>

@property(nonatomic,weak)IBOutlet UIImageView * headerImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)IBOutlet UIButton * agreeButton;
@property(nonatomic,weak)IBOutlet MLLinkLabel * commentLabel;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;

@end

@implementation GameCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewUserDetail)];
    [self.headerImageView addGestureRecognizer:tap];
}

- (void)viewUserDetail
{
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * center = [UserPersonalCenterController new];
    center.user_id = self.model.user_id;
    [[YYToolModel getCurrentVC].navigationController pushViewController:center animated:YES];
}

- (void)setModel:(Comment *)model{
    _model = model;
    self.titleLabel.text = model.nick_name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:MYGetImage(@"avatar_default")];
    self.timeLabel.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[model.create_time longLongValue]];
    [self.agreeButton setTitle:[NSString stringWithFormat:@"%ld",model.agree_count] forState:UIControlStateNormal];
    
    if ([model.type isEqualToString:@"comments"]) {
        self.agreeButton.hidden = YES;
    }
    
    if (model.from_nick_name) {
        self.contentLabel.text = [NSString stringWithFormat:@"回复@%@%@",model.from_nick_name,model.content];
        NSMutableAttributedString * contentString = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
        [contentString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#282828"]} range:NSMakeRange(0, contentString.length)];
        [contentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFC000"] range:NSMakeRange(2, model.from_nick_name.length+1)];
        self.contentLabel.attributedText = contentString;
    }else{
        self.contentLabel.text = model.content;
    }
    
    NSString * linkString = [NSString stringWithFormat:@"#%@#",model.theme_name];
    NSString * fromContentString = [NSString stringWithFormat:@"%@%@",linkString,model.from_content];
    NSMutableAttributedString * fromContentAttributedString = [[NSMutableAttributedString alloc] initWithString:fromContentString];
    [fromContentAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, fromContentString.length)];
    [fromContentAttributedString addAttribute:NSLinkAttributeName value:linkString range:NSMakeRange(0, linkString.length)];
    self.commentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFC000"]};
    self.commentLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    self.commentLabel.attributedText = fromContentAttributedString;
    self.commentLabel.delegate = self;
    
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    NSLog(@"link=%@",linkText);
    
    HGThemeGoruminvitViewController * theme = [[HGThemeGoruminvitViewController alloc] init];
    theme.navBar.title = self.model.theme_name;
    theme.themeId = self.model.themeid;
    [[YYToolModel getCurrentVC].navigationController pushViewController:theme animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
