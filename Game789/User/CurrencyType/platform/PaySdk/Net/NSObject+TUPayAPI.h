//
//  NSObject+TUPayAPI.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/14.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpURL.h"
@interface NSObject (TUPayAPI)

- (void)sendSelfNewSERVERPayMoney:(NSString *)PayMoney roleid:(NSString *)roleid serverID:(NSString *)serverID orderNumber:(NSString *)orderNumber otherPayInfo:(NSString *)otherPayInfo productName:(NSString *)productName cpExtend:(NSString *)cpExtend success:(void (^)(NotifyServer *))successBlock failed:(void (^)(NSString *))failedBlock;

/**
*  将相关数据带给支付宝时，先将相关数据发送到我方服务端
*
*  @param buyMoney        交易金额
*  @param userCharacterID 用户角色id
*  @param serverID        服务器ID
*  @param orderNumber     客户订单号
*  @param otherPayInfo    其他支付身份信息D
*  @param productName     商品名称
*  @param cpExtend        CP方的扩展参数
*  @param successBlock    请求成功
*  @param failedBlock     请求失败
*/
- (void)sendSelfSERVERPayMoney:(NSString *)PayMoney
                        roleid:(NSString *)roleid
                      serverID:(NSString *)serverID
                   orderNumber:(NSString *)orderNumber
                  otherPayInfo:(NSString *)otherPayInfo
                   productName:(NSString *)productName
                      cpExtend:(NSString *)cpExtend
                       success:(void (^)(NotifyServer *response))successBlock
                        failed:(void (^)(NSString *errorStatus))failedBlock;

- (void)sendAlipayNativeMoney:(NSString *)PayMoney roleid:(NSString *)roleid serverID:(NSString *)serverID orderNumber:(NSString *)orderNumber otherPayInfo:(NSString *)otherPayInfo productName:(NSString *)productName cpExtend:(NSString *)cpExtend success:(void (^)(NotifyNativeServer *))successBlock failed:(void (^)(NSString *))failedBlock;
// 威富通微信 支付宝唤起
//- (void)wftWenXinPayTokenId:(NSString *)tokenId;
- (void)wftAlipayPayTokenId:(NSString *)tokenId success:(void (^)(NSString *))successBlock failed:(void (^)(NSString *))failedBlock;
- (void)wftWenXinPayTokenId:(NSString *)tokenId success:(void (^)(NSString *))successBlock failed:(void (^)(NSString *))failedBlock;
//- (void)wftAlipayPayTokenId:(NSString *)tokenId;
/**
 *  查询uu币
 */
- (void)GetMyUUMoneyWithsuccess:(void (^)(GetMyUUResult *reponse)) successBlock
                         failed:(void (^)(NSString *errorStatus))failedBlock;

/**
 *  uu币支付接口
 *
 *  @param buyMoney        交易金额
 *  @param serverID        服务器ID
 *  @param productName     商品名称
 *  @param prductDescrip   商品描述
 *  @param cpExtend        CP方的扩展参数
 */
- (void)uuPayWithPayMoney:(NSString *)buyMoney
              productName:(NSString *)productName
            prductDescrip:(NSString *)productDescrip
                 cpExtend:(NSString *)cpExtend
                   roleID:(NSString *)roleID
                  success:(void (^)(TTbPay *response))successBlock
                   failed:(void (^)(NSString *errorStatus ,NSString *code))failedBlock;

/**
 *  获取客服qq和电话
 */
- (void)GetServiceQQAndPhonesuccess:(void (^)(HelpQQAndTel *reponse)) successBlock
                            failed:(void (^)(NSString *errorStatus))failedBlock;
/**
 *  一键支付地址
 */
- (void)getQuickPayHtmlUrlWithPrice:(NSString*)price payerInfo:(NSString*)payerInfo productNmae:(NSString*)ProducName ProductDescrip:(NSString*)productDescrip  cpExtend:(NSString *)cpExtend success:(void (^)(QuickPay  *reponse)) successBlock
                          failed:(void (^)(NSString *errorStatus))failedBlock;
/**
 *  查询订单记录
 */
- (void)payRecordsWithStatus:(NSString*)status
                        page:(NSString *)page
                     success:(void (^)(OrderRecords *reponse)) successBlock
                      failed:(void (^)(NSString *errorStatus))failedBlock;


