//
//  AuthAlertView.m
//  Game789
//
//  Created by maiyou on 2021/9/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "AuthAlertView.h"
#import "EditUserInfoApi.h"

@interface AuthAlertView ()

@property(nonatomic,weak)IBOutlet UITextField * name;
@property(nonatomic,weak)IBOutlet UITextField * code;
@property(nonatomic,weak)IBOutlet UILabel * topLabel;
@property(nonatomic,weak)IBOutlet UILabel * bottomLabel;
@property(nonatomic,weak)id<AuthAlertViewDelegate>delegate;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *centery;


@end

@implementation AuthAlertView

+ (void)showAuthAlertViewWithDelegate:(id<AuthAlertViewDelegate>)delegate{
    AuthAlertView * alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    alertView.delegate = delegate;
    alertView.topLabel.text = DeviceInfo.shareInstance.authConfirmTopTips;
    alertView.bottomLabel.text = DeviceInfo.shareInstance.authConfirmBottomTips;
    [[NSNotificationCenter defaultCenter] addObserver:alertView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:alertView selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    [alertView show];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    CGFloat keyboardHeight = [[notification.object objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:[[notification.object objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.centery.constant = keyboardHeight-78;
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden{
    [UIView animateWithDuration:0.25 animations:^{
        self.centery.constant = 0;
        [self layoutIfNeeded];
    }];
}

- (IBAction)auth:(id)sender{
    EditUserInfoApi *api = [[EditUserInfoApi alloc] init];
    BOOL realName = [self validateNickname:self.name.text];
    if (realName == YES) {
        api.real_name = self.name.text;
    }else{
        [MBProgressHUD showToast:@"格式错误，请重新输入"];
        return;
    }
    if (self.code.text.length == 0) {
        [MBProgressHUD showToast:@"请输入身份证号"];
        return;
    }
    api.pageNumber = 1;
    api.isShow = YES;
    api.identity_card = self.code.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleNoticeSuccess:(EditUserInfoApi *)api {
    if (api.success == 1) {
        
        NSString * toast = @"提交成功";
        [YJProgressHUD showSuccess:toast inview:self];
        
        [self requestUserInfo];
        
    }
    else {
        [MBProgressHUD showToast:api.error_desc];
    }
}
    
- (void)requestUserInfo{
    GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
    
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleUserSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleUserSuccess:(GetUserInfoApi *)api
{
    if (api.success == 1)
    {
        NSDictionary * dic = api.data[@"member_info"] ;
        [YYToolModel saveUserdefultValue:[dic deleteAllNullValue] forKey:@"member_info"];
        
        //判定是否回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(onAuthSuccess)]) {
            [self.delegate onAuthSuccess];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSetMemberInfoSuccess" object:nil];
        
    }
}

- (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

- (void)show{
    [self showAnimationWithSpace:25];
}

- (IBAction)dismiss{
    [self dismissAnimation];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
