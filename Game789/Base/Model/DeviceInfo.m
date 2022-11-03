//
//  DeviceInfo.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "DeviceInfo.h"
#import "FFKeyChain.h"
#import <UIKit/UIDevice.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

static NSString *FFOpenUDIDKey = @"FFOpenUDIDKey";

@implementation DeviceInfo
static DeviceInfo* _instance = nil;
+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    });
    return _instance ;
}

- (NSString *)test {
    return  @"Apple Store";
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [DeviceInfo shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [DeviceInfo shareInstance] ;
}

- (NSString *)bundleId
{
    NSDictionary *data = [[NSBundle mainBundle] infoDictionary];
    NSString *content = [data objectForKey:@"CFBundleIdentifier"];
    return content;
}

- (NSString *)channelTag
{
    NSDictionary *data = [[NSBundle mainBundle] infoDictionary];
    NSString *content = [data objectForKey:@"channelTag"];
    MYLog(@"channelTag : %@", content);
    return content;
}

- (BOOL)isTFSigin
{
    NSDictionary *data = [[NSBundle mainBundle] infoDictionary];
    NSString *content = [data objectForKey:@"TFSign"];
    MYLog(@"TFSigin : %@", content);
    return content.boolValue;
}

- (NSString *)myGameId
{
    NSString *gameid = nil;
    //获取签名后agent文件内容
    NSString *fileType = [self getChannelFileName:@"gameid"];
    if (fileType && fileType.length > 0) {
        gameid = fileType;
    }
    return gameid;
}

- (NSString *)deviceUDID
{
    NSString *channels = [YYToolModel getUserdefultforKey:MILU_UDID];
    if (channels == NULL)
    {
        //获取签名后agent文件内容
        NSString *fileType = [self getChannelFileName:@"udid"];
        if (fileType && fileType.length > 0) {
            channels = fileType;
        }
    }
    return channels;
    
//    return @"00008101-00060CC91402001E";
}

- (BOOL)isGameVip
{
    NSDictionary *data = [[NSBundle mainBundle] infoDictionary];
    NSString *content = [data objectForKey:@"miluVipApp"];
    if (content.intValue == 1)
    {
        return YES;
    }
    return NO;
}

- (NSString *)bdvid
{
    NSString *vid = @"";
    vid = [self getChannelFileName:@"bdvid"];
    return vid;
}

- (NSString *)channel
{
    NSString *channels = @"wf8z";
    //获取渠道文件内容
    NSString *fileType = [self getFileContent:@"TUUChannel"];
    //获取签名后agent文件内容
    NSString *fileType2 = [self getChannelFileName:@"agent"];
    //TF签名
    NSString *fileType1 = [YYToolModel getUserdefultforKey:@"UMLinkGetAgent"];
    if (fileType2 && fileType2.length > 0)//签名打入包里面的渠道号
    {
        channels = fileType2;
    }
    else if (fileType1 && fileType1.length > 0 && self.isTFSigin)//TF签名存储渠道号
    {
        channels = fileType1;
    }
    else if (fileType && fileType.length > 0)//项目里面存储的默认渠道号
    {
        channels = fileType;
    }
    return channels;
}

/**  友盟渠道  */
- (NSString *)umchannel
{
    NSString *channels = [self channel];
    NSString *fileType = [self getFileContent:@"UMChannel"];
    NSString *fileType1 = [self getNewChannelData:@"UMChannel"];
    if (fileType1 && fileType1.length > 0) {
        channels = fileType1;
    }
    else if (fileType && fileType.length > 0) {
        channels = fileType;
    }
    return channels;
}

/**  友盟统计appkey  */
- (NSString *)umAppkey
{
    NSString *appkey = @"";
    NSString *fileType = [self getFileContent:@"UMAppKey"];
    NSString *fileType1 = [self getNewChannelData:@"UMAppKey"];
    if (fileType1 && fileType1.length > 0) {
        appkey = fileType1;
    }
    else if (fileType && fileType.length > 0) {
        appkey = fileType;
    }
    else
    {
        if ([DeviceInfo shareInstance].channelTag.integerValue == 1)
        {
            //985手游
            appkey = @"59e81144677baa73640008ea";
        }
        else if ([DeviceInfo shareInstance].channelTag.integerValue == 2)
        {
            appkey = @"5eb91882978eea078b7e9f49";
        }
        else if ([DeviceInfo shareInstance].channelTag.integerValue == 3)
        {
            appkey = @"59e811a3677baa192400083c";
        }
        else
        {
            appkey = @"59ba3e65bbea8323ec000012";
        }
    }
    return appkey;
}

- (NSString *)getChannelFileName:(NSString *)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"myData" ofType:@""];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * arr = [fm  contentsOfDirectoryAtPath:filePath error:nil];
    if (arr.count > 0)
    {
        for (NSString * str in arr)
        {
            if ([str containsString:@"agent_"] && [type isEqualToString:@"agent"]) {
                NSRange range = [str rangeOfString:@"_"];
                NSString * channel = [str substringFromIndex:range.location + 1];
                if (channel.length > 0)
                {
                    return channel;
                }
            }
            else if ([str containsString:@"udid_"] && [type isEqualToString:@"udid"])
            {
                NSRange range = [str rangeOfString:@"_"];
                NSString * udid = [str substringFromIndex:range.location + 1];
                if (udid.length > 0)
                {
                    return udid;
                }
            }
            else if ([str containsString:@"gameid_"] && [type isEqualToString:@"gameid"])
            {
                NSRange range = [str rangeOfString:@"_"];
                NSString * gameid = [str substringFromIndex:range.location + 1];
                if (gameid.length > 0)
                {
                    return gameid;
                }
            }
            else if ([str containsString:@"bdvid_"] && [type isEqualToString:@"bdvid"])
            {
                NSRange range = [str rangeOfString:@"_"];
                NSString * bdvid = [str substringFromIndex:range.location + 1];
                if (bdvid.length > 0)
                {
                    return bdvid;
                }
            }
        }
    }
    return @"";
}

