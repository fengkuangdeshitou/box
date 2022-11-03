//
//  FFKeyChain.h
//  FFFoundation
//
//  Created by dash on 16/4/7.
//  Copyright © 2016年 wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFKeyChain : NSObject

+ (NSMutableDictionary *)keychainStorageDataWithKey:(NSString *)key;

+ (void)saveWithKey:(NSString *)key
               data:(id)data;

+ (id)loadDataWithKey:(NSString *)key;

+ (void)deleteDataWithKey:(NSString *)key;

@end
