//
//  CommentsPopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "CommentsPopView.h"
#import "MenuPopView.h"
#import "LoadMoreControl.h"
#import "NetworkHelper.h"
#import "MyComment.h"
#import "CommitDetailView.h"

NSString * const kCommentListCell     = @"CommentListCell";
NSString * const kCommentHeaderCell   = @"CommentHeaderCell";
NSString * const kCommentFooterCell   = @"CommentFooterCell";

@interface CommentsPopView () <UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,UIScrollViewDelegate, CommentTextViewDelegate>

@property (nonatomic, assign) NSString                         *awemeId;
@property (nonatomic, strong) Visitor                          *vistor;

@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) UIView                           *container;
@property (nonatomic, strong) UITableView                      *tableView;
@property (nonatomic, strong) NSMutableArray<MyComment *>        *data;
@property (nonatomic, strong) CommentTextView                  *textView;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;
@property (nonatomic, strong) CommitDetailView * commitView;

@end


@implementation CommentsPopView

- (instancetype)initWithAwemeId:(NSDictionary *)dataDic {
    self = [super init];
    if (self) {
        self.frame = ScreenFrame;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        _dataDic = dataDic;
        _awemeId = @"";
        _vistor = readVisitor();
        
        _pageIndex = 0;
        _pageSize = 20;
        
        _data = [NSMutableArray array];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight*3/4)];
        _container.backgroundColor = ColorWhite;
        [self addSubview:_container];
        
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight*3/4) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
//        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//        visualEffectView.frame = self.bounds;
//        visualEffectView.alpha = 1.0f;
//        [_container addSubview:visualEffectView];
        
        
        _label = [[UILabel alloc] init];
        _label.textColor = ColorBlack;
        _label.text = [NSString stringWithFormat:@"%@条评论", dataDic[@"game_comment_num"]];
        _label.font = MediumFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:_label];
        
        _close = [[UIImageView alloc] init];
        _close.image = [UIImage imageNamed:@"icon_closetopic"];
        _close.contentMode = UIViewContentModeCenter;
        [_close addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        [_container addSubview:_close];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.container);
            make.height.mas_equalTo(35);
        }];
        [_close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.label);
            make.right.equalTo(self.label).inset(10);
            make.width.height.mas_equalTo(30);
        }];
        
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight*3/4 - 35 - 50 - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = ColorClear;
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:CommentListCell.class forCellReuseIdentifier:kCommentListCell];
        
        WEAKSELF
        _commitView = [[CommitDetailView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight*3/4 - 35 - 50 - SafeAreaBottomHeight) TopicId:self.dataDic[@"comment_topic_id"]];
        _commitView.game_name = self.dataDic[@"game_name"];
        _commitView.isFooterHidden = YES;
        _commitView.currentVC = self.currentVC;
        _commitView.commitData = ^(NSArray *commentList, NSString *commitTotal) {
            
        };
        _commitView.hiddenCommitPopView = ^(BOOL isHidden) {
            if (isHidden)
            {
                [weakSelf dismiss];
            }
        };
        [_container addSubview:_commitView];
        
//        _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:10];
//        [_loadMore startLoading];
//        __weak __typeof(self) wself = self;
//        [_loadMore setOnLoad:^{
//            [wself loadData:wself.pageIndex pageSize:wself.pageSize];
//        }];
//        [_tableView addSubview:_loadMore];
        
//        [_container addSubview:_tableView];
        
        _textView = [CommentTextView new];
        _textView.delegate = self;
    }
    return self;
}

- (void)setCurrentVC:(UIViewController *)currentVC
{
    _currentVC = currentVC;
    
    _commitView.currentVC = currentVC;
    _textView.currentVC   = currentVC;
}

// comment textView delegate
- (void)onSendText:(NSString *)text
{
    NSString * content = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (content.length < 10)
    {
        [MBProgressHUD showToast:@"评论字数不少于10个".localized];
        return;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    NSDictionary * parmaDic = @{@"topic_id":self.dataDic[@"comment_topic_id"],
                                @"device_id":[DeviceInfo shareInstance].deviceType,
                                @"content":text,
                                @"member_id":userID};
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", Base_Request_Url, @"base/comment/add"];
    [SwpNetworking swpPOSTAddFiles:urlstr parameters:parmaDic fileName:@"pic_screenshots" fileDatas:@[] swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject)
     {
         if ([resultObject[@"status"][@"succeed"] integerValue] == 1)
         {
             [MBProgressHUD showToast:@"评论发表成功,后台正在审核中"];
         }
         else
         {
             [MBProgressHUD showToast:resultObject[@"status"][@"error_desc"]];
         }
     } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
         
     }];
}

- (void)dismissCommentsPopView
{
    [self dismiss];
}

// tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CommentListCell cellHeight:_data[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentListCell];
    [cell initData:_data[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyComment *comment = _data[indexPath.row];
    if(!comment.isTemp && [@"visitor" isEqualToString:comment.user_type] && [MD5_UDID isEqualToString:comment.visitor.udid]) {
        MenuPopView *menu = [[MenuPopView alloc] initWithTitles:@[@"删除"]];
        __weak __typeof(self) wself = self;
        menu.onAction = ^(NSInteger index) {
            [wself deleteComment:comment];
        };
        [menu show];
    }
}

//delete comment
- (void)deleteComment:(MyComment *)comment {
    __weak __typeof(self) wself = self;
    DeleteCommentRequest *request = [DeleteCommentRequest new];
    request.cid = comment.cid;
    request.udid = UDID;
    [NetworkHelper deleteWithUrlPath:DeleteComentByIdPath request:request success:^(id data) {
        NSInteger index = [wself.data indexOfObject:comment];
        [wself.tableView beginUpdates];
        [wself.data removeObjectAtIndex:index];
        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [wself.tableView endUpdates];
        [UIWindow showTips:@"评论删除成功"];
    } failure:^(NSError *error) {
        [UIWindow showTips:@"评论删除失败"];
    }];
}

//guesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%@", NSStringFromClass([touch.view.superview class]));
    NSString * str = NSStringFromClass([touch.view.superview class]);
    if ([str isEqualToString:@"CommentListCell"]) {
        return NO;
    } else if ([str isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } else if ([str isEqualToString:@"CommentLabel"]) {
           return NO;
    } else if ([str isEqualToString:@"MomentCell"]) {
              return NO;
    } else {
        return YES;
    }
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_close];
    if([_close.layer containsPoint:point]) {
        [self dismiss];
    }
}

//update method
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    [self.textView show];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.textView dismiss];
                     }];
}

//UIScrollViewDelegate Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < 0) {
        self.frame = CGRectMake(0, -offsetY, self.frame.size.width, self.frame.size.height);
    }
    if (scrollView.isDragging && offsetY < -50) {
        [self dismiss];
    }
}
@end


#pragma comment tableview cell

#define MaxContentWidth     ScreenWidth - 55 - 35
//cell
@implementation CommentListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorClear;
        self.clipsToBounds = YES;
        _avatar = [[UIImageView alloc] init];
        _avatar.image = [UIImage imageNamed:@"img_find_default"];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 14;
        [self addSubview:_avatar];
        
        _likeIcon = [[UIImageView alloc] init];
        _likeIcon.contentMode = UIViewContentModeCenter;
        _likeIcon.image = [UIImage imageNamed:@"icCommentLikeBefore_black"];
        [self addSubview:_likeIcon];
        
        _nickName = [[UILabel alloc] init];
        _nickName.numberOfLines = 1;
        _nickName.textColor = ColorWhiteAlpha60;
        _nickName.font = SmallFont;
        [self addSubview:_nickName];
        
        _content = [[UILabel alloc] init];
        _content.numberOfLines = 0;
        _content.textColor = ColorWhiteAlpha80;
        _content.font = MediumFont;
        [self addSubview:_content];
        
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 1;
        _date.textColor = ColorGray;
        _date.font = SmallFont;
        [self addSubview:_date];
        
        _likeNum = [[UILabel alloc] init];
        _likeNum.numberOfLines = 1;
        _likeNum.textColor = ColorGray;
        _likeNum.font = SmallFont;
        [self addSubview:_likeNum];
        
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = ColorWhiteAlpha10;
        [self addSubview:_splitLine];
        
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).inset(15);
            make.width.height.mas_equalTo(28);
        }];
        [_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self).inset(15);
            make.width.height.mas_equalTo(20);
        }];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.right.equalTo(self.likeIcon.mas_left).inset(25);
        }];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickName.mas_bottom).offset(5);
            make.left.equalTo(self.nickName);
            make.width.mas_lessThanOrEqualTo(MaxContentWidth);
        }];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(5);
            make.left.right.equalTo(self.nickName);
        }];
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.likeIcon);
            make.top.equalTo(self.likeIcon.mas_bottom).offset(5);
        }];
        [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.date);
            make.right.equalTo(self.likeIcon);
            make.top.equalTo(self.date.mas_bottom).offset(9.5);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return self;
}

-(void)initData:(MyComment *)comment {
    NSURL *avatarUrl;
    if([@"user" isEqualToString:comment.user_type]) {
        avatarUrl = [NSURL URLWithString:comment.user.avatar_thumb.url_list.firstObject];
        _nickName.text = comment.user.nickname;
    }else {
        avatarUrl = [NSURL URLWithString:comment.visitor.avatar_thumbnail.url];
        _nickName.text = [comment.visitor formatUDID];
    }
    
    __weak __typeof(self) wself = self;
    [_avatar setImageWithURL:avatarUrl completedBlock:^(UIImage *image, NSError *error) {
        image = [image drawCircleImage];
        wself.avatar.image = image;
    }];
    _content.text = comment.text;
    _date.text = [NSDate formatTime:comment.create_time];
    _likeNum.text = [NSString formatCount:comment.digg_count];
    
}

