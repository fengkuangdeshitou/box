//
//  HKPBotView.m
//  HKPTimeLine  仿赤兔、微博动态
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/9/20.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "HKPBotView.h"
#import "YHWorkGroupButton.h"

@interface HKPBotView()
//@property (nonatomic,strong) UIView *viewTopLine;//顶部横线
//@property (nonatomic,strong) UIView *viewVLine1;//竖线1
//@property (nonatomic,strong) UIView *viewVLine2;//竖线2


//@property (nonatomic, strong) UILabel *tagLabel;
//// 点赞数量
//@property (nonatomic, strong) UIButton *likeBtn;
//@property (nonatomic, strong) UILabel  *likeCount;
//// 评论数量
//@property (nonatomic, strong) UIButton *commitBtn;
//@property (nonatomic, strong) UILabel  *commitCount;
//// 反对数量
//@property (nonatomic, strong) UIButton *dislikeBtn;
//@property (nonatomic, strong) UILabel  *dislikeCount;

@end

@implementation HKPBotView

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setup {
    
//    UIView *viewTopLine = [UIView new];
//    viewTopLine.backgroundColor = RGBCOLOR(222, 222, 222);
//    [self addSubview:viewTopLine];
//    self.viewTopLine = viewTopLine;
//    self.viewTopLine.hidden = YES;
    
    _tagLabel = [[UILabel alloc]init];
    _tagLabel.font = [UIFont systemFontOfSize:13];
    _tagLabel.text = @"#传奇游戏超级好玩#";
    _tagLabel.textColor = MAIN_COLOR;
    _tagLabel.layer.cornerRadius = 12;
    _tagLabel.layer.masksToBounds = YES;
    _tagLabel.userInteractionEnabled = YES;
     [_tagLabel sizeToFit];
    _tagLabel.backgroundColor = [UIColor clearColor];
     [self addSubview:_tagLabel];
    
    //点赞
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
    
    //不喜欢
    _dislikeCount = [[UILabel alloc] init];
    _dislikeCount.font = [UIFont systemFontOfSize:13];
    _dislikeCount.text = @"0";
    _dislikeCount.textColor = [UIColor colorWithHexString:@"#666666"];
    [_dislikeCount sizeToFit];
    [self addSubview:_dislikeCount];
    
    _dislikeBtn = [[UIButton alloc]init];
    [_dislikeBtn setImage:[UIImage imageNamed:@"comment_disagree_icon"] forState:0];
    [_dislikeBtn setImage:[UIImage imageNamed:@"comment_disagreed_icon"] forState:UIControlStateSelected];
    [_dislikeBtn addTarget:self action:@selector(dislikeCountClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dislikeBtn];
    
    //评论
    _commitCount = [[UILabel alloc] init];
    _commitCount.font = [UIFont systemFontOfSize:13];
    _commitCount.text = @"0";
    _commitCount.textColor = [UIColor colorWithHexString:@"#666666"];
    [_commitCount sizeToFit];
    [self addSubview:_commitCount];
    
    _commitBtn = [[UIButton alloc]init];
    [_commitBtn setImage:[UIImage imageNamed:@"lhh_home_msg"] forState:0];
    [_commitBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    //    _commitBtn.enabled = NO;
    [_commitBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commitBtn];
    
    
    [self layoutUI];
}

- (void)layoutUI{
    
    for (UIView * view in self.subviews) {
        NSArray * array = [MASViewConstraint installedConstraintsForView:view];
        for (MASConstraint * constraint in array) {
            [constraint uninstall];
        }
    }
    
    __weak typeof(self) weakSelf = self;

    //评论
    [self.commitCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.commitCount.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    //不喜欢
    [self.dislikeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.commitBtn.mas_left).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.dislikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dislikeCount.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    //喜欢
    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dislikeBtn.mas_left).offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.likeCount.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.mas_lessThanOrEqualTo(self.likeBtn.mas_left).offset(-10);
        make.height.equalTo(@24);
    }];
    
    [self.tagLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}


#pragma mark - Action

- (void)commentBtnClicked:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onShare)]) {
        [_delegate onShare];
    }
    
}

- (void)likeCountClicked:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onLike)]) {
        [_delegate onLike];
    }
}

- (void)dislikeCountClicked:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onComment)]) {
        [_delegate onComment];
    }
}


@end
