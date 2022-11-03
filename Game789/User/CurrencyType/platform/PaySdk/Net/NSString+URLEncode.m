//
//  NSString+URLEncode.m
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "NSString+URLEncode.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "ShareVale.h"

@implementation NSString (URLEncode)
- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}
#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}




// URL转义
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                              kCFStringEncodingGB_18030_2000));
    return encodedString;
}

- (BOOL)isEmptyOrWhitespace
{
    return self == nil || !([self length] > 0) || [[self trimmedWhitespaceString] length] == 0;
}

- (NSString *)trimmedWhitespaceString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmedWhitespaceAndNewlineString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isWeakPswd
{
    NSString *pswdRegEx =
    @"^(?=.*\\d.*)(?=.*[a-zA-Z].*).{6,20}$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pswdRegEx];
    return [regExPredicate evaluateWithObject:self];
}

////验签
//- (BOOL)isSignWithUserName:(NSString *)userName appkey:(NSString *)appkey sinceTime:(NSString *)time
//{
//
//        NSString *sign = [NSString stringWithFormat:@"username=%@&appkey=%@&logintime=%@",userName,appkey,time];
//        sign = [sign md5String];
//        if ([sign isEqualToString:self]) {
//            return YES;
//        } else {
//            return NO;
//        }
//        
//        return YES;
//}

+ (NSString *)getWebViewURLArgument
{
    ShareVale *vale = [ShareVale sharedInstance];
    
//    return vale.userName;
//    NSString *userName = vale.userName;

    //时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
 
//    int signTime = (int)time;
    //拼接验签
    NSString *sign = [NSString stringWithFormat:@"username=%@&appkey=xyst@!sdk&logintime=%.0f",vale.userName,time];
    sign = [sign md5String];
    
    NSString *url = [NSString stringWithFormat:@"?gameid=%@&username=%@&logintime=%.0f&sign=%@",vale.gameID,vale.userName,time,sign];
    

    return url;
}
//图片路径
- (NSString *)getImagePath
{
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:TUUSDK ofType:@"bundle"];
    if (path && path.length>0) {
        return   [NSString stringWithFormat:@"%@.bundle/%@",TUUSDK,self];
    }
    
    return self;
}

//获取TUUSDK.bundle的路径
+ (NSString *)getBundlePath
{
    NSLog(@"is enter getBundlePath ");
    NSString *path =  [[NSBundle mainBundle] pathForResource:TUUSDK ofType:@"bundle"];
    if (path && path.length>0) {
        return path;
    }
    
    return [NSBundle mainBundle].bundlePath;
}
@end
