//
//  MyGetQuestionModel.m
//  Game789
//
//  Created by Maiyou on 2019/3/1.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGetQuestionModel.h"

@implementation MyGetQuestionModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if([key isEqualToString:@"id"])
    {
        self.question_id = value;
        
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

@end