+(CGFloat)cellHeight:(MyComment *)comment {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comment.text];
    [attributedString addAttribute:NSFontAttributeName value:MediumFont range:NSMakeRange(0, attributedString.length)];
    CGSize size = [attributedString multiLineSize:MaxContentWidth];
    return size.height + 30 + SmallFont.lineHeight * 2;
}
@end







#pragma TextView

static const CGFloat kCommentTextViewLeftInset               = 15;
static const CGFloat kCommentTextViewRightInset              = 60;
static const CGFloat kCommentTextViewTopBottomInset          = 15;

@interface CommentTextView ()<UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat            textHeight;
@property (nonatomic, assign) CGFloat            keyboardHeight;
@property (nonatomic, retain) UILabel            *placeholderLabel;
@end

@implementation CommentTextView
- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = ScreenFrame;
        self.backgroundColor = ColorClear;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - SafeAreaBottomHeight, ScreenWidth, 50 + SafeAreaBottomHeight)];
        _container.backgroundColor = ColorWhite;
        [self addSubview:_container];
        
        _keyboardHeight = SafeAreaBottomHeight;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _textView.backgroundColor = ColorClear;
        _textView.clipsToBounds = NO;
        _textView.textColor = ColorBlack;
        _textView.font = MediumBoldFont;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(kCommentTextViewTopBottomInset, kCommentTextViewLeftInset, kCommentTextViewTopBottomInset, kCommentTextViewRightInset);
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.zw_placeHolder = @"亲，点评内容不少于10个字哦";
        _textHeight = ceilf(_textView.font.lineHeight);
        _textView.delegate = self;
        [_container addSubview:_textView];
        
        _sendButton = [[UIButton alloc] init];
        _sendButton.frame = CGRectMake(kScreenW - 45, 0, 30, 50);
        [_sendButton setTitle:@"发送" forState:0];
        [_sendButton setTitleColor:ORANGE_COLOR forState:0];
        _sendButton.titleLabel.font = MediumBoldFont;
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_textView addSubview:_sendButton];
        
//        _placeholderLabel = [[UILabel alloc]init];
//        _placeholderLabel.text = @"亲，点评内容不少于10个字哦";
//        _placeholderLabel.textColor = ColorBlackAlpha40;
//        _placeholderLabel.font = MediumBoldFont;
//        _placeholderLabel.frame = CGRectMake(kCommentTextViewLeftInset, 0, ScreenWidth - kCommentTextViewLeftInset - kCommentTextViewRightInset, 50);
//        [_textView addSubview:_placeholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    _container.layer.mask = shape;
    
    [self updateTextViewFrame];
}


- (void)updateTextViewFrame {
    CGFloat textViewHeight = _keyboardHeight > SafeAreaBottomHeight ? _textHeight + 2*kCommentTextViewTopBottomInset : ceilf(_textView.font.lineHeight) + 2*kCommentTextViewTopBottomInset;
    _textView.frame = CGRectMake(0, 0, ScreenWidth, textViewHeight);
    _container.frame = CGRectMake(0, ScreenHeight - _keyboardHeight - textViewHeight, ScreenWidth, textViewHeight + _keyboardHeight);
}

//keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardHeight = [notification keyBoardHeight];
    [self updateTextViewFrame];
    _container.backgroundColor = ColorWhite;
    _textView.textColor = ColorBlack;
    self.backgroundColor = ColorBlackAlpha60;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = SafeAreaBottomHeight;
    [self updateTextViewFrame];
    _container.backgroundColor = ColorWhite;
    _textView.textColor = ColorBlack;
    self.backgroundColor = ColorClear;
}

//textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    if(!textView.hasText) {
//        [_placeholderLabel setHidden:NO];
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
//        [_placeholderLabel setHidden:YES];
        _textHeight = [attributedText multiLineSize:ScreenWidth - kCommentTextViewLeftInset - kCommentTextViewRightInset].height;
    }
    [self updateTextViewFrame];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if(_delegate) {
            [_delegate onSendText:textView.text];
//            [_placeholderLabel setHidden:NO];
            textView.text = @"";
            _textHeight = ceilf(textView.font.lineHeight);
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![YYToolModel islogin])
    {
        if (self.delegate)
        {
            [self.delegate dismissCommentsPopView];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LoginViewController * login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:login animated:YES];
        });
        return NO;
    }
    return YES;
}

- (void)sendButtonClick:(UIButton *)sender
{
    if(_delegate)
    {
        [_delegate onSendText:_textView.text];
//            [_placeholderLabel setHidden:NO];
        _textView.text = @"";
        _textHeight = ceilf(_textView.font.lineHeight);
        [_textView resignFirstResponder];
    }
}

//handle guesture tap
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_textView];
    if(![_textView.layer containsPoint:point]) {
        [_textView resignFirstResponder];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if(hitView.backgroundColor == ColorClear) {
            return nil;
        }
    }
    return hitView;
}

//update method
- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

