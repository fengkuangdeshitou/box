//
//  UMModel.m
//
//

#import "UMModelCreate.h"
#define UM_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UM_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IS_HORIZONTAL (UM_SCREEN_WIDTH > UM_SCREEN_WIDTH)


#define UM_Alert_NAV_BAR_HEIGHT      55.0
#define UM_Alert_HORIZONTAL_NAV_BAR_HEIGHT      41.0

//竖屏弹窗
#define UM_Alert_Default_LR_Padding           18.0
#define UM_Alert_LogoImg_Height_Width         60.0
#define UM_Alert_LogoImg_OffetY               12.0
#define UM_Alert_SloganTxt_OffetY             88.0
#define UM_Alert_SloganTxt_Height             24.0
#define UM_Alert_NumberTxt_OffetY             121.0
#define UM_Alert_LoginBtn_OffetY              163.0
#define UM_Alert_LogonBtn_Height              40.0
#define UM_Alert_ChangeWayBtn_OffetY          219.0
#define UM_Alert_Default_Left_Padding         42
#define UM_Alert_Default_Top_Padding          115

/**横屏弹窗*/
#define UM_Alert_Horizontal_Default_Left_Padding      80.0
#define UM_Alert_Horizontal_Default_LR_Padding        18.0
#define UM_Alert_Horizontal_NumberTxt_OffetY          22.5
#define UM_Alert_Horizontal_LoginBtn_OffetY           78.5
#define UM_Alert_Horizontal_LoginBtn_Height           51.0

/**竖屏全屏*/
#define UM_LogoImg_OffetY               32.0
#define UM_SloganTxt_OffetY             150.0
#define UM_SloganTxt_Height             24.0
#define UM_NumberTxt_OffetY             220.0
#define UM_LoginBtn_OffetY              270.0
#define UM_ChangeWayBtn_OffetY          344.0
#define UM_LoginBtn_Height              50.0
#define UM_LogoImg_Height_Width         90.0
#define UM_Default_LR_Padding           18.0
#define UM_Privacy_Bottom_OffetY        13.5

/**横屏全屏*/
#define UM_Horizontal_LogoImg_OffetY               11.0
#define UM_Horizontal_NumberTxt_OffetY             76.0
#define UM_Horizontal_LogoImg_Height_Width         55.0
#define UM_Horizontal_Default_LR_Padding           UM_SCREEN_WIDTH * 0.5 * 0.5
#define UM_Horizontal_LoginBtn_OffetY              122.0
#define UM_Horizontal_Privacy_Bottom_OffetY        13.5

static CGFloat ratio ;

