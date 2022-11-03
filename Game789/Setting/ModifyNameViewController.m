//
//  ForgotPwdViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "ModifyNameViewController.h"
#import "MBProgressHUD+QNExtension.h"
#import "NSString+Phone.h"

#import "EditUserInfoApi.h"

#define NUMBERS @"0123456789X"

@interface ModifyNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GameTextField *userName;
@property (weak, nonatomic) IBOutlet GameTextField *passWord;
@property (weak, nonatomic) IBOutlet GameTextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (assign, nonatomic) BOOL status;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterMobile_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButton_top;
@end

@implementation ModifyNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = self.title;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];

    self.labelText.textColor = [UIColor blackColor];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
    if ([self.title isEqualToString:@"昵称".localized]){
        self.labelText.text = @"昵称".localized;
        self.userName.placeholder = @"请输入昵称".localized;
        self.userName.text = dic[@"nick_name"];
        
        self.labelText1.hidden = YES;
        self.passWord.hidden = YES;
        self.lineView.hidden = YES;
        self.iconImage.hidden = YES;
        self.sendButton_top.constant = -20;
    }
    else if ([self.title isEqualToString:@"实名认证".localized])
    {
        self.labelText.text = @"姓名".localized;
        self.userName.placeholder = @"请输入姓名".localized;
        self.userName.text = dic[@"real_name"];
        self.passWord.keyboardType = UIKeyboardTypeASCIICapable;
        self.passWord.text = dic[@"identity_card"];
        self.passWord.delegate = self;
    }
    else if ([self.title isEqualToString:@"QQ".localized]){
        self.labelText.text = @"QQ".localized;
        self.userName.placeholder = @"请输入QQ".localized;
        self.userName.text = dic[@"qq"];
        self.userName.keyboardType = UIKeyboardTypeNumberPad;
        [self.userName addTarget:self action:@selector(enterQQValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.labelText1.hidden = YES;
        self.passWord.hidden = YES;
        self.lineView.hidden = YES;
        self.iconImage.hidden = YES;
        self.sendButton_top.constant = -20;
    }
    self.enterMobile_top.constant = kStatusBarAndNavigationBarHeight + 30;
}

- (void)modifyInfoRequest
{
    if (self.userName.text.length == 0) {
        [MBProgressHUD showToast:self.userName.placeholder];
        return;
    }
    
    if (self.passWord.text.length == 0 && [self.title isEqualToString:@"实名认证".localized])
    {
        [MBProgressHUD showToast:@"请输入身份证号".localized];
        return;
    }
    
    EditUserInfoApi *api = [[EditUserInfoApi alloc] init];
    if ([self.title isEqualToString:@"实名认证".localized]) {
        BOOL realName = [self validateNickname:self.userName.text];
        if (realName == YES) {
            api.real_name = self.userName.text;
            self.status = YES;
        }else{
            [MBProgressHUD showToast:@"格式错误，请重新输入"];
            return;
        }
        
    }
    else if ([self.title isEqualToString:@"昵称".localized]) {
        
        if (self.userName.text.length < 9 && self.userName.text.length > 0)
        {
            api.nick_name = self.userName.text;
            self.status = YES;
        }
        else
        {
            [MBProgressHUD showToast:@"昵称长度不能大于9个字".localized];
            return;
        }
    }
    
    if ([self.title isEqualToString:@"实名认证".localized]) {
        
        if (self.passWord.text.length == 15 || self.passWord.text.length == 18) {
            api.identity_card = self.passWord.text;
            self.status = YES;
        }else{
           [MBProgressHUD showToast:@"身份证号格式错误".localized];
            return;
        }
    }
    
    if ([self.title isEqualToString:@"QQ".localized]) {
        
        if (self.userName.text.length > 0) {
            api.qq = self.userName.text;
            self.status = YES;
        }else{
            [MBProgressHUD showToast:@"请输入QQ".localized];
            return;
        }
    }
    api.pageNumber = self.pageNumber;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleNoticeSuccess:(EditUserInfoApi *)api {
    if (api.success == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];
        NSString * toast = @"提交成功";
        if ([self.title isEqualToString:@"实名认证".localized]) {
            //判定是否是正常状态的数据，否则不提交；
            if (self.status == YES) {
                 [dic setValue:self.userName.text forKey:@"real_name"];
            }
        }
        else if ([self.title isEqualToString:@"昵称".localized]) {
            if (self.status == YES) {
//                [dic setValue:self.userName.text forKey:@"nick_name"];
                toast = @"提交成功，后台审核中！";
            }
        }
        
        if ([self.title isEqualToString:@"实名认证".localized]) {
            if (self.status == YES) {
            [dic setValue:self.passWord.text forKey:@"identity_card"];
            }
        }
        
        if ([self.title isEqualToString:@"QQ".localized]) {
            if (self.status == YES) {
                [dic setValue:self.userName.text forKey:@"qq"];
            }
        }
        
        [YJProgressHUD showSuccess:toast inview:self.view];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"member_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //判定是否回调
        if (self.status == YES)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSetMemberInfoSuccess" object:nil];
    }
    else {
        [MBProgressHUD showToast:api.error_desc];
    }
}

- (IBAction)registerPress:(id)sender {
    [self modifyInfoRequest];
}

//用户名
- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//姓名
- (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark — UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    return basicTest;
}

- (void)enterQQValueChanged:(UITextField *)textField
{
    if (textField.text.length > 10)
    {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 10)];
    }
}

@end
