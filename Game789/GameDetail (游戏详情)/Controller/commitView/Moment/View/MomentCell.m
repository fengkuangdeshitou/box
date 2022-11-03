//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#import "CommentApi.h"
@class LikeCommentApi;

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.contentView.backgroundColor = BackColor;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, self.contentView.height)];
    _backView.layer.cornerRadius = 13;
    _backView.layer.masksToBounds = YES;
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = kFaceWidth / 2;
    [_backView addSubview:_headImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [_headImageView addGestureRecognizer:tapGesture];
    
    // 审核状态
    _status_icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 16 - 40 - kRightMargin, kBlank, 40, 40)];
    [_backView addSubview:_status_icon];
    
    //金币
    _coinLab = [[UILabel alloc] init];
    _coinLab.font = [UIFont boldSystemFontOfSize:10];
    _coinLab.text = @"";
    _coinLab.textAlignment = NSTextAlignmentCenter;
    _coinLab.textColor = [UIColor colorWithHexString:@"#5574FE"];
    [_backView addSubview:_coinLab];
    
    _coinImageView = [[UIImageView alloc] init];
    [_backView addSubview:_coinImageView];
    
    // 名字视图
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right+10, _headImageView.top + 2, kTextWidth, 20)];
    _nameLab.font = [UIFont systemFontOfSize:13.0];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _nameLab.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_nameLab];
    //会员等级
    _memberLevel = [[UIImageView alloc] init];
    _memberLevel.image = [UIImage imageNamed:@"member_level0"];
    [_backView addSubview:_memberLevel];
    
    _memberMark = [[UIImageView alloc] init];
    _memberMark.image = [UIImage imageNamed:@"hg_icon"];
    _memberMark.center = CGPointMake(_headImageView.center.x + 13, _headImageView.center.y - 20);
    _memberMark.size = CGSizeMake(12, 12);
    [_backView addSubview:_memberMark];
    
    //评论数量
    _commentCount = [[UIImageView alloc] initWithFrame:CGRectMake(_headImageView.right+10, _nameLab.bottom + 4.5, 13.5, 12)];
    _commentCount.image = [UIImage imageNamed:@"home_comment_icon"];
    [_backView addSubview:_commentCount];
    
    //游戏类型/评论的数量
    _showGameType = [[UILabel alloc] initWithFrame:CGRectMake(_commentCount.right + 2, _nameLab.bottom, kTextWidth, 20)];
    _showGameType.font = [UIFont systemFontOfSize:11.0];
    _showGameType.textColor = [UIColor colorWithHexString:@"#999999"];
    _showGameType.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_showGameType];
    
    // 时间视图
    _timeLab = [[UILabel alloc] init];
    _timeLab.font = [UIFont systemFontOfSize:11.0];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_timeLab];
    
    // 机型视图
    _deviceName = [[UILabel alloc] init];
    _deviceName.font = [UIFont systemFontOfSize:13.0];
    _deviceName.textColor = [UIColor colorWithHexString:@"#999999"];
    _deviceName.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_deviceName];
    
    //点赞
    _likeCount = [[UILabel alloc] init];
    _likeCount.font = [UIFont systemFontOfSize:13];
    _likeCount.text = @"0";
    _likeCount.textColor = kLinkTextColor;
    [_backView addSubview:_likeCount];
    
    _likeBtn = [[MyLikeButton alloc]init];
    _likeBtn.animateStyle = YYViewAnimateEffectStyleFlash;
    [_likeBtn setImage:[UIImage imageNamed:@"lhh_home_zan"] forState:0];
    [_likeBtn setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(likeCountClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_likeBtn];
    
    //评论
    _commitCount = [[UILabel alloc] init];
    _commitCount.font = [UIFont systemFontOfSize:13];
    _commitCount.text = @"0";
    _commitCount.textColor = kLinkTextColor;
    [_backView addSubview:_commitCount];
    
    _commitBtn = [[UIImageView alloc]init];
    _commitBtn.image = [UIImage imageNamed:@"lhh_home_msg"];
    _commitBtn.userInteractionEnabled = NO;
    [_backView addSubview:_commitBtn];
    
    // 正文视图
    _linkLabel = kMLLinkLabel();
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    _linkLabel.textAlignment = NSTextAlignmentJustified;
    _linkLabel.linkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor};
    _linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor,NSBackgroundColorAttributeName:kHLBgColor};
    [_backView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc]init];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
    [_showAllBtn setTitle:@"全文".localized forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_showAllBtn];
    
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [_backView addSubview:_imageListView];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [_backView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    [_backView addSubview:_commentView];
    
    // 最大高度限制
    maxLimitHeight = _linkLabel.font.lineHeight * 6;
    
    _nameRemark = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameRemark.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    _nameRemark.textColor = [UIColor colorWithHexString:@"#946328"];
    _nameRemark.textAlignment = 1;
    [_backView addSubview:_nameRemark];
    [_nameRemark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLab.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLab.mas_centerY);
            make.height.mas_equalTo(@(17));
    }];
    
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 状态
    if (self.isPersonal)//是否显示在个人中心
    {
        if ([moment.user_id isEqualToString:[YYToolModel getUserdefultforKey:USERID]])
        {
            if (moment.status.intValue == 0) {
                _status_icon.image = [UIImage imageNamed:@"product_status_pending_review"];
                _status_icon.hidden = NO;
            }
            else if (moment.status.intValue == 1) {
                _status_icon.hidden = YES;
            }
            else if (moment.status.intValue == -1) {
                _status_icon.image = [UIImage imageNamed:@"product_status_back"];
                _status_icon.hidden = NO;
            }
        }
        
        // 头像
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:moment.game_info[@"game_image"][@"thumb"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        self.headImageView.size = CGSizeMake(44, 44);
        self.headImageView.layer.cornerRadius = 8;
        //游戏名称
        self.nameLab.text = moment.game_info[@"game_name"];
        self.nameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.nameLab.textColor = FontColor28;
        CGSize size = [YYToolModel sizeWithText:moment.game_info[@"game_name"] size:CGSizeMake(MAXFLOAT, self.nameLab.height) font:self.nameLab.font];
        self.nameLab.width = size.width;
        //显示游戏类型
        self.nameRemark.layer.cornerRadius = 3;
            self.nameRemark.layer.borderColor = [UIColor colorWithHexString:@"#E3B579"].CGColor;
            self.nameRemark.layer.borderWidth = 0.5;
        NSString * nameRemark = moment.game_info[@"nameRemark"];
        NSString * string = @"";
        self.nameRemark.hidden = nameRemark.length == 0;

        if (![YYToolModel isBlankString:nameRemark])
        {
            self.nameRemark.text = [nameRemark stringByAppendingString:@"  "];
        }
            for (NSDictionary * dic in moment.game_info[@"game_classify_name"])
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
        
        self.showGameType.bottom = self.headImageView.bottom - 2;
        self.commentCount.hidden = YES;
        self.nameLab.x = _headImageView.right + 10;
        self.showGameType.x = _headImageView.right + 10;
        
        self.memberLevel.hidden = YES;
        self.memberMark.hidden = YES;
        //时间
        _timeLab.text = [Utility getDateFormatByTimestamp:[moment.time doubleValue]];
        
    }
    else
    {
        // 头像
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:moment.user_icon] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        // 昵称
        self.nameLab.text = moment.user_nickname;
        self.nameLab.textColor = moment.user_id.intValue == 928440 ? UIColor.redColor : kLinkTextColor;
        CGSize size = [YYToolModel sizeWithText:moment.user_nickname size:CGSizeMake(MAXFLOAT, self.nameLab.height) font:self.nameLab.font];
        self.nameLab.width = size.width;
        //会员等级
        self.memberLevel.image = [UIImage imageNamed:@"member_level0"];
        self.memberLevel.frame = CGRectMake(CGRectGetMaxX(self.nameLab.frame) + 5, self.nameLab.y, 36, 20);
        
        //显示评论数量
        if (moment.user_comment_count.integerValue == 0 || !moment.user_comment_count)
        {
            self.showGameType.hidden = YES;
            self.commentCount.hidden = YES;
            self.showGameType.x = _headImageView.right + 10;
            _nameLab.hidden = self.headImageView.height;
        }
        else
        {
            self.showGameType.text = [NSString stringWithFormat:@"%@%@%@", @"共发表".localized, moment.user_comment_count, @"个游戏评论".localized];
            self.commentCount.hidden = NO;
        }
        
        _status_icon.hidden = YES;
        
        if (moment.user_level.length > 0)
        {
            self.memberLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d", moment.user_level.intValue]];
            self.memberMark.hidden = NO;
            self.memberLevel.hidden = NO;
            if (moment.user_level.integerValue == 0)
            {
                self.memberMark.hidden = YES;
            }
        }
        else
        {
            self.memberMark.hidden = YES;
            self.memberLevel.hidden = YES;
        }
        //时间
        _timeLab.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[moment.time doubleValue]]];
    }
    //点赞数量
    (moment.me_like.intValue == 0) ? (_likeBtn.selected = NO) : (_likeBtn.selected = YES);
    _likeCount.text = moment.like_count;
    _commitCount.text = moment.reply_count;
    //金币
    if (moment.reward_intergral_amount.intValue > 0)
    {
        self.coinLab.hidden = NO;
        self.coinImageView.hidden = NO;
        self.timeLab.hidden = YES;
        
        if (moment.reward_intergral_amount.floatValue >= 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_4");
            self.coinLab.textColor = [UIColor colorWithHexString:@"#FA4D47"];
        }else if (moment.reward_intergral_amount.floatValue >= 10 && moment.reward_intergral_amount.floatValue < 15) {
            _coinImageView.image = MYGetImage(@"icon_reward_3");
            self.coinLab.textColor = [UIColor colorWithHexString:@"#5574FE"];
        }else if (moment.reward_intergral_amount.floatValue >= 5 && moment.reward_intergral_amount.floatValue < 10) {
            _coinImageView.image = MYGetImage(@"icon_reward_2");
            self.coinLab.textColor = [UIColor colorWithHexString:@"#5574FE"];
        }else {
            _coinImageView.image = MYGetImage(@"icon_reward_1");
            self.coinLab.textColor = [UIColor colorWithHexString:@"#5574FE"];
        }
        self.coinLab.text = [NSString stringWithFormat:@"%.f", moment.reward_intergral_amount.floatValue];
    }
    else
    {
        self.coinLab.hidden = YES;
        self.coinImageView.hidden = YES;
        self.timeLab.hidden = NO;
    }
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _headImageView.bottom + kPaddingValue;
    CGFloat rowHeight = 0;
    if ([moment.content length]) {
        _linkLabel.hidden = NO;
        _linkLabel.text = moment.content;
        _linkLabel.textColor = moment.user_id.intValue == 928440 ? UIColor.redColor : kLinkTextColor;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labH = attrStrSize.height;
        if (labH > maxLimitHeight) {
            if (!_moment.isFullText) {
                labH = maxLimitHeight;
                [self.showAllBtn setTitle:@"全文".localized forState:UIControlStateNormal];
            } else {
                [self.showAllBtn setTitle:@"收起".localized forState:UIControlStateNormal];
            }
            _showAllBtn.hidden = NO;
        }
        _linkLabel.frame = CGRectMake(_headImageView.left, bottom, attrStrSize.width, labH);
        _showAllBtn.frame = CGRectMake(_headImageView.left, _linkLabel.bottom + kArrowHeight, kMoreLabWidth, kMoreLabHeight);
        if (_showAllBtn.isHidden) {
            bottom = _linkLabel.bottom + kImagePadding;
        } else {
            bottom = _showAllBtn.bottom + kImagePadding;
        }
    }
    
    //金币
    _coinImageView.frame = CGRectMake(kScreenW - 88 - kRightMargin, _nameLab.y, 68, 50);
    _coinLab.frame = CGRectMake(_coinImageView.x, _coinImageView.y + (_coinImageView.height - 20) / 2, _coinImageView.width, 20);
    // 图片
    _imageListView.moment = moment;
    if (moment.pic_list.count > 0) {
        _imageListView.origin = CGPointMake(_headImageView.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = k_screen_width - kRightMargin * 2;
    // 处理评论
    NSInteger count = [moment.reply_list count];
    if (count > 0) {
        for (NSInteger i = 0; i < count; i ++)
        {
            if (i > 2)
            {
                break;
            }
            CommentLabel *label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
            label.comment = [moment.reply_list objectAtIndex:i];
            [label setDidClickLinkText:^(MLLink *link, NSString *linkText, Comment *comment) {
                if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:detail:)]) {
                    [self.delegate didClickLink:link linkText:linkText detail:comment];
                }
            }];
            [_commentView addSubview:label];
            // 更新
            top += label.height;
            
            if (moment.reply_count.integerValue > 3 && i == 2)
            {
                UILabel * moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 3, width, 20)];
                moreLabel.text = [NSString stringWithFormat:@"%@%@%@", @"查看全部".localized, moment.reply_count, @"条回复>".localized];
                moreLabel.font = kComTextFont;
                moreLabel.textColor = kHLTextColor;
                [_commentView addSubview:moreLabel];
                
                top += moreLabel.height;
            }
        }
    }
    //设备名称
    _deviceName.text = moment.device_name;
    // 更新UI
    if (top > 0)
    {//有评论
        _bgImageView.frame = CGRectMake(_headImageView.left, bottom, width, top);
        _commentView.frame = CGRectMake(_headImageView.left, bottom, width, top);
        
        _deviceName.frame = CGRectMake(_headImageView.left, _commentView.bottom + kBlank, kTextWidth, 18);
    }
    else
    {        
        CGFloat device_top = _imageListView.bottom + kBlank;
        if (moment.pic_list.count == 0)
            device_top = bottom;
                    
        _deviceName.frame = CGRectMake(_headImageView.left, device_top, kTextWidth, 18);
    }
    //时间
    _timeLab.frame = CGRectMake(kScreenW - 100 - kRightMargin * 2, _headImageView.center.y - 10, 85, 18);
    
    rowHeight = _deviceName.bottom + kBlank;
    
    _likeCount.frame = CGRectMake(kScreenW - 40 - kRightMargin, _deviceName.top, 40, _deviceName.height);
    _likeBtn.frame = CGRectMake(_likeCount.left - 23, _deviceName.top, 18, _deviceName.height);
    CGSize commitSize = [YYToolModel sizeWithText:moment.reply_count size:CGSizeMake(MAXFLOAT, 20) font:_commitCount.font];
    _commitCount.frame = CGRectMake(_likeBtn.left - commitSize.width - 15, _deviceName.top, commitSize.width, _deviceName.height);
    _commitBtn.frame = CGRectMake(_commitCount.left - 23, _deviceName.top, 18, _deviceName.height);
    
    _backView.height = rowHeight;
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    _moment.rowHeight = rowHeight;
}