/**  获取本地文件内容  */
- (NSString *)getFileContent:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSLog(@"获取%@的文件内容是:%@", fileName, content);
    return content;
}

/**  获取_CodeSignature文件夹下面的文件内容  */
- (NSString *)getNewChannelData:(NSString *)fileName
{
    //资源包路径
    NSString *bunPath = [[NSBundle mainBundle]bundlePath];
    //获取资源包下所有文件的子路径
    //    NSArray *pathArray = [[NSFileManager defaultManager]subpathsAtPath:bunPath];
    //拼接CodeResources路径
    NSString *codePath = [bunPath stringByAppendingPathComponent:[NSString stringWithFormat:@"_CodeSignature/%@", fileName]];
    //数据读取
    NSString *content = [NSString stringWithContentsOfFile:codePath encoding:NSUTF8StringEncoding error:nil];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return content;
}

//- (NSString *)getChannelData {
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
//    NSString* thepath = [paths lastObject];
//    thepath = [thepath stringByAppendingPathComponent:@"TUUChannel"];
//    NSLog(@"桌面目录：%@", thepath);
//    NSFileManager* fm = [NSFileManager defaultManager];
//    NSData* data = [[NSData alloc] init];
//    data = [fm contentsAtPath:thepath];
//    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//
//    //第二种方法： NSData类方法读取数据
//    data = [NSData dataWithContentsOfFile:thepath];
//    NSLog(@"NSData类方法读取的内容是：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//
//    //第三种方法： NSString类方法读取内容
//    NSString* content = [NSString stringWithContentsOfFile:thepath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"NSString类方法读取的内容是：\n%@",content);
//    return content;
//}

- (NSString *)deviceType {
    return @"10";
}

- (NSString *)deviceSize
{
    if (IS_IPHONE_Xs_Max)
    {
        return @"1";
    }
    else if (IS_iPhone_Plus)
    {
        return @"2";
    }
    else if (IS_iPhone_Normal)
    {
        return @"3";
    }
    else if (IS_iPhone_5)
    {
        return @"4";
    }
    else if (IS_IPHONE_Xs || IS_iPhoneX)
    {
        return @"5";
    }
    else if (IS_IPHONE_Xr)
    {
        return @"6";
    }
    else
    {
        return @"0";
    }
}

