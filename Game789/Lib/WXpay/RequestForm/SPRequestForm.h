
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRequestForm : NSObject


+ (id)sharedInstance;;

/**
 6.1.3	预下单接口
 
 @param service       接口类型（必填）
 @param version       版本号（非必填）
 @param charset       字符集（非必填）
 @param sign_type     签名方式（非必填）
 @param mch_id        商户号（必填）
 @param out_trade_no  商户订单号（必填）
 @param device_info   设备号（非必填）
 @param body          商品描述（必填）
 @param total_fee     总金额 (必填)
 @param mch_create_ip 终端IP (必填)
 @param notify_url    通知地址 (必填)
 @param time_start    订单生成时间（非必填）
 @param time_expire   订单超时时间（非必填）
 @param nonce_str     随机字符串 (必填)
 @param callback_url  回调地址 (必填)
 @param mch_app_id    buddleID
 @param mch_app_name  app名字
 @return 字典
 */
- (NSDictionary*)sp_pay_gateway:(NSString*)service
                          version:(NSString*)version
                          charset:(NSString*)charset
                        sign_type:(NSString*)sign_type
                           mch_id:(NSString*)mch_id
                     out_trade_no:(NSString*)out_trade_no
                      device_info:(NSString*)device_info
                             body:(NSString*)body
                        total_fee:(NSInteger)total_fee
                    mch_create_ip:(NSString*)mch_create_ip
                       notify_url:(NSString*)notify_url
                       time_start:(NSString*)time_start
                      time_expire:(NSString*)time_expire
                        nonce_str:(NSString*)nonce_str
                     callback_url:(NSString*)callback_url
                       mch_app_id:(NSString*)mch_app_id
                     mch_app_name:(NSString*)mch_app_name;


@end
