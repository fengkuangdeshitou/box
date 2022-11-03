//
//  CellForWorkGroupRepost.m
//  HKPTimeLine  仿赤兔、微博动态
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/9/20.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "CellForWorkGroupRepost.h"
#import "YHWorkGroupPhotoContainer.h"
#import "HKPCommon.h"
#import "YHUserInfoManager.h"

#pragma mark - YHWorkGroupRepostView
/***********上一条动态***********/
@interface YHWorkGroupRepostView : UIView

@property (nonatomic,strong)UIImageView *imgvAvatar;
@property (nonatomic,strong)UILabel  *labelName;
@property (nonatomic,strong)UILabel  *labelContent;

// 点赞数量
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel  *likeCount;

@property (nonatomic,assign)BOOL shouldOpenContentLabel;
@property (nonatomic,strong)YHWorkGroup *forwardModel;
@property (nonatomic,strong)UIImageView *comments; //神级评论的图片

@end

static const CGFloat contentLabelFontSizeRepost = 14;

@implementation YHWorkGroupRepostView

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return self;
}

- (void)setup{
    
    _shouldOpenContentLabel = NO;
    
    //头像
    _imgvAvatar = [UIImageView new];
    _imgvAvatar.layer.cornerRadius  = 17;
    _imgvAvatar.layer.masksToBounds = YES;
    [self addSubview:_imgvAvatar];
    
    //name
    _labelName = [UILabel new];
    _labelName.font = [UIFont fontWithName:@"Medium" size:15.0];
    _labelName.textAlignment = NSTextAlignmentLeft;
    _labelName.textColor = [UIColor colorWithHexString:@"#282828"];
    [self addSubview:_labelName];
    
    _likeCount = [[UILabel alloc] init];
    _likeCount.font = [UIFont systemFontOfSize:13];
    _likeCount.text = @"0";
    _likeCount.textColor = [UIColor colorWithHexString:@"#666666"];
    [_likeCount sizeToFit];
    [self addSubview:_likeCount];
    
    _likeBtn = [[UIButton alloc]init];
    [_likeBtn setImage:[UIImage imageNamed:@"lhh_home_zan"] forState:0];
    [_likeBtn setImage:[UIImage imageNamed:@"lhh_home_zanColor"] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(likeCountClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeBtn];
    
    _comments = [UIImageView new];
    _comments.image = [UIImage imageNamed:@"Community_comments"];
    [self addSubview:_comments];

    _labelContent = [UILabel new];
    _labelContent.font = [UIFont systemFontOfSize:contentLabelFontSizeRepost];
    _labelContent.textColor = [UIColor colorWithHexString:@"#666666"];
    _labelContent.numberOfLines = 2;
    [self addSubview:_labelContent];

    [self layoutUI];
}

- (void)layoutUI{
    
    for (UIView * view in self.subviews) {
        NSArray * array = [MASViewConstraint installedConstraintsForView:view];
        for (MASConstraint * constraint in array) {
            [constraint uninstall];
        }
    }
    
    __weak typeof(self)weakSelf = self;
    [self.imgvAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(10);
        make.left.equalTo(weakSelf).offset(10);
        make.width.height.mas_equalTo(34);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.imgvAvatar.mas_centerY);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
//        make.right.equalTo(weakSelf).offset(-10);
    }];
    
    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.likeCount.mas_centerY);
        make.right.equalTo(weakSelf.likeCount).offset(-20);
        make.height.width.equalTo(@17);
    }];
    
    [self.comments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.right.equalTo(weakSelf.likeBtn.mas_left).offset(-10);
        make.height.width.equalTo(@45.5);
    }];

    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(11);
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-15);
        make.bottom.equalTo(weakSelf).offset(-10);
    }];

    // 不然在6/6plus上就不准确了
    self.labelContent.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
}

