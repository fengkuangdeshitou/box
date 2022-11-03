//
//  MySubmitConsultView.m
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MySubmitConsultView.h"
#import "MyGetQuestionApi.h"

@implementation MySubmitConsultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySubmitConsultView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        [self.enterContent becomeFirstResponder];
        self.enterContent.delegate = self;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setIsConsultDetail:(BOOL)isConsultDetail
{
    _isConsultDetail = isConsultDetail;
    if (isConsultDetail)
    {
        self.enterContent.zw_placeHolder = @"这个游戏我玩过，我来说说！".localized;
        self.noticeLabel.text = @"乐于助人的人，运气都不会差哦~".localized;
        self.noticeLabel1.text = @"".localized;
        self.playedCount.text = @"".localized;
    }
    else
    {
        self.enterContent.zw_placeHolder = @"5-100字范围内，请准确描述您的问题吧~".localized;
        self.noticeLabel.text = @"向".localized;
        self.noticeLabel1.text = @"位玩过该游戏的人请教".localized;
        self.playedCount.text = self.playedGameCount;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:[[notification.object objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.entryView_bottom.constant = -(keyboardHeight-kTabbarSafeBottomMargin);
//        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.entryView_bottom.constant = 0;
//        [self layoutIfNeeded];
    }];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self hiddenView];
    return YES;
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    //限制字数不能超过100
    if (str.length > 100)
    {
        textView.text = [str substringWithRange:NSMakeRange(0, 100)];
    }
}

- (IBAction)submitMgsClick:(id)sender
{
    NSString * content = [self.enterContent.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (content.length < 5)
    {
        [MBProgressHUD showToast:@"回复评论字数不少于5个"];
        return;
    }
    
    if (self.isConsultDetail)
    {//提交答案
        [self submitAnswer];
    }
    else
    {//提交问题
        [self submitQuestion];
    }
}

#pragma mark - 提交问题
- (void)submitQuestion
{
    MyGSubmitQuestionApi * api = [[MyGSubmitQuestionApi alloc] init];
    api.gameId = self.gameId;
    api.question = self.enterContent.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self submitTextSuccess:YES];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 提交回答
- (void)submitAnswer
{
    MySubmitAnswerApi * api = [[MySubmitAnswerApi alloc] init];
    api.questionId = self.questionId;
    api.content = self.enterContent.text;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [self submitTextSuccess:NO];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)submitTextSuccess:(BOOL)isQues
{
    [self hiddenView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.submitText) self.submitText(isQues);
    });
}


@end
