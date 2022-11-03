//
//  LoginResult.m
//  TuuDemo
//
//  Created by 张鸿 on 16/3/15.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import "ResponseInfo.h"

@implementation LoginResult
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    NSDictionary * dataDic = [dic objectForKey:@"data"];
    NSDictionary * statusDic = [dic objectForKey:@"status"];
    LoginResult *LRrsult = [[self alloc] init];
    LRrsult.code = [statusDic objectForKey:@"error_code"];
    LRrsult.userName = [dataDic objectForKey:@"username"];
    LRrsult.token = [dataDic objectForKey:@"token"];
    LRrsult.sign = [dic objectForKey:@"d"];
    LRrsult.sinceTime = [dic objectForKey:@"e"];
    LRrsult.mesage = [dic objectForKey:@"error_description"];
    return LRrsult;
}
@end
@implementation WFTInfo
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    WFTInfo *WFrsult = [[self alloc] init];
    WFrsult.code = [dic objectForKey:@"a"];
    WFrsult.token = [[dic objectForKey:@"data"] objectForKey:@"token_id"];
    WFrsult.services = [[dic objectForKey:@"data"] objectForKey:@"services"];
    WFrsult.orderID = [[dic objectForKey:@"data"] objectForKey:@"orderid"];
    return WFrsult;
}
@end
@implementation RegisterResult
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    RegisterResult *Rresult = [[self alloc] init];
    Rresult.code = [dic objectForKey:@"a"];
    Rresult.userName = [dic objectForKey:@"b"];
    Rresult.urserPwd = [dic objectForKey:@"c"];
    Rresult.mesage = [dic objectForKey:@"d"];
    Rresult.sign = [dic objectForKey:@"e"];
    Rresult.sinceTime = [dic objectForKey:@"f"];
    return Rresult;
    
}
@end


@implementation GetMyUUResult
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    GetMyUUResult *GetUU = [[self alloc] init];
    GetUU.code = [dic objectForKey:@"a"];
    GetUU.UB = [dic objectForKey:@"b"];
    GetUU.mesage = [dic objectForKey:@"c"];
    return GetUU;
}

@end

@implementation LoginOut
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    LoginOut *Lout = [[self alloc] init];
    Lout.code = [dic objectForKey:@"a"];
    Lout.mesage = [dic objectForKey:@"b"];
    return Lout;
}

@end


@implementation TTbPay
+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    TTbPay *tPay = [[self alloc] init];
    tPay.code = [dic objectForKey:@"a"];
    tPay.mesage = [dic objectForKey:@"c"];
    tPay.orderID = [dic objectForKey:@"b"];
    
    return tPay;
}

@end

//@implementation PayWay
//
//+ (instancetype)responseWithDic:(NSDictionary *)dic
//{
//    PayWay *Pway = [[self alloc] init];
//    Pway.code = [dic objectForKey:@"code"];
//    Pway.mesage = [dic objectForKey:@"msg"];
//    NSArray *arr = [dic objectForKey:@"data"];
//    NSMutableArray *murr = [NSMutableArray array];
//    for (NSDictionary *ardic in arr) {
//        PayWay *response = [[PayWay alloc] init];
//        response.code = [ardic objectForKey:@"a"];
//        response.mesage = [ardic objectForKey:@"b"];
//        [murr addObject:response];
//    }
//    Pway.data = murr;
//    return Pway;
//    
//}

//@end

@implementation HelpQQAndTel

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    HelpQQAndTel *qt = [[self alloc] init];
    NSArray *dataAr = [dic objectForKey:@"data"];
    NSDictionary *data = [dataAr lastObject];
    qt.QQ = [data objectForKey:@"b"];
    qt.TEL = [data objectForKey:@"a"];
    qt.mesage = [data objectForKey:@"d"];
    qt.ttbRate = [data objectForKey:@"c"];
    qt.libaoShow = [data objectForKey:@"e"];
    return qt;
}

@end

@implementation QuickPay

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    QuickPay *pay = [[self alloc] init];
    pay.code = [dic objectForKey:@"a"];
    pay.url = [dic objectForKey:@"b"];
    pay.mesage = [dic objectForKey:@"c"];
    pay.orderID = [dic objectForKey:@"d"];
    return pay;
}

@end

@implementation OrderRecords

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    OrderRecords *result = [[OrderRecords alloc] init];
    NSArray *dicAr = [dic objectForKey:@"data"];
    if (![dicAr isKindOfClass:[NSArray class]]) return result; //无交易记录
    NSMutableArray *muarry = [NSMutableArray array];
    for (NSDictionary *ar_dic in dicAr) {
        OrderRecords *records = [[OrderRecords alloc] init];
        records.orderID = [ar_dic objectForKey:@"a"];
        records.amount = [ar_dic objectForKey:@"b"];
        records.Paytype = [ar_dic objectForKey:@"paytype"];
        records.creatSinceTime = [ar_dic objectForKey:@"create_time"];
        records.creatTime = [ar_dic objectForKey:@"d"];
        [muarry addObject:records];
    }
    result.dataArray = muarry;
    return result;
}

@end

@implementation GameDetail

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    NSDictionary *dataDic = dic[@"data"];
    GameDetail *result = [[self alloc] init];
    result.iconURL = dataDic[@"a"];
    result.desc = dataDic[@"b"];
    result.downLoadURL = dataDic[@"e"];
    result.gameName = dataDic[@"f"];
    
    return result;
}

@end

@implementation NotifyServer

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    NSDictionary *dataDic = dic[@"data"];
    NotifyServer *result = [[self alloc] init];
    result.mesage = dataDic[@"b"];
    return result;
}
@end

@implementation NotifyNativeServer

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
//    NSDictionary *dataDic = dic[@"data"];
    NotifyNativeServer *result = [[self alloc] init];
    result.dataDic = dic;
    return result;
}
@end

@implementation WeiXinInfo

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    NSDictionary *dataDic = dic[@"data"];
    WeiXinInfo *result = [[self alloc] init];
    result.appid = dataDic[@"appid"];
    result.noncestr = dataDic[@"noncestr"];
    result.package = dataDic[@"package"];
    result.partnerid = dataDic[@"partnerid"];
    result.prepayid = dataDic[@"prepayid"];
    result.sign = dataDic[@"sign"];
    result.timestamp = [NSString stringWithFormat:@"%@",dataDic[@"timestamp"]];
//    result.timestamp = dataDic[@"timestamp"];
    
    return result;
}
@end




@implementation VersionInfo

+ (instancetype)responseWithDic:(NSDictionary *)dic
{
    NSDictionary *dataDic = dic[@"data"];
    
    VersionInfo *result = [[self alloc] init];
    result.upUrl = dataDic[@"c"];
    if ([dataDic[@"b"] isEqualToString:@"0"]) {
        result.isNeedUpdate = NO;
    }
    else{
        result.isNeedUpdate =YES;
    }
    result.gameVersion = dataDic[@"d"];

  
    //    result.timestamp = dataDic[@"timestamp"];
    
    return result;
}
@end