//点赞
- (void)likeCountClicked:(UIButton *)sender {
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
    UIButton * button = sender;
    NSDictionary * dic = @{@"replyid":self.forwardModel.dynamicId};
    
    if (!_forwardModel.isAgreed) {
        WEAKSELF
//        [YYBaseApi yy_Post:@"/agreeForuminvitAppraisal" parameters:dic swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            weakSelf.forwardModel.agreeCount = weakSelf.forwardModel.agreeCount + 1;
//            weakSelf.likeCount.text = [NSString stringWithFormat:@"%d", weakSelf.forwardModel.agreeCount];
//            weakSelf.forwardModel.isAgreed = !weakSelf.forwardModel.isAgreed;
//            button.selected = !button.selected;
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//        } Hud:YES];
    } else {
        WEAKSELF
//        [YYBaseApi yy_Post:@"/cancelAgreeForuminvitAppraisal" parameters:dic swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            weakSelf.forwardModel.agreeCount = weakSelf.forwardModel.agreeCount - 1;
//            weakSelf.likeCount.text = [NSString stringWithFormat:@"%d", weakSelf.forwardModel.agreeCount];
//            weakSelf.forwardModel.isAgreed = !weakSelf.forwardModel.isAgreed;
//            button.selected = !button.selected;
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//        } Hud:YES];
    }
}

-(void)setForwardModel:(YHWorkGroup *)forwardModel{
    _forwardModel = forwardModel;
    _shouldOpenContentLabel = NO;
    
    
    [self.imgvAvatar sd_setImageWithURL:_forwardModel.userInfo.avatarUrl placeholderImage:[UIImage imageNamed:@"common_avatar_120px"]];
    if (_forwardModel.userInfo.userName) {
        _labelName.text   = _forwardModel.userInfo.userName;
    }else{
        _labelName.text    = @"匿名用户";
    }
    self.labelContent.text  = _forwardModel.msgContent;
    if (forwardModel.isGodCom) {
        self.comments.hidden = NO;
    }else {
        self.comments.hidden = YES;
    }
    self.likeCount.text = [NSString stringWithFormat:@"%d", _forwardModel.likeCount];
}

@end


#pragma mark - CellForWorkGroupRepost

/***发布动态视图**/
CGFloat maxContentRepostLabelHeight;// 根据具体font而定
static const CGFloat moreBtnHeight   = 15;

@interface CellForWorkGroupRepost()<HKPBotViewDelegate>

@property (nonatomic,strong)UIImageView *imgvAvatar;
@property (nonatomic,strong)UIImageView *userLevel;
@property (nonatomic,strong)UILabel     *labelName;
@property (nonatomic,strong)UILabel     *labelCompany;
@property (nonatomic,strong)UIButton    *reportBtn;
@property (nonatomic,strong)UILabel     *labelContent;
@property (nonatomic,strong)UILabel     *labelMore;
@property (nonatomic,strong)UIView      *multimediaView;
@property (nonatomic,strong)YHWorkGroupPhotoContainer *picContainerView;
@property (nonatomic,strong)YHWorkGroupRepostView *repostView;
@property (nonatomic,strong)UIView      *viewSeparator;

@end




@implementation CellForWorkGroupRepost

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setup
{
    //头像
    self.imgvAvatar = [UIImageView new];
    self.imgvAvatar.layer.cornerRadius = 20;
    self.imgvAvatar.layer.masksToBounds = YES;
    self.imgvAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatar:)];
    [self.imgvAvatar addGestureRecognizer:tapGuesture];
    [self.contentView addSubview:self.imgvAvatar];
    
    //名称
    self.labelName  = [UILabel new];
    self.labelName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.labelName.textColor = [UIColor colorWithHexString:@"#282828"];
    [self.contentView addSubview:self.labelName];
    
    //显示用户等级
    self.userLevel = [UIImageView new];
    [self.contentView addSubview:self.userLevel];
    
    //时间label
    self.labelCompany = [UILabel new];
    self.labelCompany.font = [UIFont systemFontOfSize:11];
    self.labelCompany.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    self.labelCompany.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.labelCompany];
    
