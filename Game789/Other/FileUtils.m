//
//  FileUtils.m
//  Game789
//
//  Created by xinpenghui on 2017/9/25.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

//返回缓存根目录 "caches"
+(NSString *)getCachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = [paths firstObject];
    return caches;
}

//返回根目录路径 "document"
+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    return documentPath;
}

//创建文件目录
+(BOOL)creatDir:(NSString*)dirPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath])//判断dirPath路径文件夹是否已存在，此处dirPath为需要新建的文件夹的绝对路径
    {
        return NO;
    }
    else
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        return YES;
    }

}

//删除文件目录
+(BOOL)deleteDir:(NSString*)dirPath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:dirPath])//如果存在临时文件的配置文件

    {
        NSError *error=nil;
        return [[NSFileManager defaultManager]  removeItemAtPath:dirPath error:&error];

    }

    return  NO;
}
+ (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {

        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];

        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }

    //读取缓存大小
//    float cacheSize = [self readCacheSize] *1024;
//    self.cacheSize.text = [NSString stringWithFormat:@"%.2fKB",cacheSize];

}
//移动文件夹
+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath;
{
    NSError *error=nil;
    if([[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:desPath error:&error]!=YES)// prePath 为原路径、     cenPath 为目标路径
    {
        NSLog(@"移动文件失败");
        return NO;
    }
    else
    {
        NSLog(@"移动文件成功");
        return YES;
    }
}

//创建文件
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data
{

    return  [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}

//读取文件
+(NSData*)readFile:(NSString *)filePath
{
    return [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
}

//删除文件
+(BOOL)deleteFile:(NSString *)filePath
{

    return [self deleteDir:filePath];

}

+ (NSString *)getFilePath:(NSString *)fileName
{
    NSString *dirPath = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    return dirPath;
}


+ (BOOL)writeDataToFile:(NSString*)fileName data:(NSData*)data
{
    NSString *filePath=[self getFilePath:fileName];
    NSLog(@"filePath==== %@",filePath);
    return [self creatFile:filePath withData:data];
}

+ (NSData*)readDataFromFile:(NSString*)fileName
{
    NSString *filePath=[self getFilePath:fileName];
    return [self readFile:filePath];
}

@end
