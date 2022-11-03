//
//  GameTopicCell.m
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GameTopicCell.h"
#import "UserPersonalCenterController.h"

@interface GameTopicCell ()

@property(nonatomic,weak)IBOutlet UIImageView * headerImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;
@property(nonatomic,weak)IBOutlet UIButton * openButton;
@property(nonatomic,weak)IBOutlet UIButton * themeButton;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * contentLabelHeight;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * openViewHeight;
@property(nonatomic,weak)IBOutlet UIButton * agreeButton;
@property(nonatomic,weak)IBOutlet UIButton * notAgreeButton;
@property(nonatomic,weak)IBOutlet UIButton * commentButton;

@end

@implementation GameTopicCell

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

- (void)setModel:(Comment *)model
{
    _model = model;
    
    self.titleLabel.text = model.nick_name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:MYGetImage(@"avatar_default")];
    self.timeLabel.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[model.create_time longLongValue]];
    self.contentLabel.text = model.content;
    [self.themeButton setTitle:model.theme_name forState:UIControlStateNormal];
    
    CGFloat contentHeight = ceilf([model.content boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height);

    if (model.isOpen) {
        self.openViewHeight.constant = 17;
        self.contentLabelHeight.constant = contentHeight;
        [self.openButton setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        if (contentHeight > 68) {
            self.contentLabelHeight.constant = 68;
            [self.openButton setTitle:@"全文" forState:UIControlStateNormal];
            self.openViewHeight.constant = 20;
        }else{
            self.openViewHeight.constant = 0;
            self.contentLabelHeight.constant = contentHeight;
        }
    }
    
    [self.agreeButton setTitle:[NSString stringWithFormat:@"%ld",model.agree_count] forState:UIControlStateNormal];
    [self.notAgreeButton setTitle:[NSString stringWithFormat:@"%ld",model.disagree_count] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",model.comment_count] forState:UIControlStateNormal];
    
}

- (IBAction)heightChange:(UIButton *)sender
{
    self.model.isOpen = !self.model.isOpen;
    if (self.cellHeightChangeBlock){
        self.cellHeightChangeBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