@implementation UMModelCreate
+ (void)load {
    ratio = MAX(UM_SCREEN_WIDTH, UM_SCREEN_HEIGHT) / 667.0;
}
/// 创建横屏全屏的model
+ (UMCustomModel *)createFullScreen
{
    NSString * agent = [[DeviceInfo shareInstance] getFileContent:@"TUUChannel"];
    UIImage * image = [UIImage imageNamed:agent];
    UIImage * defaultImage = [UIImage imageNamed:@"login_milu_logo"];
    UMCustomModel *model = [[UMCustomModel alloc] init];
        
        model.navColor = UIColor.whiteColor;
        model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录".localized attributes:@{NSForegroundColorAttributeName : UIColor.blackColor,NSFontAttributeName : [UIFont systemFontOfSize:18.0]}];
        //model.navIsHidden = NO;
        model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
        
        model.privacyNavColor = UIColor.orangeColor;
        model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
        model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
        model.privacyNavTitleColor = UIColor.whiteColor;
        
        //登录logo
        model.logoImage = image ? : defaultImage;
        //电话号码
        model.numberColor = FontColor28;
        model.numberFont = [UIFont systemFontOfSize:23.0];
        //登录按钮
        model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录".localized attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
        model.loginBtnBgImgs = @[[UIImage imageNamed:@"login_btn_bg"], [UIImage imageNamed:@"login_btn_bg"], [UIImage imageNamed:@"login_btn_bg"]];
        //model.autoHideLoginLoading = NO;
        //用户协议
        model.privacyOne = @[@"《用户协议》", LoginUserAgreementUrl];
        model.privacyTwo = @[@"《隐私政策》", LoginPrivacyPolicyUrl];
        model.privacyColors = @[UIColor.lightGrayColor, [UIColor colorWithHexString:@"#FFC000"]];
        model.privacyAlignment = NSTextAlignmentCenter;
        model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0];
        model.privacyOperatorPreText = @"《";
        model.privacyOperatorSufText = @"》";
        //model.checkBoxIsHidden = NO;
        NSDictionary * dic = [DeviceInfo shareInstance].data;
        model.checkBoxIsChecked = [dic[@"agreeChecked"] boolValue];
        model.checkBoxWH = 17.0;
        model.checkBoxImages = @[[UIImage imageNamed:@"trading_agree_noSelected"], [UIImage imageNamed:@"trading_agress_selected"]];
        model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"其它方式登录".localized attributes:@{NSForegroundColorAttributeName : FontColor66, NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];
        //model.changeBtnIsHidden = NO;
        //model.prefersStatusBarHidden = NO;
        model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
        //model.presentDirection = PNSPresentationDirectionBottom;
        
        //授权页默认控件布局调整
        //model.navBackButtonFrameBlock =
        //model.navTitleFrameBlock =
        model.navMoreViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            CGFloat width = superViewSize.height;
            CGFloat height = width;
            return CGRectMake(superViewSize.width - 15 - width, 0, width, height);
        };
        //logo
        model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            return CGRectMake(40, frame.origin.y + 40, kScreenW - 80, 81);
        };
        //
        model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            if ([self isHorizontal:screenSize]) {
                return CGRectZero; //横屏时模拟隐藏该控件
            } else {
                return CGRectZero;
            }
        };
        //电话号码
        model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            if ([self isHorizontal:screenSize]) {
                frame.origin.y = 140;
            }
            return CGRectMake(frame.origin.x, frame.origin.y - (IS_IPhoneX_All ? 50 : 10), frame.size.width, frame.size.height);
        };
        //登录按钮
        model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            if ([self isHorizontal:screenSize]) {
                frame.origin.y = 185;
            }
            return CGRectMake(30, frame.origin.y - (IS_IPhoneX_All ? 50 : 0), kScreenW - 60, frame.size.height);
        };
        //更多登录
        CGSize size = [YYToolModel sizeWithText:@"其它方式登录".localized size:CGSizeMake(MAXFLOAT, 30) font:[UIFont systemFontOfSize:14]];
        model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            if ([self isHorizontal:screenSize]) {
                return CGRectZero; //横屏时模拟隐藏该控件
            } else {
                return CGRectMake((kScreenW - (size.width + 5)) / 2, frame.origin.y - (IS_IPhoneX_All ? 80 : 0), size.width + 5, 30);
            }
        };
        //model.privacyFrameBlock =
        
        //添加自定义控件并对自定义控件进行布局
//        __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
//        [customBtn setBackgroundColor:UIColor.redColor];
//        customBtn.frame = CGRectMake(0, 0, 230, 40);
//        model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//             [superCustomView addSubview:customBtn];
//        };
//        model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//            CGRect frame = customBtn.frame;
//            frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
//            frame.origin.y = CGRectGetMinY(privacyFrame) - frame.size.height - 20;
//            frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
//            customBtn.frame = frame;
//        };
        return model;
    }


#pragma mark - 弹窗模式

