//
//  PayPlug.m
//  PayDemo
//
//  Created by sam on 15/11/2.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "PayPlug.h"
//---------支付宝---------
//#import "ProductOrder.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
//#import "RSADataSigner.h"
#import "openssl_wrapper.h"
#import "ShareVale.h"
#import "NSObject+TUPayAPI.h"
//---------微信-----------
//#import "WXApi.h"
//#import "WXApiObject.h"
//#import "payRequsestHandler.h"

//---------qq钱包------------
#import <CommonCrypto/CommonHMAC.h>

#import "TUAlerterView.h"
@interface PayPlug ()<UIAlertViewDelegate>

@property (nonatomic, copy)  PayResult block;

@end

@implementation PayPlug

//创建该类的单例
+ (instancetype)sharedInstance {
    static id instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
    });
    return instace;
}

- (void)newAlipay:(PayResult)block {
    self.block = block;
    [self doPayWithParameter];
}

- (void)doPay:(PayResult)block {
    self.block = block;
    
    
    switch (self.payWay) {
        case WeChatPay: {
            //微信支付
//            [self WeChatPay];
           
        } break;
            
        case AliPay: {
            //支付宝支付
            [self Alipay];
            
        }break;
        case WftPay:{
//            [self wftPay];
            
        }break;
            
        default:
            break;
    }
    
}
#pragma mark -**********************Alipay

/**
 *  支付宝
 */
- (void)Alipay {
    NSData *jsonData = [[self.zfbDic objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers

                                                          error:&err];


    [self doPayWithParameter:dic];
}
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    return decodedString;
}

- (void)doPayWithParameter
{
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [self.zfbDic objectForKey:@"b"];
    //    orderString = [self URLDecodedString:orderString];
    NSLog(@"orderString = %@",orderString);
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@sub_ms",resultDic);
        NSLog(@"支付宝信息->%@",resultDic);

        NSString *statuCode = resultDic[@"resultStatus"];

        if ([statuCode isEqualToString:@"9000"]) {
            if (self.block) {
                self.block(self.payWay, @"支付成功", nil);
                [MBProgressHUD showToast:@"支付宝支付成功"];
                NSLog(@"支付宝支付成功");
            }
        }else if([statuCode isEqualToString:@"6001"]){
            NSError *error = [NSError errorWithDomain:@"支付失败,用户取消支付" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":resultDic[@"memo"]}];
            if (self.block) {
                self.block(self.payWay, ALIPAYCANCEL, error);
                [MBProgressHUD showToast:@"支付宝支付失败,用户取消支付"];
                NSLog(@"支付宝支付失败,用户取消支付");
            }
        } else{
            NSError *error = [NSError errorWithDomain:@"支付失败" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":resultDic[@"memo"]}];
            if (self.block) {
                self.block(self.payWay,ALIPAYFAILDE, error);

                [MBProgressHUD showToast:@"支付宝支付失败"];
                NSLog(@"支付宝支付失败");
            }
        }
    }];
}

- (void)h5ToNativePay:(NSString *)orderString
{
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = [self.zfbDic objectForKey:@"b"];
//    orderString = [self URLDecodedString:orderString];
    NSLog(@"orderString = %@",orderString);
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@sub_ms",resultDic);
        NSLog(@"支付宝信息->%@",resultDic);
        NSLog(@"号码:%@",AlipayScheme);
        NSString *statuCode = resultDic[@"resultStatus"];

        if ([statuCode isEqualToString:@"9000"]) {
            [MBProgressHUD showToast:@"支付宝支付成功"];
        }else if([statuCode isEqualToString:@"6001"]){
            [MBProgressHUD showToast:@"支付宝支付失败,用户取消支付"];
        } else{
            [MBProgressHUD showToast:@"支付宝支付失败"];

        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MaiYouAlipayReturnFinish" object:nil];
    }];
}