//    self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    [self.reportBtn setImage:MYGetImage(@"sangedian_icon") forState:0];
////    self.reportBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
//    [self.reportBtn setTitle:@"关注" forState:0];
//    [self.reportBtn setTitle:@"已关注" forState:UIControlStateSelected];
//    [self.reportBtn setTitleColor:MAIN_COLOR forState:0];
//    [self.reportBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateSelected];
//    self.reportBtn.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
//    self.reportBtn.layer.borderWidth = 0.5;
//    self.reportBtn.layer.cornerRadius = 4;
//    self.reportBtn.layer.masksToBounds = YES;
//    self.reportBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.reportBtn];
    
    self.labelContent = [UILabel new];
    self.labelContent.font = [UIFont fontWithName:@"Regular" size:14.0];
    self.labelContent.textColor = [UIColor colorWithHexString:@"#666666"];
    self.labelContent.numberOfLines = 5;
    [self.contentView addSubview:self.labelContent];
 

    self.labelMore = [UILabel new];
    self.labelMore.font = [UIFont systemFontOfSize:12.0f];
    self.labelMore.textColor = MAIN_COLOR;
    self.labelMore.textAlignment = NSTextAlignmentCenter;
    self.labelMore.userInteractionEnabled = YES;
    UITapGestureRecognizer *moreTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreTap)];
    [self.labelMore addGestureRecognizer:moreTap];
    [self.contentView addSubview:self.labelMore];
    
    self.multimediaView = [UIView new];
    [self.contentView addSubview:self.multimediaView];
    
    self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:SCREEN_WIDTH-40];
    [self.multimediaView addSubview:self.picContainerView];
    
    self.videoView = [SJPlayView new];
    self.videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.videoView.layer.cornerRadius = 8;
    self.videoView.layer.masksToBounds = YES;
    [self.multimediaView addSubview:self.videoView];
    
    self.repostView = [[YHWorkGroupRepostView alloc] init];
    [self.contentView addSubview:self.repostView];

    self.viewBottom = [[HKPBotView alloc] init];
    self.viewBottom.delegate = self;
    [self.contentView addSubview:self.viewBottom];

    self.viewSeparator = [UIView new];
    self.viewSeparator.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.contentView addSubview:self.viewSeparator];
        
    __weak typeof(self)weakSelf = self;

    for (UIView * view in self.contentView.subviews) {
        [self deleteConstraintWithView:view];
    }
    
    [self.imgvAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];

    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_top).offset(5);
        make.left.equalTo(weakSelf.imgvAvatar.mas_right).offset(10);
//        make.right.mas_equalTo(-15);
        make.height.equalTo(@15);
    }];

    [self.userLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.labelName.mas_centerY);
        make.left.equalTo(weakSelf.labelName.mas_right).offset(5);
        make.width.equalTo(@29);
        make.height.equalTo(@16);
    }];

    //时间
    [self.labelCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelName.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.labelName.mas_left);
        make.right.equalTo(@-15);
        make.height.equalTo(@11);
    }];

    //举报
//    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.imgvAvatar.mas_centerY);
//        make.right.equalTo(@-15);
//        make.width.equalTo(@50);
//        make.height.equalTo(@30);
//    }];

    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgvAvatar.mas_bottom).offset(10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
    }];

    // 不然在6/6plus上就不准确了
    self.labelContent.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;

    [self.labelMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.labelContent.mas_right);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(65);
        make.bottom.mas_equalTo(weakSelf.labelContent.mas_bottom).offset(-5);
    }];

    [self.multimediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.labelContent.mas_left);
        make.top.mas_equalTo(weakSelf.labelContent.mas_bottom).offset(12);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(194);
    }];

    [self.repostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.multimediaView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.labelContent.mas_left);
        make.right.equalTo(weakSelf.labelContent.mas_right);
    }];

    [self.viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repostView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@44);
    }];

    [self.viewSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewBottom.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)reportBtnClick:(UIButton *)sender
{
    UIButton * btn = sender;
    
    btn.selected = !btn.selected;
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    NSMutableArray * list = [NSMutableArray array];
    if (array != NULL)
    {
        list = [NSMutableArray arrayWithArray:array];
    }
    
    NSDictionary * userDic = @{@"avatar":self.model.userInfo.avatarUrl, @"id":self.model.userInfo.uid, @"nickname":self.model.userInfo.userName};
    if (btn.isSelected)
    {
        btn.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        if (![list containsObject:userDic])
        {
            [list addObject:userDic];
        }
    }
    else
    {
        btn.layer.borderColor = MAIN_COLOR.CGColor;
        
        if ([list containsObject:userDic])
        {
            [list removeObject:userDic];
        }
    }
    [YYToolModel saveUserdefultValue:list forKey:@"MyUserCommentList"];
}