/// 创建横屏弹窗的model
+ (UMCustomModel *)createAlert {
    UMCustomModel *model = [[UMCustomModel alloc] init];
    model.alertCloseItemIsHidden = NO;
    model.alertTitleBarColor = UIColor.orangeColor;
    model.alertTitle = [[NSAttributedString alloc] initWithString:@"一键登录横屏弹窗" attributes:@{NSForegroundColorAttributeName : UIColor.blackColor,NSFontAttributeName : [UIFont systemFontOfSize:24.0]}];
    model.alertCornerRadiusArray = @[@10,@10,@10,@10];
    model.alertCloseImage = [UIImage imageNamed:@"icon_logo_bg"];
    
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_gray"];
    model.hideNavBackItem = NO;

    model.logoImage = [UIImage imageNamed:@"umeng"];
    model.logoIsHidden = NO;
//
    model.sloganIsHidden = NO;
    model.sloganText = [[NSAttributedString alloc] initWithString:@"一键登录slogan文案" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
//
    model.numberColor = UIColor.orangeColor;
    model.numberFont = [UIFont systemFontOfSize:30.0];
    
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录22" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    
    model.autoHideLoginLoading = NO;
//
    model.privacyOne = @[@"流量App使用方法1",@"https://www.taobao.com/"];
    model.privacyTwo = @[@"流量App使用方法2",@"https://www.umeng.com/"];
    model.privacyColors = @[UIColor.lightGrayColor,UIColor.orangeColor];
//    model.privacyBottomOffetY = self.ratio * 25.0;
    model.privacyAlignment = NSTextAlignmentCenter;
//    model.privacyLRPadding = 8.0;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    model.privacyOperatorPreText = @"『";
    model.privacyOperatorSufText = @"』";
//
    model.checkBoxIsChecked = YES;
    model.checkBoxWH = 15.0;

    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换到其他方式22" attributes:@{NSForegroundColorAttributeName : UIColor.orangeColor,NSFontAttributeName : [UIFont systemFontOfSize:18.0]}];
    model.changeBtnIsHidden = NO;
    
//    model.prefersStatusBarHidden = YES;
    
    
    
    model.privacyNavColor = UIColor.whiteColor;
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_gray"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.orangeColor;
    model.presentDirection = UMPNSPresentationDirectionBottom;
    model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    //添加自定义控件
    __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
    [customBtn setBackgroundColor:UIColor.redColor];
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
         [superCustomView addSubview:customBtn];
    };
    __block CGFloat alertX = 0;
    __block CGFloat alertY = 0;
    __block CGFloat alertWidth = 0;
    __block CGFloat alertHeight = 0;
        
    model.contentViewFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {//横屏模式
            alertX = ratio * UM_Alert_Horizontal_Default_Left_Padding;
            alertWidth = screenSize.width - alertX * 2;
            alertY = (screenSize.height - alertWidth / 2.0) / 2.0;
            alertHeight = screenSize.height - 2 * alertY;
        } else {
            alertX = UM_Alert_Default_Left_Padding * ratio;
            alertWidth = screenSize.width - alertX * 2;
            alertY = UM_Alert_Default_Top_Padding * ratio;
            alertHeight = screenSize.height - alertY * 2;
        }
        return CGRectMake(alertX, alertY, alertWidth, alertHeight);
    };
//    只针对弹窗生效
    model.alertTitleBarFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat width = alertWidth;
        CGFloat height = 0;
        if ([self isHorizontal:screenSize]) {
            height = UM_Alert_HORIZONTAL_NAV_BAR_HEIGHT;
        } else {
            height = UM_Alert_NAV_BAR_HEIGHT;
        }
        return CGRectMake(0, 0, width, height);
    };
    model.alertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat width = alertWidth;
        CGFloat height = 0;
        if ([self isHorizontal:screenSize]) {
            height = UM_Alert_HORIZONTAL_NAV_BAR_HEIGHT;
        } else {
            height = UM_Alert_NAV_BAR_HEIGHT;
        }
        return CGRectMake(0, 0, width, height);
    };
    model.alertCloseItemFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat closeButton_right = 15.0;
        CGFloat closeButtonX = alertWidth - CGRectGetWidth(frame) - closeButton_right;
        CGFloat closeButtonY = 0;
        if ([self isHorizontal:screenSize]) {
            closeButtonY = (UM_Alert_HORIZONTAL_NAV_BAR_HEIGHT - frame.size.height) * 0.5;
        } else {
            closeButtonY = (UM_Alert_NAV_BAR_HEIGHT - frame.size.height) * 0.5;
        }
        return CGRectMake(closeButtonX, closeButtonY, frame.size.width, frame.size.height);
    };
    model.navBackButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat backButtonX = 15.0;
        CGFloat backButtonY = 0;
        if ([self isHorizontal:screenSize]) {
            backButtonY = 0;
        } else {
            backButtonY = frame.origin.y;
        }
        return CGRectMake(backButtonX, backButtonY, frame.size.width, frame.size.height);
    };