- (void)doPayWithParameter:(NSDictionary *)dic
{
    NSString *appID = [dic objectForKey:@"APP_ID"];
    NSString *rsa2PrivateKey = [dic objectForKey:@"APP_KEY"];
    NSString *rsaPrivateKey = @"";
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置".localized
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了".localized
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){

                                                       }];
        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];

    // NOTE: app_id设置
    order.app_id = appID;

    order.notify_url = [dic objectForKey:@"API_NOTIFY_URL"]; //回调URL

    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";

    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];

    // NOTE: 支付版本
    order.version = @"1.0";

    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";

    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = self.productDesc;
    order.biz_content.subject = self.productTitle;
    order.biz_content.out_trade_no = self.sn; //订单ID（由商家自行制定）
    //    order.biz_content.seller_id = @"80614634@qq.com";

    order.biz_content.seller_id = [dic objectForKey:@"DEFAULT_SELLER"];
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = self.productPrice; //商品价格

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    NSLog(@"orderInfoEncoded=%@signedString = %@",orderInfoEncoded,signedString);
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = @"alisdkdemo";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        NSLog(@"orderString3333 = %@",orderString);
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@sub_ms",resultDic);
            NSLog(@"支付宝信息->%@",resultDic);

            NSString *statuCode = resultDic[@"resultStatus"];

            if ([statuCode isEqualToString:@"9000"]) {
                if (self.block) {
                    self.block(self.payWay, @"支付成功", nil);
                    [MBProgressHUD showToast:@"支付宝支付成功"];
                    NSLog(@"支付宝支付成功");
                }
            }else if([statuCode isEqualToString:@"6001"]){
                NSError *error = [NSError errorWithDomain:@"支付失败,用户取消支付" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":resultDic[@"memo"]}];
                if (self.block) {
                    self.block(self.payWay, ALIPAYCANCEL, error);
                    [MBProgressHUD showToast:@"支付宝支付失败,用户取消支付"];
                    NSLog(@"支付宝支付失败,用户取消支付");
                }
            } else{
                NSError *error = [NSError errorWithDomain:@"支付失败" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":resultDic[@"memo"]}];
                if (self.block) {
                    self.block(self.payWay,ALIPAYFAILDE, error);
                    [MBProgressHUD showToast:@"支付宝支付失败"];
                    NSLog(@"支付宝支付失败");
                }
            }
        }];
    }
}

#pragma mark -**********************QQWalletPay

/**
 *  测试方法
 */
// 获取一个demo订单号
- (NSString *)getTokenIDForThisDemo{
    NSURL* url = [NSURL URLWithString:@"http://fun.svip.qq.com/mqqopenpay_demo.php"];  // demo
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        NSDictionary* infos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            NSString* tokenId = infos[@"token"]; // 取得订单号
            return tokenId;
        }
    }
    return nil;
}
// 获取一个随机串
- (NSString *)getNonce{
    NSDate *now = [NSDate date];
    NSNumber *s = @([now timeIntervalSince1970]);
    NSString *nonce = s.stringValue;
    return nonce;
}

// 将data用hmac-sha1算法加密
- (NSData *)hmacSha1:(NSData *)data key:(NSData *)key {
    NSMutableData *hmac = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac( kCCHmacAlgSHA1,
           key.bytes,  key.length,
           data.bytes, data.length,
           hmac.mutableBytes);
    return hmac;
}

// 生成签名串
- (NSString *)getMySignatureWithAppId:(NSString *)appId
                          bargainorId:(NSString *)bargainorId
                                nonce:(NSString *)nonce
                              tokenId:(NSString *)tokenId
                           signingKey:(NSString *)signingKey{
    
    // 1. 将 appId,bargainorId,nonce,tokenId 拼成字符串
    NSString *source = [NSString stringWithFormat:@"appId=%@&bargainorId=%@&nonce=%@&pubAcc=&tokenId=%@",
                        appId,bargainorId,nonce,tokenId];
    
    // 2. 将刚才拼好的字符串，用key来加密
    NSData *signature = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signingData = [[signingKey stringByAppendingString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];  // 约定在key末尾拼一个‘&’符号
    NSData *digest = [self hmacSha1:signature key:signingData];
    
    // 3. 将加密后的data以base64形式输出
    NSString *signatureBase64 = [digest base64Encoding];
    return signatureBase64;
}
@end
