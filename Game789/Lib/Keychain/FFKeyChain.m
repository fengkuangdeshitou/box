//
//  FFKeyChain.m
//  FFFoundation
//
//  Created by dash on 16/4/7.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import "FFKeyChain.h"

@implementation FFKeyChain

+ (NSMutableDictionary *)keychainStorageDataWithKey:(NSString *)key
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 (__bridge_transfer id)kSecClassGenericPassword,
                                 (__bridge_transfer id)kSecClass,
                                 key,
                                 (__bridge_transfer id)kSecAttrService,
                                 key,
                                 (__bridge_transfer id)kSecAttrAccount,
                                 (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
                                 (__bridge_transfer id)kSecAttrAccessible,
                                 nil];
    return dict;
}

+ (void)saveWithKey:(NSString *)key
               data:(id)data
{
    NSMutableDictionary *dict = [self keychainStorageDataWithKey:key];
    SecItemDelete((__bridge_retained CFDictionaryRef)dict);
    [dict setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)dict, NULL);
}

+ (id)loadDataWithKey:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *dict = [self keychainStorageDataWithKey:key];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [dict setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)dict, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)deleteDataWithKey:(NSString *)key
{
    NSMutableDictionary *dict = [self keychainStorageDataWithKey:key];
    SecItemDelete((__bridge_retained CFDictionaryRef)dict);
}

@end