//    横屏的弹窗没有logo ，可以不配置横屏的情况
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat logoX = (alertWidth - UM_Alert_LogoImg_Height_Width)/ 2.0;
        CGFloat logoY = UM_Alert_LogoImg_OffetY;
        CGFloat logoWidth = UM_Alert_LogoImg_Height_Width;
        CGFloat logoHeight = UM_Alert_LogoImg_Height_Width;
        if ([self isHorizontal:screenSize]) {
            return CGRectZero;
        }
        return CGRectMake(logoX, logoY, logoWidth, logoHeight);
    };
//    横屏(包括弹窗和全屏)没有slogan ，可以不配置横屏的情况
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero;
        }
        CGFloat sloganX = 0;
        CGFloat sloganY = ratio * UM_Alert_SloganTxt_OffetY;
        CGFloat sloganWidth = alertWidth;
        CGFloat sloganHeight = UM_Alert_SloganTxt_Height;
        return CGRectMake(sloganX, sloganY, sloganWidth, sloganHeight);
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat numberX = (alertWidth - frame.size.width) * 0.5;
        CGFloat numberY = ratio * UM_Alert_NumberTxt_OffetY;
        CGFloat numberWidth = frame.size.width;
        CGFloat numberHeight = frame.size.height;
        if ([self isHorizontal:screenSize]) {
            numberX = UM_Alert_Horizontal_Default_LR_Padding;
            numberY = UM_Alert_Horizontal_NumberTxt_OffetY;
            numberWidth = alertWidth * 0.5 - 2 * numberX;
        }
        return CGRectMake(numberX, numberY, numberWidth, numberHeight);
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame){
        CGFloat loginX = UM_Alert_Default_LR_Padding;
        CGFloat loginY = ratio * UM_Alert_LoginBtn_OffetY;
        CGFloat loginWidth = alertWidth - loginX * 2;
        CGFloat loginHeight = 40;
        if ([self isHorizontal:screenSize]) {
            loginX = UM_Alert_Horizontal_Default_LR_Padding;
            loginY = UM_Alert_Horizontal_LoginBtn_OffetY;
            loginWidth = alertWidth * 0.5 - 2 * loginX;
        }
        
        return CGRectMake(loginX, loginY, loginWidth, loginHeight);
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero;
        }
        CGFloat changeBtnHeight = 40;
        CGFloat changeBtnX = UM_Alert_Default_LR_Padding;
        CGFloat changeBtnY = ratio * UM_Alert_ChangeWayBtn_OffetY;
        CGFloat changeBtnWidth = alertWidth - changeBtnX * 2;
        return CGRectMake(changeBtnX, changeBtnY, changeBtnWidth, changeBtnHeight);
    };
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize contentSize, CGRect frame) {
        CGFloat privacyX = 0, privacyY = 0, privacyWidth = 0, privacyHeight = 0;
        if ([self isHorizontal:screenSize]) {
            privacyX = frame.origin.x;
            privacyY = frame.origin.y;
            privacyWidth = alertWidth - 2 * privacyX;
            privacyHeight = frame.size.height;
        } else {
            privacyX = frame.origin.x;
            privacyY =  frame.origin.y;
            privacyWidth = alertWidth - 2 * privacyX;
            privacyHeight = frame.size.height;
        }
        return CGRectMake(privacyX, privacyY, privacyWidth, privacyHeight);
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        if ([self isHorizontal:screenSize]) {
            height = 120;
            x = contentFrame.size.width / 2.0 + 20;
            y = (contentFrame.size.height - height) * 0.5;
            width = contentFrame.size.width - x - 20;
        } else {
            x = 50;
            y = ratio * 320;
            width = contentFrame.size.width - 2 * x;
            height = 60;
        }
        
        customBtn.frame = CGRectMake(x, y, width, height);
    };
    return model;
}

//是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}
@end
