//
//  BaseModel.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *detail;
@property (nonatomic, copy) NSString * Id;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
