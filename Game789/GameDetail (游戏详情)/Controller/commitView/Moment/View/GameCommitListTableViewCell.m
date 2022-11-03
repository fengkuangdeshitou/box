//
//  GameCommitListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GameCommitListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "UserPersonalCenterController.h"

#import "MomentCell.h"
@class CommentLabel;

#import "CommentApi.h"
@class LikeCommentApi;

@interface GameCommitListTableViewCell () <MLLinkLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconIMG;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *like_count;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *comment_icon;
@property (weak, nonatomic) IBOutlet UILabel *comment_count;
@property (weak, nonatomic) IBOutlet UIImageView *status_icon;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet UIImageView *memberLevel;
@property (weak, nonatomic) IBOutlet UIImageView *memberMark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabel_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentCountImage_height;
@property (weak, nonatomic) IBOutlet UIImageView *commentCountImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showGameType_left;
@property (weak, nonatomic) IBOutlet UIButton *showIntegral;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
// 内容Label
@property (nonatomic,strong) MLLinkLabel * contentLabel;

@end

@implementation GameCommitListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _contentLabel = kMLLinkLabel();
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    [self.likeButton setImage:[UIImage imageNamed:@"lhh_home_zan"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:UIControlStateSelected];
    
    self.iconIMG.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonalCenter)];
    [self.iconIMG addGestureRecognizer:tap];
}

- (void)pushPersonalCenter
{
    if (self.isShowComment)
    {
        GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
        detail.gameID = self.comment.game_info[@"game_id"];
        [self.currentVC.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        if (![YYToolModel isAlreadyLogin]) return;
        UserPersonalCenterController * personal = [[UserPersonalCenterController alloc] init];
        personal.user_id = _comment.user_id;
        personal.isHiddenBtn = YES;
        [self.currentVC.navigationController pushViewController:personal animated:YES];
    }
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    // 状态
    if (self.isShowComment)//个人中心中显示
    {
        if ([comment.user_id isEqualToString:[YYToolModel getUserdefultforKey:USERID]])
        {
            if (comment.status.intValue == 0) {
                _status_icon.image = [UIImage imageNamed:@"product_status_pending_review"];
            }
            else if (comment.status.intValue == 1) {
                _status_icon.hidden = YES;
            }
            else if (comment.status.intValue == -1) {
                _status_icon.image = [UIImage imageNamed:@"product_status_back"];
            }
        }
        
        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:comment.game_info[@"game_image"][@"thumb"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        self.nameLabel.text = comment.game_info[@"game_name"];
        NSString * string = @"";
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
        self.showGameType.text = string;
        self.commentCountImage.hidden = YES;
        self.commentCountImage_height.constant = 0;
        self.showGameType_left.constant = 0;
        
        self.memberMark.hidden = YES;
        self.memberLevel.hidden = YES;
        
        self.timeLabel.text = [Utility getDateFormatByTimestamp:[comment.time doubleValue]];
    }
    else
    {
        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:comment.user_logo] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        self.nameLabel.text = comment.user_nickname;
        
        if (self.isComments)
        {
            self.commentCountImage.hidden = YES;
            self.commentCountImage_height.constant = 0;
            self.showGameType_left.constant = 0;
            self.showGameType.hidden = YES;
            self.nameLabel_height.constant = self.iconIMG.height;
        }
        else
        {
            self.showGameType.text = [NSString stringWithFormat:@"%@%@%@", @"共发表".localized, comment.user_comment_count, @"个游戏评论".localized];
            self.commentCountImage.hidden = NO;
        }
        
        _status_icon.hidden = YES;
        
        //会员等级
        if (comment.user_level.length > 0)
        {
            self.memberLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", comment.user_level.intValue]];
            self.memberMark.hidden = NO;
            self.memberLevel.hidden = NO;
            self.memberMark.image = [UIImage imageNamed:@"hg_icon"];
            if (comment.user_level.integerValue == 0)
            {
                self.memberMark.hidden = YES;
            }
        }
        else
        {
            self.memberMark.hidden = YES;
            self.memberLevel.hidden = YES;
        }
        //该评论为自己隐藏会员等级
        if ([comment.user_id isEqualToString:self.moment.user_id])
        {
            self.memberLevel.hidden = YES;
            self.memberLevel.hidden = YES;
        }
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@  %@", [Utility getDateFormatByTimestamp:[comment.time doubleValue]], comment.device_name];
        
        //金币
        if (comment.reward_intergral_amount.intValue > 0)
        {
            [self.showIntegral setTitle:[NSString stringWithFormat:@"%.f", comment.reward_intergral_amount.floatValue] forState:0];
            if (comment.reward_intergral_amount.floatValue >= 15) {
                _coinImageView.image = MYGetImage(@"icon_reward_4");
                [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#FA4D47"] forState:0];
            }else if (comment.reward_intergral_amount.floatValue >= 10 && comment.reward_intergral_amount.floatValue < 15) {
                _coinImageView.image = MYGetImage(@"icon_reward_3");
                [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
            }else if (comment.reward_intergral_amount.floatValue >= 5 && comment.reward_intergral_amount.floatValue < 10) {
                _coinImageView.image = MYGetImage(@"icon_reward_2");
                [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
            }else {
                _coinImageView.image = MYGetImage(@"icon_reward_1");
                [self.showIntegral setTitleColor:[UIColor colorWithHexString:@"#5574FE"] forState:0];
            }
        }
        else
        {
            self.showIntegral.hidden = YES;
            self.coinImageView.hidden = YES;
        }
        
    }
    
    CGFloat content_height = 0;
    if (comment.reply_id.intValue > 0)
    {
        self.contentText.text = [NSString stringWithFormat:@"%@%@ %@", @"回复".localized, comment.reply_nickname, comment.content];
        self.contentText.hidden = YES;
        
        comment.isReplyComment = YES;
        _contentLabel.attributedText = kMLLinkLabelAttributedText(comment);
        CGSize attrStrSize = [_contentLabel preferredSizeWithMaxWidth:kScreenW - 85];
        _contentLabel.origin = CGPointMake(self.contentText.origin.x+13,self.contentText.origin.y);
        _contentLabel.size = attrStrSize;
        content_height = attrStrSize.height;
    }
    else
    {
        self.contentText.text = comment.content;
        content_height = self.contentText.height;
    }
    
    self.like_count.text = comment.like_count;
    
    self.comment_icon.hidden = !self.isShowComment;
    self.comment_count.hidden = !self.isShowComment;
    self.comment_count.text = comment.reply_count;
    
    
    (comment.me_like.intValue == 0) ? (self.likeButton.selected = NO) : (self.likeButton.selected = YES);
    
    comment.rowHeight = 89 + content_height;
}

- (IBAction)likeButtonAction:(id)sender
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if (_comment.me_like.intValue == 0)
    {
        UIButton * button = (UIButton *)sender;
        LikeCommentApi * api = [[LikeCommentApi alloc] init];
        api.Id = self.comment.Id;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                _like_count.text = [NSString stringWithFormat:@"%d", _comment.like_count.intValue + 1];
                _comment.me_like = @"1";
                [button setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:0];
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
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
    [self.currentVC.navigationController pushViewController:personal animated:YES];
}

@end