- (void)setModel:(YHWorkGroup *)model
{
    _model = model;
    _model.isRepost = YES;
    [self.imgvAvatar sd_setImageWithURL:_model.userInfo.avatarUrl placeholderImage:[UIImage imageNamed:@"common_avatar_120px"]];
    self.labelName.text     = _model.userInfo.userName;
    self.labelCompany.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[_model.publishTime doubleValue]]];
    self.userLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@", _model.userInfo.user_level]];
    
    /*************动态内容*************/
    maxContentRepostLabelHeight   = _labelContent.font.pointSize * 6;
    self.labelContent.text = model.msgContent;
    
    if ([model.video isKindOfClass:[NSDictionary class]] && [model.video allValues].count > 0)
    {
        self.videoView.hidden = NO;
        self.picContainerView.hidden = YES;
        [self.videoView.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.video[@"videoImg"]] placeholderImage:MYGetImage(@"placehold_bg_image4")];
    }
    else
    {
        if (model.originalPicUrls.count > 0)
        {
            self.videoView.hidden = YES;
            self.picContainerView.hidden = NO;
        }
        else
        {
            self.videoView.hidden = YES;
            self.picContainerView.hidden = YES;
        }
    }
    NSDictionary * userDic = @{@"avatar":model.userInfo.avatarUrl, @"id":model.userInfo.uid, @"nickname":model.userInfo.userName};
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    if (array == NULL)
    {
        self.reportBtn.selected = NO;
        self.reportBtn.layer.borderColor = [UIColor colorWithHexString:@"FFC000"].CGColor;
    }
    else
    {
        self.reportBtn.selected = [array containsObject:userDic];
        self.reportBtn.layer.borderColor = [UIColor colorWithHexString:[array containsObject:userDic] ? @"#DEDEDE" : @"FFC000"].CGColor;
    }
    
    _viewBottom.tagLabel.text = [NSString stringWithFormat:@"  # %@ #  ", _model.themename];
    _viewBottom.commitCount.text = [NSString stringWithFormat:@"%d",_model.commentCount];
    
    _viewBottom.likeCount.text = [NSString stringWithFormat:@"%d",_model.likeCount];
    _viewBottom.dislikeCount.text = [NSString stringWithFormat:@"%d",_model.disagreeCount];
    
    _viewBottom.likeBtn.selected = _model.isAgreed;
    _viewBottom.dislikeBtn.selected = _model.isDisagreed;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTagTap)];
    [_viewBottom.tagLabel addGestureRecognizer:tap];
    
    self.repostView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    CGFloat contentHeight = [model.msgContent boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelContent.font} context:nil].size.height + 1;
    
    if (contentHeight > 110) {
        self.labelMore.hidden = NO;
        if (model.isOpening) {
            self.labelContent.text  = model.msgContent;
            self.labelMore.text = @"收起";
            self.labelContent.numberOfLines = 0;
            [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
            }];
        }else{
            self.labelMore.text = @"更多";
            // 计算第3行换行位置
            NSInteger index = 1;
            for (int i=0; i<model.msgContent.length; i++) {
                NSString * string = [model.msgContent substringWithRange:NSMakeRange(0, index)];
                CGFloat labelHeight = [string boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelContent.font} context:nil].size.height;
                
                if (labelHeight > 110) {
                    break;
                }else{
                    index ++;
                }
            }
            
            // 计算第二行截取长度
            NSInteger variable = 0;
            for (int i=index; i>0; i--) {
                NSString * string = [model.msgContent substringWithRange:NSMakeRange(i, index-i)];
                CGFloat stringWidth = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.labelContent.font} context:nil].size.width;
                if (stringWidth > 70) {
                    variable = index-i;
                    break;
                }
            }
            self.labelContent.numberOfLines = 5;
            self.labelContent.text = [NSString stringWithFormat:@"%@...",[model.msgContent substringWithRange:NSMakeRange(0, index-variable)]];
            [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(110);
            }];
        }
    }else{
        self.labelContent.text  = _model.msgContent;
        self.labelMore.hidden = YES;
        [self.labelContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
        }];
    }
    
    [self updateLayout];
    [self layoutIfNeeded];
    
    
}

