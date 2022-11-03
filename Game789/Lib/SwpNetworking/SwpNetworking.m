//
//  SwpNetworking.m
//  swp_song
//
//  Created by swp_song on 16/4/7.
//  Copyright © 2016年 swp_song. All rights reserved.
//

#import "SwpNetworking.h"

/*! ---------------------- Tool       ---------------------- !*/
#import "SwpNetworkingTools.h"          // 工具
/*! ---------------------- Tool       ---------------------- !*/

@interface SwpNetworking ()

/*! AFHTTPSessionManager 网络请求管理者对象 !*/
@property (nonatomic, strong) AFHTTPSessionManager *swpSessionManager;

@end

@implementation SwpNetworking


#pragma mark - SwpNetworking Tool Methods
/*!
 *  @author swp_song
 *
 *  @brief  swpPOST:parameters:swpResultSuccess:swpResultError:     ( 请求网络获取数据 <POST> )
 *
 *  @param  URLString                       请求的 url
 *
 *  @param  parameters                      请求 需要传递的参数     ( 和后台一致 )
 *
 *  @param  swpNetworkingSuccess            请求获取数据成功
 *
 *  @param  swpNetworkingError              请求获取数据失败
 */
+ (void)swpPOST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters swpNetworkingSuccess:(SwpNetworkingSuccessHandle)swpNetworkingSuccess swpNetworkingError:(SwpNetworkingErrorHandle)swpNetworkingError ShowHud:(BOOL)isShow {
    
    URLString = [NSString stringWithFormat:@"%@%@", Base_Request_Url, URLString];
    MYLog(@"post请求url: %@, \n post请求参数: %@", URLString, parameters);
    // 初始化自定义网络请求类
    SwpNetworking        *swpNetworking = [SwpNetworking shareInstance];
    // 返回结果集
    __block NSDictionary *result  = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
    
    UIView * view = [UIApplication sharedApplication].keyWindow;
    if (isShow)
    {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
//    NSDictionary * params = @{};
//    if (parameters.count == 0) {
//       params = @{@"data":@500};
//    }else{
//       NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingFragmentsAllowed error:nil];
//       NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//       params = @{@"data":[YYToolModel AES128Encrypt:string key:K_AES_KEY]};
//    }
    // 发起请求
    [swpNetworking.swpSessionManager POST:URLString parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isShow)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        result = [SwpNetworkingTools swpNetworkingToolsRequestDispose:responseObject];
        if ([result objectForKey:@"data"] && [result count] == 1) {
            NSString * string = [YYToolModel AES128Decrypt:result[@"data"] key:K_AES_KEY];
            NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }

        MYLog(@"post请求返回: %@", result);
        swpNetworkingSuccess(task, result);

        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isShow)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        swpNetworkingError(task, error, [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)swpPOSTVideoFile:(NSString *)URLString parameters:(NSDictionary *)parameters name:(NSString *)name fileName:(NSString *)fileName fileData:(NSData *)fileData progress:(SwpNetworkingProgressHandle)progressHandel swpNetworkingSuccess:(SwpNetworkingSuccessHandle)swpNetworkingSuccess swpNetworkingError:(SwpNetworkingErrorHandle)swpNetworkingError{
    
    URLString = [NSString stringWithFormat:@"%@%@", Base_Request_Url, URLString];        
        // 初始化自定义网络请求类
        SwpNetworking        *swpNetworking = [SwpNetworking shareInstance];
        // 返回结果集
        __block NSDictionary *resultObject  = [NSDictionary dictionary];
        
        // 显示 状态栏 请求数据的菊花
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
        
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [YJProgressHUD showProgress:@"上传中..." inView:view];
    //    });
        
        // 发起请求
        [swpNetworking.swpSessionManager POST:URLString parameters:parameters headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"video"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float progress = ((float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
            progressHandel(progress);
            NSLog(@"fractionCompleted====%f",uploadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [YJProgressHUD hide];
    //        });
            resultObject = [SwpNetworkingTools swpNetworkingToolsRequestDispose:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                swpNetworkingSuccess(task, resultObject);
            });
            [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [YJProgressHUD hide];
    //        });
            swpNetworkingError(task, error, [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
            [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
        }];
}

/*!
 *  @author swp_song
 *
 *  @brief  swpPOSTAddFile:parameters:fileName:fileData:swpNetworkingSuccess:swpNetworkingError ( 请求网络获上传文件 单文件上传 <POST> )
 *
 *  @param  URLString                       请求的 url
 *
 *  @param  parameters                      请求 需要传递的参数          ( 可以传 nil )
 *
 *  @param  fileName                        请求 上传文件的名称          ( 和后台一致 )
 *
 *  @param  fileData                        请求 上传文件的数据流
 *
 *  @param  swpNetworkingSuccess            请求获取数据成功
 *
 *  @param  swpNetworkingError              请求获取数据失败
 *
 */
+ (void)swpPOSTAddFile:(NSString *)URLString parameters:(NSDictionary *)parameters fileName:(NSString *)fileName fileData:(NSData *)fileData swpNetworkingSuccess:(SwpNetworkingSuccessHandle)swpNetworkingSuccess swpNetworkingError:(SwpNetworkingErrorHandle)swpNetworkingError ShowHud:(BOOL)isShow {
    
    UIView * view = [UIApplication sharedApplication].keyWindow;
    if (isShow)
    {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    // 初始化自定义网络请求类
    SwpNetworking        *swpNetworking = [SwpNetworking shareInstance];
    // 返回结果集
    __block NSDictionary *resultObject  = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
    
    // 发起请求
    [swpNetworking.swpSessionManager POST:URLString parameters:parameters headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([[parameters objectForKey:@"ImageType"] isEqualToString:@"GIF"]) {
            NSString * str = [NSString stringWithFormat:@"%@.gif", [NSDate getNowTimeTimestamp]];
            [formData appendPartWithFileData:fileData name:fileName fileName:str mimeType:@"image/png"];
        }else{
            NSString * str = [NSString stringWithFormat:@"%@.png", [NSDate getNowTimeTimestamp]];
            [formData appendPartWithFileData:fileData name:fileName fileName:str mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (isShow)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        resultObject = [SwpNetworkingTools swpNetworkingToolsRequestDispose:responseObject];
        MYLog(@"===============%@", resultObject);
        swpNetworkingSuccess(task, resultObject);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isShow)
        {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
        swpNetworkingError(task, error, [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    }];
}

/*!
 *  @author swp_song
 *
 *  @brief  swpPOSTAddFiles:parameters:fileName:fileDatas:swpNetworkingSuccess:swpNetworkingError   ( 请求网络获上传文件 多文件上传, 文件名称相同使用该方法 <POST> )
 *
 *  @param  URLString                       请求的 url
 *
 *  @param  parameters                      请求 需要传递的参数          ( 可以传 nil )
 *
 *  @param  fileName                        请求 上传文件的名称          ( 和后台一致 )
 *
 *  @param  fileDatas                       请求 上传文件的流数组
 *
 *  @param  swpNetworkingSuccess            请求获取数据成功
 *
 *  @param  swpNetworkingError              请求获取数据失败
 *
 */
+ (void)swpPOSTAddFiles:(NSString *)URLString parameters:(NSDictionary *)parameters fileName:(NSString *)fileName fileDatas:(NSArray *)fileDatas swpNetworkingSuccess:(SwpNetworkingSuccessHandle)swpNetworkingSuccess swpNetworkingError:(SwpNetworkingErrorHandle)swpNetworkingError {
    
    // 初始化自定义网络请求类
    SwpNetworking        *swpNetworking = [SwpNetworking shareInstance];
    // 返回结果集
    __block NSDictionary *resultObject  = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
    
    UIView * view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showProgress:@"文件上传中..." toView:view];
    // 发起请求
    [swpNetworking.swpSessionManager POST:URLString parameters:parameters headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileDatas.count; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@[%i]", fileName, i];
            [formData appendPartWithFileData:fileDatas[i] name:imageName fileName:imageName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新
            MYLog(@"%lld----%lld", uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            hud.progressObject = uploadProgress;
            
//            if (uploadProgress.completedUnitCount
//                / uploadProgress.totalUnitCount == 1)
//            {
//                hud.label.text = @"数据上传中...";
//            }
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MYLog(@"===============%@", resultObject);
        [hud hideAnimated:true];
//        [MBProgressHUD hideHUDForView:view animated:YES];
        resultObject = [SwpNetworkingTools swpNetworkingToolsRequestDispose:responseObject];
        swpNetworkingSuccess(task, resultObject);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:true];
//        [MBProgressHUD hideHUDForView:view animated:YES];
        swpNetworkingError(task, error, [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    }];
    
}

/*!
 *  @author swp_song
 *
 *  @brief  swpPOSTAddWithFiles:parametersfileNames:fileDatas:swpNetworkingSuccess:swpNetworkingSuccess:swpNetworkingError: ( 请求网络获上传文件 多文件上传, 文件名称不相同相同使用该方法  <POST> )
 *
 *  @param  URLString                       请求的 url
 *
 *  @param  parameters                      请求 需要传递的参数          ( 可以传 nil )
 *
 *  @param  fileNames                       请求 上传文件的名称数组      ( 和后台一致 )
 *
 *  @param  fileDatas                       请求 上传文件的流数组
 *
 *  @param  swpNetworkingSuccess            请求获取数据成功
 *
 *  @param  swpNetworkingError              请求获取数据失败
 */
+ (void)swpPOSTAddWithFiles:(NSString *)URLString parameters:(NSDictionary *)parameters fileNames:(NSArray *)fileNames fileDatas:(NSArray *)fileDatas swpNetworkingSuccess:(SwpNetworkingSuccessHandle)swpNetworkingSuccess swpNetworkingError:(SwpNetworkingErrorHandle)swpNetworkingError {
    
    // 初始化自定义网络请求类
    SwpNetworking        *swpNetworking = [SwpNetworking shareInstance];
    // 返回结果集
    __block NSDictionary *resultObject  = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
    
    // 发起请求
    [swpNetworking.swpSessionManager POST:URLString parameters:parameters headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<fileDatas.count; i++) {
            [formData appendPartWithFileData:fileDatas[i] name:fileNames[i] fileName:fileNames[i] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resultObject = [SwpNetworkingTools swpNetworkingToolsRequestDispose:responseObject];
        swpNetworkingSuccess(task, resultObject);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        swpNetworkingError(task, error, [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    }];
    
}

/*!
 *  @author swp_song
 *
 *  @brief  swpDownloadFile:swpDownloadProgress:swpCompletionHandler:   ( 请求网络 < 下载图片方法 > )
 *
 *  @param  URLString                       请求的 url
 *
 *  @param  swpDownloadProgress             下载进度
 *
 *  @param  swpCompletionHandler            下载回调    ( 成功 | 失败 回调, 成功 Error 为 nil )
 */
+ (void)swpDownloadFile:(NSString *)URLString swpDownloadProgress:(void(^)(SwpDownloadProgress swpDownloadProgress))swpDownloadProgress swpCompletionHandler:(void(^)(NSString *filePath, NSString *fileName,  NSString *error))swpCompletionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest       *request       = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    AFHTTPSessionManager      *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    // 发起 请求
    [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:YES];
    NSURLSessionDownloadTask *downloadTask   = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        swpDownloadProgress(SwpDownloadProgressMake(downloadProgress.fractionCompleted, downloadProgress.totalUnitCount, downloadProgress.completedUnitCount));
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 返回 文件 路径
        NSURL *pathURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *downloadFilePath = [SwpNetworkingTools swpNetworkingToolsDownloadFilePathDispose:filePath];
        if (error) [[NSFileManager defaultManager] removeItemAtPath:downloadFilePath error:nil];
        swpCompletionHandler(downloadFilePath, [SwpNetworkingTools swpNetworkingToolsGetDownloadFileName:filePath], [SwpNetworkingTools swpNetworkingToolsGetErrorMessage:error]);
        [SwpNetworkingTools swpNetworkingToolsSetNetworkActivityIndicatorVisible:NO];
    }];
    
    // 开始 请求
    [downloadTask resume];
}


/*!
 *  @author swp_song
 *
 *  @brief  swpNetworkingReachabilityStatusChangeBlock: ( 验证 网路 环境 )
 *
 *  @param  swpNetworkingStatus
 */
+ (void)swpNetworkingReachabilityStatusChangeBlock:(void(^)(SwpNetworkingReachabilityStatus swpNetworkingStatus))swpNetworkingStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                swpNetworkingStatus(SwpNetworkingReachabilityStatusUnknown);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                swpNetworkingStatus(SwpNetworkingReachabilityStatusNotReachable);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                swpNetworkingStatus(SwpNetworkingReachabilityStatusReachableViaWWAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                swpNetworkingStatus(SwpNetworkingReachabilityStatusReachableViaWiFi);
                break;
            default:
                break;
        }
    }];
}


/*!
 *  @author swp_song
 *
 *  @brief swpAFNetworkingTest:parametersisEncrypt:  ( AFNetworking 测试方法 )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 */
+ (void)swpAFNetworkingTest:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSLog(@"This is AFNetworking Test Method");
}

#pragma mark - Init SwpNetworking Method
/*!
 *  @author swp_song, 2016-04-07 14:03:50
 *
 *  @brief  shareInstance       ( 单利 快速初始化一个 SwpNetworking )
 *
 *  @return SwpNetworking
 */
+ (instancetype)shareInstance {
    
    static SwpNetworking *swpNetworking = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        swpNetworking = [[self alloc] init];
    });
    return swpNetworking;
}
/*!
 *  @author swp_song, 2016-04-07 14:05:24
 *
 *  @brief  init    ( Init Override )
 *
 *  @return swpNetworking
 */
- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

#pragma Init AFHTTPSessionManager Method
- (AFHTTPSessionManager *)swpSessionManager {
    
//    if (!_swpSessionManager) {
        _swpSessionManager                    = [AFHTTPSessionManager manager];
        _swpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_swpSessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/css", @"text/javascript", nil]];
    
        _swpSessionManager.requestSerializer.timeoutInterval = 40;
    
        NSString *authID = [YYToolModel getUserdefultforKey:@"token"];
        if (authID) {
            [_swpSessionManager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
            [_swpSessionManager.requestSerializer setValue:[YYToolModel getUserdefultforKey:@"user_name"] forHTTPHeaderField:@"username"];
        }
        //af设置请求头
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].channel forHTTPHeaderField:@"channel"];
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].deviceType forHTTPHeaderField:@"device-type"];
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].deviceVersion forHTTPHeaderField:@"device-version"];
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].ffOpenUDID forHTTPHeaderField:@"IMEI"];
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].deviceSize forHTTPHeaderField:@"device-size"];
        [_swpSessionManager.requestSerializer setValue:[DeviceInfo shareInstance].deviceModel forHTTPHeaderField:@"device-name"];
        NSString * timestamp = [NSDate getNowTimeTimestamp];
        NSString * md5Str = [YYToolModel md5EncryptionForRequest:timestamp];
        [_swpSessionManager.requestSerializer setValue:timestamp forHTTPHeaderField:@"request-timestamp"];
        [_swpSessionManager.requestSerializer setValue:md5Str forHTTPHeaderField:@"encryption"];
        [_swpSessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"task-version"];
    
//    }
    return _swpSessionManager;
}

@end
