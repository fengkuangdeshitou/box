//
//  Moment.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Moment.h"

@implementation Moment

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if([key isEqualToString:@"id"])
    {
        self.Id = value;
        
        return;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]])
    {
        [super setValue:@"" forKey:key];
        return;
    }
    
    if (!value)
    {
        [super setValue:@"" forKey:key];
        return;
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"<null>"])
        {
            [super setValue:@"" forKey:key];
            return;
        }
    }
    
    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    
    return self;
}

- (void)setReply_list:(NSArray *)reply_list
{
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dic in reply_list)
    {
        Comment * comment = [[Comment alloc] initWithDictionary:dic];
        [array addObject:comment];
    }
    _reply_list = array;
}

@end