- (NSString *)deviceVersion {
    
    NSString * str = [NSString stringWithFormat:@"%@%@", [[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    return str;
}

- (NSString *)ffOpenUDID
{
    NSString *ffudid = [FFKeyChain loadDataWithKey:FFOpenUDIDKey];
    if (ffudid.length <= 0) {
        ffudid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [FFKeyChain saveWithKey:FFOpenUDIDKey
                           data:ffudid];
    }
    return ffudid;
}

- (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow(infoDictionary);
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    // app build版本
    return app_Version;
}

- (NSString *)appDisplayVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    return app_Version;
}

- (NSString *)appDisplayName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}


// 缓存大小
- (float)folderSizes
{
//    float folderSize = 0.0;
    //获取路径
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
//
//    //获取所有文件的数组
//    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
//
//    NSLog(@"文件数：%ld",files.count);
//
//    for(NSString *path in files) {
//
//        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
//
//        //累加
//        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
//    }
//    //转换为M为单位
//    float sizeM = folderSize /1024.0/1024.0;
    
    //获取缓存图片的大小(字节)
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] totalDiskSize];
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float sizeM = bytesCache/1000/1000;

    return sizeM;
}

- (NSInteger)downLoadStyle
{
    NSString * style = [YYToolModel getUserdefultforKey:DOWN_STYLE];
    if (style == NULL)
    {
        return 0;
    }
    return style.integerValue;
}

- (NSInteger)is_new_ui
{
    NSString * isNew = [YYToolModel getUserdefultforKey:NEW_TABBAR_UI];
    if (isNew == NULL)
    {
        return 0;
    }
    return isNew.integerValue;
}

- (NSInteger)is_close_trade
{
    NSString * isClose = [YYToolModel getUserdefultforKey:IS_CLOSE_TRADE];
    if (isClose == NULL)
    {
        return 0;
    }
    return isClose.integerValue;
}

- (BOOL)isOpenYouthMode
{
    NSString * youthMode = [YYToolModel getUserdefultforKey:@"MyYouthMode"];
    if (youthMode == NULL)
    {
        return NO;
    }
    return youthMode.boolValue;
}

- (BOOL)isContainAgent
{
    NSArray * array = @[@"jx55",@"1mwr",@"w8ue",@"a4dt",@"e721",@"vn96",@"xqn1",@"9dqd",@"byt6",@"b20p",@"01zm",@"90ax",@"3wn5",@"gv8z",@"ki56",@"yuu5",@"r7tv",@"y415",@"k83f",@"pw81",@"yih3",@"5isp",@"c2gv",@"1bdg",@"u95m",@"ad0k",@"et1o",@"sq1b",@"4aw4",@"3oo7",@"ja09",@"0i4c",@"5guk",@"bx67",@"0ive",@"wjz4",@"8yxj",@"4ssy",@"3zn7",@"rc2o",@"knc5",@"8z12",@"1ibo",@"rg4h",@"khh9",@"5t6q",@"dwq2",@"d02w",@"hdx5",@"f276",@"i6a3",@"39tg",@"6saf",@"ww0p",@"m98j",@"k45z",@"uc8e",@"51kx",@"d4ah",@"px5s",@"po1q",@"b4sz",@"z8kh",@"gb4r",@"m7ts",@"a3vq",@"xeb9",@"y7ej",@"9gvr",@"j5cp",@"wa8p",@"xwd4",@"pt5x",@"l8q2i",@"2he1",@"t44d",@"h9xn",@"ty5z",@"660n",@"gy12",@"8qn1",@"qx23",@"l82l",@"p42z",@"cux3",@"3qvh",@"9lf0",@"mk6z",@"f2s2",@"2wi2",@"137y",@"8chx",@"195v9",@"996d",@"h7qh",@"4y20",@"pj8f",@"4dzol",@"kwf0",@"o6ad",@"82yz",@"fz8v",@"z09i",@"zq3t",@"59w9",@"agn0",@"yr9y",@"1bvt",@"8zxg",@"pie0",@"b7s9",@"7pd9",@"chm2",@"7fuq",@"61hj",@"k7yr",@"k9o2",@"h5s0",@"4o85",@"g8ux",@"jyd3",@"u8hf",@"r6rm",@"6n3g",@"w091",@"l5b9",@"mae5",@"9qf5",@"74oe",@"8m7q",@"0u3s",@"ffm8",@"k6ez",@"33l1",@"wb1q",@"dv8j",@"tep3",@"t7pu",@"2l9v",@"j90c",@"q5jx",@"uj98",@"66o0",@"2h6s",@"61sm",@"mq47",@"ux7x",@"fk1c",@"5el2",@"9pv3",@"yk4b",@"xy1j",@"hb2r",@"kl9s3",@"j1cp",@"j1mw",@"dz4e",@"2mge",@"7n91",@"9lny",@"3zpi",@"oc3x",@"f767",@"16pd",@"hy5a",@"nw3q",@"07l0",@"yq02",@"f5u4",@"yr7y",@"2zgt",@"ah80",@"e28q",@"5iwd",@"ay60",@"on88",@"rkz2",@"sx0g",@"kn3x",@"m5my",@"hy63",@"6h2c",@"7a51",@"e7ug",@"nc0e",@"2a1o",@"2bo8",@"i4xj",@"jps3",@"1fw1",@"ig88",@"06qw",@"h11l",@"411p",@"q6ra",@"u9su",@"1yoz",@"uqk6",@"ss1o",@"4msg",@"h6oj",@"7x9f",@"xl39",@"9sj1",@"egf6",@"w85d",@"51y5",@"i4zl",@"v2oz",@"ji7n",@"k9w3",@"h68z",@"os40",@"yq34",@"v2pc",@"p3jy",@"vcl5",@"6cxs",@"5uwr",@"39rf",@"r7og",@"3wqg",@"3m9e",@"26mt",@"y122",@"mi8l",@"8d4x",@"znn1",@"xh9q",@"a09z",@"7l51",@"j9o6",@"v3pq",@"3i5q",@"n56p",@"ra0b",@"12s6",@"dk66",@"rsv2",@"u5wx",@"y6ef",@"w1fu",@"26id",@"tm44",@"2thl",@"m3ql",@"8ds1",@"w5b0",@"92wk",@"94zf",@"o19i",@"16zz",@"t4l8",@"uxa1",@"6kgr",@"9py8"];
    if ([array containsObject:self.channel] || [[[DeviceInfo shareInstance] getFileContent:@"TUUChannel"] isEqualToString:@"ue70"])
    {
        return YES;
    }
    return NO;
}