- (void)updateLayout{
    [self deleteConstraintWithView:self.multimediaView];
    [self deleteConstraintWithView:self.picContainerView];
    [self deleteConstraintWithView:self.videoView];
    [self deleteConstraintWithView:self.repostView];
    if ([self.model.video isKindOfClass:[NSDictionary class]] && [self.model.video allValues].count > 0)
    {
        // 视频样式
        
        CGFloat videoWidth = [self.model.video[@"width"] floatValue];
        CGFloat videoHeight = [self.model.video[@"height"] floatValue];
        
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        [self.multimediaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labelContent.mas_bottom).offset(12);
            make.left.mas_equalTo(self.labelContent.mas_left);
            if (videoWidth < videoHeight) {
                make.height.mas_equalTo(194);
                make.width.mas_equalTo(194*videoWidth/videoHeight);
            }else{
                if (videoWidth > ScreenWidth - 30) {
                    make.right.mas_equalTo(self.labelContent.mas_right);
                    make.height.mas_equalTo((ScreenWidth-30)*videoHeight/videoWidth);
                }else{
                    make.height.mas_equalTo(194);
                    make.width.mas_equalTo(194*videoWidth/videoHeight);
                }
            }
        }];
        
    }
    else
    {
        if (self.model.originalPicUrls.count > 0)
        {
            self.picContainerView.picOriArray = _model.originalPicUrls;
            self.picContainerView.picUrlArray = _model.thumbnailPicUrls;
            [self.multimediaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.labelContent.mas_bottom).offset(12);
                make.left.mas_equalTo(self.labelContent.mas_left);
                make.width.mas_equalTo(self.labelContent.mas_width);
                if (self.model.originalPicUrls.count == 1) {
                    make.height.mas_equalTo(120);
                }else{
                    NSInteger itemHeight = (ScreenWidth-40)/3;
                    if (self.model.originalPicUrls.count <= 3) {
                        make.height.mas_equalTo(itemHeight);
                    }else if (self.model.originalPicUrls.count > 3 && self.model.originalPicUrls.count <= 6){
                        make.height.mas_equalTo(itemHeight * 2);
                    }else{
                        make.height.mas_equalTo(itemHeight * 3);
                    }
                }
            }];
            
            [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.mas_equalTo(0);
            }];
            
        }else{
            [self.multimediaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.labelContent.mas_bottom);
                make.left.mas_equalTo(self.labelContent.mas_left);
                make.height.mas_equalTo(0);
                make.width.mas_equalTo(self.labelContent.mas_width);
            }];
        }
    }
    
    if (self.model.commentsCell == 0) {
        self.repostView.forwardModel = _model.forwardModel;
        [self.repostView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.multimediaView.mas_bottom).offset(10);
            make.left.equalTo(self.labelContent.mas_left);
            make.right.equalTo(self.labelContent.mas_right);
            make.bottom.mas_equalTo(self.viewBottom.mas_top);
        }];
    }else {
        [self.repostView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.multimediaView.mas_bottom);
            make.left.equalTo(self.labelContent.mas_left);
            make.right.equalTo(self.labelContent.mas_right);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.viewBottom.mas_top);
        }];
    }
}

- (void)deleteConstraintWithView:(UIView *)view{
    NSArray *array = [MASViewConstraint installedConstraintsForView:view];
    for (MASConstraint *constraint in array) {
        [constraint uninstall];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Action
- (void)onMoreTap
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onMoreInRespostCell:)]) {
        [_delegate onMoreInRespostCell:self];
    }
}

- (void)deleteTap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteInRepostCell:)]) {
        [_delegate onDeleteInRepostCell:self];
    }
}

#pragma mark - Gesture

- (void)onAvatar:(UITapGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if (_delegate && [_delegate respondsToSelector:@selector(onAvatarInRepostCell:)]) {
            [_delegate onAvatarInRepostCell:self];
        }
    }
}

#pragma mark - HKPBotViewDelegate
- (void)onAvatar{
    
}

- (void)onMore{
    
}

- (void)onComment{
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentInRepostCell:)]) {
        [_delegate onCommentInRepostCell:self];
    }
}

- (void)onLike{
    NSLog(@"-----------------------------onLike");
    if (_delegate && [_delegate respondsToSelector:@selector(onLikeInRepostCell:)]) {
        [_delegate onLikeInRepostCell:self];
    }
}

- (void)onShare{
    if (_delegate && [_delegate respondsToSelector:@selector(onShareInRepostCell:)]) {
        [_delegate onShareInRepostCell:self];
    }
}

- (void)onTagTap{
    if (_delegate && [_delegate respondsToSelector:@selector(onTagTapRespostCell:)]) {
        [_delegate onTagTapRespostCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
