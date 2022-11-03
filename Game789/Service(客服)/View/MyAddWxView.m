//
//  MyAddWxView.m
//  Game789
//
//  Created by Maiyou001 on 2021/11/25.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyAddWxView.h"
#import <Photos/Photos.h>

@implementation MyAddWxView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAddWxView" owner:self options:nil].firstObject;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.frame = frame;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.codeImageView yy_setImageWithURL:[NSURL URLWithString:dataDic[@"kefu_weixin_qrcode"]] placeholder:MYGetImage(@"")];
}

- (IBAction)addAndSaveClick:(id)sender
{
    [self removeFromSuperview];
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    //  保存图片到相册
                    [self saveImageIntoAlbum];
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    [[YYToolModel getCurrentVC] jxt_showAlertWithTitle:@"温馨提示" message:@"请打开相册权限\n前往:设置->通用->隐私->相册->打开权限" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                        alertMaker.addActionCancelTitle(@"取消").addActionDefaultTitle(@"确定");
                    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                        
                    }];
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    //   [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
                    break;
                }
                default:
                    break;
            }
        });
    }];
}

//保存图片到相册
- (void)saveImageIntoAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"二维码图片已保存到相册" ;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openWx];
        });
    }
    [MBProgressHUD showToast:msg toView:[YYToolModel getCurrentVC].view];
}

- (void)openWx
{
    // 判断手机是否安装微信
    NSURL *url = [NSURL URLWithString:@"weixin://"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    else
    {
        [MBProgressHUD showToast:@"该设备未安装微信" toView:[YYToolModel getCurrentVC].view];
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