- (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"]) return @"iPhone SE (2nd generation)";
    if ([deviceModel isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    if ([deviceModel isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([deviceModel isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([deviceModel isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([deviceModel isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";
    if ([deviceModel isEqualToString:@"iPod9,1"])      return @"iPod Touch (7 Gen)";
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad11,1"])      return @"iPad Mini 5 (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad11,2"])      return @"iPad Mini 5 (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad14,1"])      return @"iPad Mini 6 (6 Gen)";
    if ([deviceModel isEqualToString:@"iPad14,2"])      return @"iPad Mini 6 (6 Gen)";
    
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 (2 Gen)";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 (2 Gen)";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
    if ([deviceModel isEqualToString:@"iPad8,1"])      return @"iPad Pro 11.0";
    if ([deviceModel isEqualToString:@"iPad8,2"])      return @"iPad Pro 11.0";
    if ([deviceModel isEqualToString:@"iPad8,3"])      return @"iPad Pro 11.0";
    if ([deviceModel isEqualToString:@"iPad8,4"])      return @"iPad Pro 11.0";
    if ([deviceModel isEqualToString:@"iPad8,5"])      return @"iPad Pro 12.9 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,6"])      return @"iPad Pro 12.9 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,7"])      return @"iPad Pro 12.9 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,8"])      return @"iPad Pro 12.9 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,9"])      return @"iPad Pro 11.0 (2 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,10"])      return @"iPad Pro 11.0 (2 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,11"])      return @"iPad Pro 12.9 (4 Gen)";
    if ([deviceModel isEqualToString:@"iPad8,12"])      return @"iPad Pro 12.9 (4 Gen)";
    
    if ([deviceModel isEqualToString:@"iPad13,4"])      return @"iPad Pro 11.0 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,5"])      return @"iPad Pro 11.0 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,6"])      return @"iPad Pro 11.0 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,7"])      return @"iPad Pro 11.0 (3 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,8"])      return @"iPad Pro 12.9 (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,9"])      return @"iPad Pro 12.9 (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,10"])      return @"iPad Pro 12.9 (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad13,11"])      return @"iPad Pro 12.9 (5 Gen)";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

@end
