//
// NSString+MD5.h
// Originally created for MyFile
//
// Created by Árpád Goretity, 2011. Some infos were grabbed from StackOverflow.
// Released into the public domain. You can do whatever you want with this within the limits of applicable law (so nothing nasty!).
// I'm not responsible for any damage related to the use of this software. There's NO WARRANTY AT ALL.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define salt_key @"985game_api_nFWn18Wm"

@interface NSString (MD5)

// MD5 hash of the file on the filesystem specified by path
//+ (NSString *) stringWithMD5OfFile: (NSString *) path;
// The string's MD5 hash

//语言本地化参数
@property (nonatomic, copy) NSString *localized;

/**  文字竖着排  */
- (NSString *)VerticalString;


- (NSString *) MD5Hash;
/**  32位大写  */
- (NSString *)md5_32bit;
/**  32位小写  */
- (NSString *)md5HashToLower32Bit;

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
- (NSString *)URLDecodedString;

/**  判断字符串是否为空  */
- (BOOL)isBlankString;


/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;


@end

