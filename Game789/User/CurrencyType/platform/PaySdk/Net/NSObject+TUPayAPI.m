//
//  NSObject+TUPayAPI.m
//  TuuDemo
//
//  Created by 张鸿 on 16/3/14.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import "NSObject+TUPayAPI.h"
#import "NSMutableDictionary+HTTP.h"

//#import "NSDictionary+SPUtilsExtras.h"

//#import "NSString+SPUtilsExtras.h"



/**
 *  商户密钥值
 */
//NSString *const kSPconstSPaySignVal = @"9d101c97133837e13dde2d32a5054abb";
NSString *const kWFTWXSPconstSPaySignVal = @"7daa4babae15ae17eee90c9e"; //微信
//NSString *const kWFTZFBSPconstSPaySignVal = @"58bb7db599afc86ea7f7b262c32ff42f"; //支付宝测试商户
NSString *const kWFTZFBSPconstSPaySignVal = @"b1d4e122174046b8048aeb8cb765184a"; //支付宝麦游商户




/**
 *  6.1.3    预下单接口地址
 */
NSString *const kSPconstWebApiInterface_spay_pay_gateway = @"pay/gateway";



/**
 *  接口基础地址
 */
NSString *const kSPayBaseUrl =  @"https://pay.swiftpass.cn/";

@implementation NSObject (TUPayAPI)

/**
 *  将相关数据带给支付宝时，先将相关数据发送到我方服务端
 *

 *  @param buyMoney        交易金额
 *  @param userCharacterID 用户角色id
 *  @param serverID        服务器ID
 *  @param orderNumber     客户订单号
 *  @param otherPayInfo    其他支付身份信息
 *  @param productName     商品名称
 *  @param cpExtend        CP方的扩展参数
 *  @param successBlock    请求成功
 *  @param failedBlock     请求失败
 */
- (void)sendSelfNewSERVERPayMoney:(NSString *)PayMoney roleid:(NSString *)roleid serverID:(NSString *)serverID orderNumber:(NSString *)orderNumber otherPayInfo:(NSString *)otherPayInfo productName:(NSString *)productName cpExtend:(NSString *)cpExtend success:(void (^)(NotifyServer *))successBlock failed:(void (^)(NSString *))failedBlock
{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:@"zfb" forField:@"payType"];
    [parameter setObject:PayMoney forField:@"amount"];
    [parameter setObject:[ShareVale sharedInstance].userName forField:@"username"];
    [parameter setObject:@"ios" forKey:@"os"];
    [parameter setObject:roleid forField:@"role_id"];
    [parameter setObject:serverID forField:@"server_id"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"gameid"];
    [parameter setObject:orderNumber forField:@"g"];
    [parameter setObject:otherPayInfo forField:@"h"];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"appid"];
    [parameter setObject:[ShareVale sharedInstance].chenelid forField:@"agent"];
    [parameter setObject:productName forField:@"product_name"];
    [parameter setObject:cpExtend forField:@"n"];

}



/**
 *  将相关数据带给支付宝时，先将相关数据发送到我方服务端
 *

 *  @param buyMoney        交易金额
 *  @param userCharacterID 用户角色id
 *  @param serverID        服务器ID
 *  @param orderNumber     客户订单号
 *  @param otherPayInfo    其他支付身份信息
 *  @param productName     商品名称
 *  @param cpExtend        CP方的扩展参数
 *  @param successBlock    请求成功
 *  @param failedBlock     请求失败
 */
- (void)sendSelfSERVERPayMoney:(NSString *)PayMoney roleid:(NSString *)roleid serverID:(NSString *)serverID orderNumber:(NSString *)orderNumber otherPayInfo:(NSString *)otherPayInfo productName:(NSString *)productName cpExtend:(NSString *)cpExtend success:(void (^)(NotifyServer *))successBlock failed:(void (^)(NSString *))failedBlock
{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:@"zfb" forField:@"payType"];
    [parameter setObject:PayMoney forField:@"amount"];
    [parameter setObject:[ShareVale sharedInstance].userName forField:@"username"];
    [parameter setObject:@"ios" forKey:@"os"];
    [parameter setObject:roleid forField:@"role_id"];
    [parameter setObject:serverID forField:@"server_id"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"gameid"];
    [parameter setObject:orderNumber forField:@"orderNumber"];
    [parameter setObject:otherPayInfo forField:@"product_desc"];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"appid"];
    [parameter setObject:[ShareVale sharedInstance].chenelid forField:@"agent"];
    [parameter setObject:productName forField:@"product_name"];
    [parameter setObject:cpExtend forField:@"ext"];

}

