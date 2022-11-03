//
//  NSString+Phone.m
//  Game789
//
//  Created by xinpenghui on 2017/9/7.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "NSString+Phone.h"
#import <ifaddrs.h>
#import <resolv.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <net/if_dl.h>

#include <sys/types.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>

#define DUMMY_MAC_ADDR  @"02:00:00:00:00:00"
#define QUERY_NAME      "_apple-mobdev2._tcp.local"
#define MDNS_PORT       5353
#define IOS_WIFI        @"en0"

@implementation NSString(Phone)

- (BOOL)valiMobile {

    if (self.length == 11)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
//    else
//    {
//        /**
//         * 手机号码
//         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//         * 联通：130,131,132,152,155,156,185,186
//         * 电信：133,1349,153,180,189
//         */
//        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9]|9[0-9])\\d{8}$";
//
//        /**
//         10         * 中国移动：China Mobile
//         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//         12         */
//        NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0-27-9]|7[28]|8[2-478]|98)\\d)\\d{7}$";
//
//        /**
//         15         * 中国联通：China Unicom
//         16         * 130、131、132、145、155、156、166、171、175、176、185、186
//         17         */
//        NSString * CU = @"^1(3[0-2]|45|5[256]|66|7[1567]|8[56]|(76))\\d{8}$";
//
//        /**
//         20         * 中国电信：China Telecom
//         21         * 133、1349、149、153、173、177、180、181、189、199
//         22         */
//        NSString * CT = @"^1((33|49|53|77|73|70|8[019]|99)[0-9]|349)\\d{7}$";
//
//        /**
//         25         * 大陆地区固话及小灵通
//         26         * 区号：010,020,021,022,023,024,025,027,028,029
//         27         * 号码：七位或八位
//         28         */
//        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//
//        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//        // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//
//        if(([regextestmobile evaluateWithObject:self] == YES)
//           || ([regextestcm evaluateWithObject:self] == YES)
//           || ([regextestct evaluateWithObject:self] == YES)
//           || ([regextestcu evaluateWithObject:self] == YES)){
//            return YES;
//        }else{
//            return NO;
//        }
//    }
}

//- (BOOL)valiMobile{
//    if (self.length < 11)
//    {
//        return NO;
//    }else{
//
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:self];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:self];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:self];
//
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//    return NO;
//}

- (BOOL)isValidUrl {
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isGifImage {
    
    NSString *ext = self.pathExtension.lowercaseString;
    
    if ([ext isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isGifWithImageData: (NSData *)data {
    if ([[self contentTypeWithImageData:data] isEqualToString:@"gif"]) {
        return YES;
    }
    return NO;
}

- (NSString *)contentTypeWithImageData: (NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            
            if ([data length] < 12) {
                
                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            
            return nil;
            
    }
    
    return nil;
}

-(NSString *)urlAddCompnentForValue:(NSString *)value key:(NSString *)key{
    
    NSMutableString *string = [[NSMutableString alloc]initWithString:self];
    @try {
        NSRange range = [string rangeOfString:@"?"];
        if (range.location != NSNotFound) {//找到了
            //如果?是最后一个直接拼接参数
            if (string.length == (range.location + range.length)) {
                NSLog(@"最后一个是?");
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{//如果不是最后一个需要加&
                if([string hasSuffix:@"&"]){//如果最后一个是&,直接拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                }else{//如果最后不是&,需要加&后拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                }
            }
        }else{//没找到
            if([string hasSuffix:@"&"]){//如果最后一个是&,去掉&后拼接
                string = (NSMutableString *)[string substringToIndex:string.length-1];
            }
            string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    return string.copy;
}

- (NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern
{
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary*attriDict = @{NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@(kern)};
    NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:self attributes:attriDict];

    return attributedString;
}

@end
