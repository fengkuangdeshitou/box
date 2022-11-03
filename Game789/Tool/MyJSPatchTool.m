//
//  MyJSPatchTool.m
//  Game789
//
//  Created by Maiyou on 2019/1/19.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyJSPatchTool.h"
#import "MyJSPatchApi.h"

@implementation MyJSPatchTool

+ (instancetype)shareJSPatch
{
    static MyJSPatchTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        tool = [[MyJSPatchTool alloc] init];
    });
    return tool;
}

- (void)getJspatchData
{
    if ([YYToolModel getUserdefultforKey:@"JsPatchMark"] == NULL)
    {
        [YYToolModel deleteUserdefultforKey:@"JSPatchUpdateData"];
        [YYToolModel saveUserdefultValue:@"1" forKey:@"JsPatchMark"];
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/main.js"];
        if ([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
    [self getJspatchFilePath];
    
    MyJSPatchApi * api = [[MyJSPatchApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        MYLog(@"%@", request.data);
        
        NSDictionary * dic = [request.data deleteAllNullValue];
        NSString * patch_account = dic[@"patch_account"];
        NSString * user_name = [YYToolModel getUserdefultforKey:@"user_name"];
        if ([patch_account length] > 0)
        {
            if ([patch_account containsString:@","])
            {
                NSArray * array = [patch_account componentsSeparatedByString:@","];
                if ([array containsObject:user_name])
                {
                    [self performUpdate:dic];
                }
            }
            else
            {
                if ([user_name isEqualToString:patch_account])
                {
                    [self performUpdate:dic];
                }
            }
        }
        else
        {
            [self performUpdate:dic];
        }
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)performUpdate:(NSDictionary *)dic
{
    NSDictionary * localDic = [YYToolModel getUserdefultforKey:@"JSPatchUpdateData"];
    if ([dic[@"app_version_code"] isEqualToString:[DeviceInfo shareInstance].appDisplayVersion])
    {
        if (localDic == NULL)
        {
            if (![YYToolModel isBlankString:dic[@"patch_url"]])
            {
                [self downloadFile:dic];
            }
        }
        else
        {
            //补丁版本大于当前版本,进行更新
            if ([dic[@"patch_code"] integerValue] > [localDic[@"patch_code"] integerValue] && dic[@"patch_url"])
            {
                [self downloadFile:dic];
            }
        }
    }
}

- (NSString *)getJspatchFilePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/main.js"];
    MYLog(@">>>>%@", path);
    if ([fileManager fileExistsAtPath:path])
    {
        [self startEngine];
    }
    return path;
}

- (void)startEngine
{
    [JPEngine startEngine];
    NSString *sourcePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/main.js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
}

#pragma mark -文件下载-
- (void)downloadFile:(NSDictionary *)dic
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:dic[@"patch_url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%f", 1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString * fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/main.js"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:fullPath error:nil];
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        if (!error)
        {
            [YYToolModel saveUserdefultValue:dic forKey:@"JSPatchUpdateData"];
            
            [self startEngine];
        }
    }];
    
    //3.执行Task
    [download resume];
}


@end