/**
 *  游戏详细信息
 */
- (void)getGameDetailInfosuccess:(void (^)(id data)) successBlock
                          failed:(void (^)(NSString *errorStatus))failedBlock;
/**
 *  根据infoid获取礼包码
 */
- (void)getGiffCodeForInfoid:(NSString*)giffID
                      success:(void (^)(id reponse)) successBlock
                      failed:(void (^)(NSString *errorStatus))failedBlock;


/**
 *  获取游戏礼包条目地址
 */
- (void)GetGamePresentHtmlsuccess:(void (^)(id reponse)) successBlock
                           failed:(void (^)(NSString *errorStatus))failedBlock;

/**
 *  获取支付方式
 */
- (void)GetPayWayssuccess:(void (^)(id reponse)) successBlock
                   failed:(void (^)(NSString *errorStatus))failedBlock;

- (void)GetNewPayWayssuccess:(void (^)(id))successBlock failed:(void (^)(NSString *))failedBlock;
/**
 *  获取微信支付信息
 */
- (void)getWeiXinPayInfoWithPaytype:(NSString *)payType
                              money:(NSString *)money
                           username:(NSString *)name
                              usrID:(NSString *)usrID
                           serverID:(NSString *)serverID
                             gameID:(NSString *)gameID
                          phoneType:(NSString *)phonetype
                       otherMessage:(NSString *)message
                              appid:(NSString *)appid
                           chanelid:(NSString *)chanelID
                        productName:(NSString *)productName
                               cpEX:(NSString *)cpEX
                            Success:(void (^)(id reponse)) successBlock
                             failed:(void (^)(NSString *errorStatus))failedBlock;

/**
 *  获取wft微信支付信息
 */
- (void)getWFTPayInfoWithPaytype:(NSString *)payType
                                money:(NSString *)money
                             username:(NSString *)name
                                usrID:(NSString *)usrID
                             serverID:(NSString *)serverID
                               gameID:(NSString *)gameID
                                appid:(NSString *)appid
                            productEX:(NSString *)productEX
                             chanelid:(NSString *)chanelID
                          productName:(NSString *)productName
                                 cpEX:(NSString *)cpEX
                              Success:(void (^)(id reponse)) successBlock
                               failed:(void (^)(NSString *errorStatus))failedBlock;
/**
 *  获取wft支付宝支付信息
 */
- (void)getWFTPayAlipayInfoWithPaytype:(NSString *)payType
                                 money:(NSString *)money
                              username:(NSString *)name
                                 usrID:(NSString *)usrID
                              serverID:(NSString *)serverID
                                gameID:(NSString *)gameID
                                 appid:(NSString *)appid
                             productEX:(NSString *)productEX
                              chanelid:(NSString *)chanelID
                           productName:(NSString *)productName
                                  cpEX:(NSString *)cpEX
                               Success:(void (^)(id reponse)) successBlock
                                failed:(void (^)(NSString *errorStatus))failedBlock;


// 获取支付URL
- (void)getPayInfoWithPaytype:(NSString *)payType
                        money:(NSString *)money
                     username:(NSString *)name
                        usrID:(NSString *)usrID
                     serverID:(NSString *)serverID
                       gameID:(NSString *)gameID
                        appid:(NSString *)appid
                    productEX:(NSString *)productEX
                     chanelid:(NSString *)chanelID
                  productName:(NSString *)productName
                         cpEX:(NSString *)cpEX
                      Success:(void (^)(id reponse)) successBlock
                       failed:(void (^)(NSString *errorStatus))failedBlock;

/**
 *  获取支付结果
 */
- (void)getPayResultWithPaytype:(NSString *)payType
                          money:(NSString *)money
                       username:(NSString *)name
                          usrID:(NSString *)usrID
                       serverID:(NSString *)serverID
                         gameID:(NSString *)gameID
                          appid:(NSString *)appid
                      productEX:(NSString *)productEX
                       chanelid:(NSString *)chanelID
                    productName:(NSString *)productName
                           cpEX:(NSString *)cpEX
                        Success:(void (^)(id reponse)) successBlock
                         failed:(void (^)(NSString *errorStatus))failedBlock;

@end
