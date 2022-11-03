//
//  MLLabelUtil.m
//  MomentKit
//
//  Created by LEA on 2017/12/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MLLabelUtil.h"

@implementation MLLabelUtil

MLLinkLabel *kMLLinkLabel()
{
    MLLinkLabel *_linkLabel = [MLLinkLabel new];
    _linkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _linkLabel.textColor = kLinkTextColor;
    _linkLabel.font = kComTextFont;
    _linkLabel.numberOfLines = 0;
    _linkLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    _linkLabel.linkTextAttributes = @{NSForegroundColorAttributeName:kHLTextColor};
    _linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kHLTextColor,NSBackgroundColorAttributeName:kHLBgColor};
    _linkLabel.activeLinkToNilDelay = 0.3;
    return _linkLabel;
}

NSMutableAttributedString *kMLLinkLabelAttributedText(id object)
{
    NSMutableAttributedString *attributedText = nil;
    if ([object isKindOfClass:[Comment class]])
    {
        Comment *comment = (Comment *)object;
        if (comment.reply_user_id.intValue > 0)
        {
            NSString *likeString  = [NSString stringWithFormat:@"%@: %@ %@ %@", comment.user_nickname, @"回复".localized,comment.reply_nickname,comment.content];
            NSString * linkText = [NSString stringWithFormat:@"%@:", comment.user_nickname];
            if (comment.isReplyComment)
            {
                likeString  = [NSString stringWithFormat:@"%@ %@ %@", @"回复".localized, comment.reply_nickname, comment.content];
                linkText = comment.reply_nickname;
            }
            attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:linkText}
                                    range:[likeString rangeOfString:linkText]];
//            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:comment.reply_nickname}
//                                    range:[likeString rangeOfString:comment.reply_nickname]];
        }
        else
        {
            if ([comment.replyUser isKindOfClass:[NSDictionary class]] && comment.replyUser.allValues.count > 0)
            {
                NSString *likeString  = [NSString stringWithFormat:@"%@ %@: %@", @"回复".localized, comment.replyUser[@"nickname"], comment.content];
                attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
                NSString * linkText = [NSString stringWithFormat:@"%@:", comment.replyUser[@"nickname"]];
                [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:linkText}
                                        range:[likeString rangeOfString:linkText]];
            }
            else
            {
                NSString *likeString  = [NSString stringWithFormat:@"%@: %@", comment.user_nickname, comment.content];
                attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
                NSString * linkText = [NSString stringWithFormat:@"%@:", comment.user_nickname];
                [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:linkText}
                                        range:[likeString rangeOfString:linkText]];
            }
        }
    }
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *content = (NSString *)object;
        NSString *likeString = [NSString stringWithFormat:@"[赞] %@",content];
        attributedText = [[NSMutableAttributedString alloc] initWithString:likeString];
        NSArray *nameList = [content componentsSeparatedByString:@"，"];
        for (NSString *name in nameList) {
            [attributedText setAttributes:@{NSFontAttributeName:kComHLTextFont,NSLinkAttributeName:name}
                                    range:[likeString rangeOfString:name]];
        }
        
        //添加'赞'的图片
        NSRange range = NSMakeRange(0, 3);
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"moment_like_hl"];
        textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedText replaceCharactersInRange:range withAttributedString:imageStr];
    }
    return attributedText;
}


@end
