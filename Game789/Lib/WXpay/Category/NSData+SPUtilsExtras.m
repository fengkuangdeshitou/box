
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "NSData+SPUtilsExtras.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (SPUtilsExtras)


/**
 * Calculate an md5 hash using CC_MD5.
 *
 * @returns The md5 hash of this data.
 */

- (NSString *)md5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (uint32_t)[self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15]
            ];
}

@end
