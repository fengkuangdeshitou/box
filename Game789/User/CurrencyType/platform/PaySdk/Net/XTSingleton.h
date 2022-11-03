//
//  XTSingleton.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//


#undef	AS_SINGLETON
#define AS_SINGLETON(class) \
+ (instancetype)sharedInstance; \
+ (void)distroyInstance;


#undef	DEF_SINGLETON
#define DEF_SINGLETON(class) \
static class *sharedInstance##class; \
+ (instancetype)sharedInstance { \
    @synchronized (self) { \
        if (sharedInstance##class == nil) { \
            sharedInstance##class = [[self alloc] init]; \
        } \
    } \
    return sharedInstance##class; \
} \
+ (void)distroyInstance { \
    @synchronized (self) { \
        sharedInstance##class = nil; \
    } \
}