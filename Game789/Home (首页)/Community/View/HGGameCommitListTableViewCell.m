//
//  HGGameCommitListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HGGameCommitListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserPersonalCenterController.h"

#import "MomentCell.h"
#import "MyCommunityRequestApi.h"
@class CommentLabel;
@class MyCommunityAppraisalAgreeApi;
@class MyCommunityAppraisalCancleAgreeApi;


@interface HGGameCommitListTableViewCell () <MLLinkLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconIMG;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *like_count;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UIImageView *signImage;
@property (weak, nonatomic) IBOutlet UIImageView *userLevel;

// 内容Label
@property (nonatomic,strong) MLLinkLabel * contentLabel;

@end

@implementation HGGameCommitListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.deviceName.text = @"回复 >";
    _contentLabel = kMLLinkLabel();
    _contentLabel.delegate = self;
    [self.contentView addSubview:_contentLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewUserDetai)];
    [self.iconIMG addGestureRecognizer:tap];
}

- (void)viewUserDetai
{
    if (![YYToolModel isAlreadyLogin]) return;
    UserPersonalCenterController * center = [UserPersonalCenterController new];
    center.user_id = self.comment.user[@"id"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:center animated:YES];
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    if (self.isMyReply)
    {
        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:comment.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        self.nameLabel.text = comment.user[@"nickname"];
    }
    else
    {
        // 状态
        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:comment.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        self.nameLabel.text = comment.user[@"nickname"];
        self.showTime.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[comment.createtime doubleValue]]];
//        self.deviceName.text = comment.deviceName;
        self.userLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@", comment.user[@"user_level"]]];
        if (comment.isGodCom) {
            _signImage.hidden = NO;
        }else {
            _signImage.hidden = YES;
        }
        CGFloat content_height = 0;
        if ([comment.replyUser isKindOfClass:[NSDictionary class]]  && comment.replyUser.allValues.count > 0)
        {
            self.contentText.text = [NSString stringWithFormat:@"%@%@ %@", @"回复".localized, comment.replyUser[@"nickname"], comment.content];
            self.contentText.hidden = YES;
            
            comment.isReplyComment = YES;
            _contentLabel.attributedText = kMLLinkLabelAttributedText(comment);
            CGSize attrStrSize = [_contentLabel preferredSizeWithMaxWidth:kScreenW - 85];
            _contentLabel.origin = self.contentText.origin;
            _contentLabel.size = attrStrSize;
            content_height = attrStrSize.height;
        }
        else
        {
            self.contentText.text = comment.content;
            content_height = self.contentText.height;
        }
        
        self.likeButton.selected = comment.isAgreed;
        self.like_count.text = [NSString stringWithFormat:@"%ld", (long)comment.agree_count];
        
        comment.rowHeight = 109 + content_height;
    }
}

//- (void)setCommentDic:(NSDictionary *)commentDic
//{
//    _commentDic = commentDic;
//
//    if (self.isMyReply)
//    {
//        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:commentDic[@"user"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"user_icon"]];
//        self.nameLabel.text = [NSString stringWithFormat:@"%@", commentDic[@"user"][@"nickname"]];
//    }
//    else
//    {
//        // 状态
//        [self.iconIMG sd_setImageWithURL:[NSURL URLWithString:commentDic[@"user"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"user_icon"]];
//        self.nameLabel.text = [NSString stringWithFormat:@"%@", commentDic[@"user"][@"nickname"]];
//
////        self.showTime.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[comment.time doubleValue]]];
//        self.showTime.text = [NSString stringWithFormat:@"%@", commentDic[@"createtime"]];
//
//        CGFloat content_height = 0;
//        if ([commentDic[@"replyUser"] isKindOfClass:[NSDictionary class]])
//        {
//            self.contentText.text = [NSString stringWithFormat:@"%@%@ %@", @"回复".localized, commentDic[@"user"][@"nickname"], commentDic[@"content"]];
//            self.contentText.hidden = YES;
//
////            comment.isReplyComment = YES;
////            _contentLabel.attributedText = kMLLinkLabelAttributedText(comment);
//            CGSize attrStrSize = [_contentLabel preferredSizeWithMaxWidth:kScreenW - 85];
//            _contentLabel.origin = self.contentText.origin;
//            _contentLabel.size = attrStrSize;
//            content_height = attrStrSize.height;
//        }
//        else
//        {
//            self.contentText.text = [NSString stringWithFormat:@"%@", commentDic[@"content"]];
//            content_height = self.contentText.height;
//        }
//
//        self.likeButton.selected = _commentDic[@"isAgreed"];
//        self.like_count.text = [NSString stringWithFormat:@"%ld", (long)[commentDic[@"agree_count"] intValue]];
//
//        _comment.rowHeight = 109 + content_height;
//    }
//}

- (IBAction)likeButtonAction:(id)sender
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    
    UIButton * button = sender;
    if (!_comment.isAgreed) {
        WEAKSELF
        MyCommunityAppraisalAgreeApi * api = [[MyCommunityAppraisalAgreeApi alloc] init];
        api.isShow = YES;
        api.replyId = self.comment.Id;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                weakSelf.comment.agree_count = weakSelf.comment.agree_count + 1;
                weakSelf.like_count.text = [NSString stringWithFormat:@"%ld", weakSelf.comment.agree_count];
                weakSelf.comment.isAgreed = !weakSelf.comment.isAgreed;
                button.selected = !button.selected;
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    } else {
        WEAKSELF
        MyCommunityAppraisalCancleAgreeApi * api = [[MyCommunityAppraisalCancleAgreeApi alloc] init];
        api.isShow = YES;
        api.replyId = self.comment.Id;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                weakSelf.comment.agree_count = weakSelf.comment.agree_count - 1;
                weakSelf.like_count.text = [NSString stringWithFormat:@"%ld", weakSelf.comment.agree_count];
                weakSelf.comment.isAgreed = !weakSelf.comment.isAgreed;
                button.selected = !button.selected;
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
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
    
}

@end
