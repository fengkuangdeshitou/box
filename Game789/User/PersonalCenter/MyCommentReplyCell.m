//
//  MyCommentReplyCell.m
//  Game789
//
//  Created by Maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyCommentReplyCell.h"
#import "UserPersonalCenterController.h"

@implementation MyCommentReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _showContent.lineBreakMode = NSLineBreakByWordWrapping;
    _showContent.textColor = kLinkTextColor;
    _showContent.font = kComTextFont;
    _showContent.numberOfLines = 0;
    _showContent.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    _showContent.linkTextAttributes = @{NSForegroundColorAttributeName:kHLTextColor};
    _showContent.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kHLTextColor,NSBackgroundColorAttributeName:kHLBgColor};
    _showContent.activeLinkToNilDelay = 0.3;
    _showContent.delegate = self;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewGameDetail)];
    [self.gameIcon addGestureRecognizer:tap];
}

- (void)viewGameDetail
{
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = self.comment.game_info[@"game_id"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    [self.gameIcon sd_setImageWithURL:[NSURL URLWithString:comment.game_info[@"game_image"][@"thumb"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.gameName.text = comment.game_info[@"game_name"];
    self.nameRemark.layer.cornerRadius = 3;
        self.nameRemark.layer.borderColor = [UIColor colorWithHexString:@"#E3B579"].CGColor;
        self.nameRemark.layer.borderWidth = 0.5;
    self.nameRemark.hidden = [comment.game_info[@"nameRemark"] length] == 0;
    //显示游戏类型
    NSString * nameRemark = comment.game_info[@"nameRemark"];
    NSString * string = @"";
    if (![YYToolModel isBlankString:nameRemark])
    {
        self.nameRemark.text = [comment.game_info[@"nameRemark"] stringByAppendingString:@"  "];
    }
    
    for (NSDictionary * dic in comment.game_info[@"game_classify_name"])
    {
        if ([string isEqualToString:@""])
        {
            string = dic[@"name"];
        }
        else
        {
            string = [NSString stringWithFormat:@"%@ %@", string, dic[@"name"]];
        }
    }
    self.gameType.text = string;
    
    self.showTime.text = [Utility getDateFormatByTimestamp:[comment.time doubleValue]];
    
    self.showContent.text = [NSString stringWithFormat:@"%@%@ %@", @"回复".localized, comment.reply_nickname, comment.content];
    
    comment.isReplyComment = YES;
    self.showContent.attributedText = kMLLinkLabelAttributedText(comment);
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{
    linkText = [linkText stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * user_id = @"";
    if ([linkText isEqualToString:_comment.user_nickname])
    {
        user_id = _comment.user_id;
    }
    else if ([linkText isEqualToString:_comment.reply_nickname])
    {
        user_id = _comment.reply_user_id;
    }
    [self pushPersonalCerter:user_id];
}

- (void)pushPersonalCerter:(NSString *)user_id
{
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
    personal.user_id = user_id;
    personal.isHiddenBtn = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:personal animated:YES];
}

@end
