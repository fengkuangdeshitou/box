//
//  CommitReplyView.m
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "CommitReplyView.h"
#import "CommentApi.h"
#import "MyCommunityRequestApi.h"

@class CommentForCommentApi;
@class MyCommunityAppraisalApi;

@implementation CommitReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self creatBottomView];
        
        //键盘的frame即将发生变化时立刻发出该通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

- (void)setReply_placeHolder:(NSString *)reply_placeHolder
{
    _reply_placeHolder = reply_placeHolder;
    
    self.enterText.zw_placeHolder = [NSString stringWithFormat:@"%@ %@%@:", @"回复".localized, reply_placeHolder, @"的评论".localized];
}

- (void)creatBottomView
{
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 50, kScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton * sendMgs = [UIControl creatButtonWithFrame:CGRectMake(bottomView.width - 60, 0, 50, bottomView.height) backgroundColor:[UIColor clearColor] title:@"发布".localized titleFont:[UIFont systemFontOfSize:14] actionBlock:^(UIControl *control) {
        [self sendMgsAction:(UIButton *)control];
    }];
    [sendMgs setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0];
    sendMgs.enabled = NO;
    [bottomView addSubview:sendMgs];
    self.sendMessage = sendMgs;
    
    UITextView * enterText = [[UITextView alloc] initWithFrame:CGRectMake(20, 8, sendMgs.left - 30, bottomView.height - 8 * 2)];
    enterText.zw_placeHolder = @"向Ta请教...".localized;
    enterText.backgroundColor = FontColorF6;
    enterText.layer.cornerRadius = enterText.height / 2;
    enterText.layer.masksToBounds = YES;
    enterText.delegate = self;
    enterText.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    enterText.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:enterText];
    self.enterText = enterText;
    [enterText becomeFirstResponder];
}

- (void)keyboardChanged:(NSNotification *)notification{
    
    CGRect frame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];

    CGRect currentFrame=self.bottomView.frame;

    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        
        if (frame.origin.y == kScreenH)
        {
            resultFrame=CGRectMake(currentFrame.origin.x, kScreenH - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=0;
        }
        else
        {
            resultFrame=CGRectMake(currentFrame.origin.x, kScreenH-currentFrame.size.height-frame.size.height-64- (IS_IPhoneX_All ? 23 : 0), currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=frame.size.height+64+(IS_IPhoneX_All ? 23 : 0);
        }
        self.bottomView.frame=resultFrame;
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    //限制字数不能超过200
    if (str.length > 200)
    {
        textView.text = [str substringWithRange:NSMakeRange(0, 200)];
    }
    
    (str.length == 0) ? ([self.sendMessage setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0]) : ([self.sendMessage setTitleColor:[UIColor orangeColor] forState:0]);
    (str.length == 0) ? (self.sendMessage.enabled = NO) : (self.sendMessage.enabled = YES);
    
    CGSize maxSize = CGSizeMake(textView.bounds.size.width, MAXFLOAT);
    //测量string的大小
    CGRect frame = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
    //设置self.textView的高度，默认是30
    CGFloat tarHeight = 34;
    //如果文本框内容的高度+10大于30也就是初始的self.textview的高度的话，设置tarheight的大小为文本的内容+10，其中10是文本框和背景view的上下间距；
    if (frame.size.height > 34) {
        tarHeight=frame.size.height;
    }
    //如果self.textView的高度大于200时，设置为200，即最高位200
    if (tarHeight>100) {
        tarHeight = 100;
        self.tabHeight = tarHeight;
    }
    
    if (self.tabHeight != tarHeight)
    {
        [UIView animateWithDuration:0.2 animations:^{
            //设置输入框背景的frame
            self.bottomView.frame = CGRectMake(0, (kScreenH - self.keyboardHeight) - tarHeight - 16, kScreenW, tarHeight + 16);
            //设置输入框的frame
            self.enterText.frame=CGRectMake(20,(self.bottomView.height-tarHeight)/2 , self.enterText.width, tarHeight);
        }];
        self.tabHeight = tarHeight;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
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

- (void)sendMgsAction:(UIButton *)sender
{
    NSString * content = [self.enterText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    if (content.length < 3)
    {
        [MBProgressHUD showToast:@"回复评论字数不少于3个".localized];
        return;
    }
    
    if (self.isCommunity)
    {
        [self communityAppraisal];
    }
    else
    {
        [self gameCommetDetailAppraisal];
    }
}

- (void)communityAppraisal
{
    MyCommunityAppraisalApi * api = [[MyCommunityAppraisalApi alloc] init];
    api.isShow = YES;
    api.content = self.enterText.text;
    api.replyid = self.reply_id;
    api.detailId = self.comment_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSString * tip = @"发布成功,后台正在审核中".localized;
            [YJProgressHUD showSuccess:tip inview:YYToolModel.getCurrentVC.view];
            self.commentSuccess(self.enterText.text);
            [self hiddenView];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)gameCommetDetailAppraisal
{
    CommentForCommentApi * api = [[CommentForCommentApi alloc] init];
    api.isShow = YES;
    api.comment_id = self.comment_id;
    api.reply_id   = self.reply_id;
    api.content    = self.enterText.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSString * tip = @"发布成功".localized;
            if (self.reply_id.length == 0)
            {
                tip = @"评论发表成功,后台正在审核中".localized;
            }
            [YJProgressHUD showSuccess:tip inview:YYToolModel.getCurrentVC.view];
            self.commentSuccess(self.enterText.text);
            [self hiddenView];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