#pragma mark - 点击事件
// 查看全文/收起
- (void)fullTextClicked:(UIButton *)sender
{
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        _moment.isFullText = !_moment.isFullText;
        if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
            [self.delegate didSelectFullText:self];
        }
    });
}

// 点击头像
- (void)clickHead:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(didClickProfile:)]) {
        [self.delegate didClickProfile:self];
    }
}

//点赞
- (void)likeCountClicked:(UIButton *)sender
{
    if (![YYToolModel islogin])
    {
        if (self.hiddenCommitPopView)
        {
            self.hiddenCommitPopView(YES);
        }
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if (!sender.selected)
    {
        LikeCommentApi * api = [[LikeCommentApi alloc] init];
        api.Id = _moment.Id;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                _likeCount.text = [NSString stringWithFormat:@"%d", _moment.like_count.intValue + 1];
                _moment.me_like = @"1";
                sender.selected = YES;
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
    else
    {
        [MBProgressHUD showToast:@"已经点过赞了"];
    }
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
//    // 点击动态正文或者赞高亮
//    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
//        [self.delegate didClickLink:link linkText:linkText];
//    }
}
@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel();
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    _linkLabel.attributedText = kMLLinkLabelAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(0, 0, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 3;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(link,linkText,_comment);
    }
}

#pragma mark - 点击
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.backgroundColor = kHLBgColor;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
//    dispatch_after(when, dispatch_get_main_queue(), ^{
//        self.backgroundColor = [UIColor clearColor];
//        if (self.didClickText) {
//            self.didClickText(_comment);
//        }
//    });
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.backgroundColor = [UIColor clearColor];
//}

@end
