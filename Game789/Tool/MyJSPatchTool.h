//
//  MyJSPatchTool.h
//  Game789
//
//  Created by Maiyou on 2019/1/19.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyJSPatchTool : NSObject

@property (nonatomic, strong) NSMutableData * fileData;

+ (instancetype)shareJSPatch;

/**
 获取热更补丁数据
 */
- (void)getJspatchData;

@end

NS_ASSUME_NONNULL_END