/**
 *  将相关数据带给支付宝时，先将相关数据发送到我方服务端
 *

 *  @param buyMoney        交易金额
 *  @param userCharacterID 用户角色id
 *  @param serverID        服务器ID
 *  @param orderNumber     客户订单号
 *  @param otherPayInfo    其他支付身份信息
 *  @param productName     商品名称
 *  @param cpExtend        CP方的扩展参数
 *  @param successBlock    请求成功
 *  @param failedBlock     请求失败
 */
- (void)sendAlipayNativeMoney:(NSString *)PayMoney roleid:(NSString *)roleid serverID:(NSString *)serverID orderNumber:(NSString *)orderNumber otherPayInfo:(NSString *)otherPayInfo productName:(NSString *)productName cpExtend:(NSString *)cpExtend success:(void (^)(NotifyNativeServer *))successBlock failed:(void (^)(NSString *))failedBlock
{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:@"zfb" forField:@"payType"];
    [parameter setObject:PayMoney forField:@"amount"];
    [parameter setObject:[ShareVale sharedInstance].userName forField:@"username"];
    [parameter setObject:@"ios" forKey:@"os"];
    [parameter setObject:roleid forField:@"role_id"];
    [parameter setObject:serverID forField:@"server_id"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"gameid"];
    [parameter setObject:orderNumber forField:@"orderNumber"];
    [parameter setObject:otherPayInfo forField:@"product_desc"];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"appid"];
    [parameter setObject:[ShareVale sharedInstance].chenelid forField:@"agent"];
    [parameter setObject:productName forField:@"product_name"];
    [parameter setObject:cpExtend forField:@"ext"];
//    NetWorkManager *manager = [NetWorkManager sharedInstance];
//    [manager POST:SendALIPAYSERVER parameters:parameter success:^(id response) {
//        if (![[response objectForKey:@"a"] isEqualToString:@"1"]) {
//            failedBlock([response objectForKey:@"b"]);
//            return;
//        }
//        NotifyNativeServer *result =  [NotifyNativeServer responseWithDic:response];
//        successBlock(result);
//    } failure:^(NSError *error) {
//        failedBlock (error.description);
//    }];
}

/**
 *  获取支付方式
 */
- (void)GetZFBNativePayWayssuccess:(void (^)(id))successBlock failed:(void (^)(NSString *))failedBlock{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"a"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"b"];

}

/**
 *  获取支付方式
 */
- (void)GetPayWayssuccess:(void (^)(id))successBlock failed:(void (^)(NSString *))failedBlock{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"a"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"b"];
}

/**
 *  获取支付方式
 */
- (void)GetNewPayWayssuccess:(void (^)(id))successBlock failed:(void (^)(NSString *))failedBlock{
    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:[ShareVale sharedInstance].appID forField:@"a"];
    [parameter setObject:[ShareVale sharedInstance].gameID forField:@"b"];
}




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
                       failed:(void (^)(NSString *errorStatus))failedBlock
{
  

    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
    [parameter setObject:payType forField:@"a"];
    [parameter setObject:money forField:@"b"];
}
/**
 *  获取支付URL
 */
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
                          failed:(void (^)(NSString *errorStatus))failedBlock
{
    

    NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];


    [parameter setObject:payType forField:@"a"];
    [parameter setObject:money forField:@"b"];
    [parameter setObject:name forField:@"c"];
    [parameter setObject:usrID forField:@"d"];
    [parameter setObject:serverID forField:@"e"];
    [parameter setObject:gameID forField:@"f"];
    [parameter setObject:@"ios" forField:@"os"];
    [parameter setObject:[ShareVale sharedInstance].IDFA forField:@"h"];
    [parameter setObject:appid forField:@"j"];//bundle_identifier
    [parameter setObject:chanelID forField:@"k"];
    [parameter setObject:productName forField:@"l"];
    [parameter setObject:productEX forField:@"m"];
    [parameter setObject:cpEX forField:@"n"];
}

- (NSDictionary *)stringToDic:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return dic;
}
@end
