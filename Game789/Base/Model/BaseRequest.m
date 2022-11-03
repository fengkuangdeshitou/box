//
//  BaseRequest.m
//  LoveViteApp
//
//  Created by weiheng on 2017/6/19.
//  Copyright © 2017年 ven. All rights reserved.
//

#import "BaseRequest.h"
#import "AFNetworking.h"
#import "MBProgressHUD+QNExtension.h"
#import "macro.h"
#import "DeviceInfo.h"
#import "MyUserAgreementView.h"
#import <WebKit/WebKit.h>

@interface BaseRequest ()

@property(nonatomic,strong)WKWebView* webView;

@end

@implementation BaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestTimeOutInterval = 40.f;
        self.baseURL = Base_Request_Url;
        self.constructionBodyBlock = nil;
        self.count = 10;
    }
    return self;
}

-(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
   
   NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

   NSRange range = {0,jsonString.length};
   //去掉字符串中的空格
   [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
   NSRange range2 = {0,mutStr.length};
   //去掉字符串中的换行符
   [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return jsonString;
}

- (void)startWithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure
{
    RequestMethod requestMethod = self.requestMethod;
    NSString *url = [self requestUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
   NSDictionary * params = [self requestParameters];
//    NSDictionary * dict = [self requestParameters];
//    NSDictionary * params = @{};
//    if (dict.count == 0) {
//       params = @{@"data":@500};
//    }else{
//       NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:nil];
//       NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//       params = @{@"data":[YYToolModel AES128Encrypt:string key:K_AES_KEY]};
//    }
    NSURLSessionDataTask *requestTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    if (authID) {
        [manager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
    }
    manager.requestSerializer.timeoutInterval = self.requestTimeOutInterval;
    //af设置请求头
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].channel forHTTPHeaderField:@"channel"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceType forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceVersion forHTTPHeaderField:@"device-version"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].ffOpenUDID forHTTPHeaderField:@"IMEI"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].appVersion forHTTPHeaderField:@"sdk-version"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceSize forHTTPHeaderField:@"device-size"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceModel forHTTPHeaderField:@"device-name"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceUDID forHTTPHeaderField:@"udid"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"task-version"];
   [manager.requestSerializer setValue:[DeviceInfo shareInstance].bdvid forHTTPHeaderField:@"bd-vid"];
   if ([YYToolModel getUserdefultforKey:MY_BAIDU_OCPC] == NULL)
   {
      [manager.requestSerializer setValue:[DeviceInfo shareInstance].tk?:@"" forHTTPHeaderField:@"tk"];
      [manager.requestSerializer setValue:[DeviceInfo shareInstance].tk_url?:@"" forHTTPHeaderField:@"tk-url"];
   }
   
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceIdfa ?: idfa forHTTPHeaderField:@"idfa"];
   
   NSString * ua = [DeviceInfo shareInstance].uastr;
   if (ua)
   {
      [manager.requestSerializer setValue:ua forHTTPHeaderField:@"uastr"];
   }
   else
   {
      dispatch_async(dispatch_get_main_queue(), ^{
         self.webView = [[WKWebView alloc]initWithFrame:CGRectZero];
         [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable userAgentString, NSError * _Nullable error) {
            [DeviceInfo shareInstance].uastr = userAgentString;
            [manager.requestSerializer setValue:userAgentString forHTTPHeaderField:@"uastr"];
         }];
      });
   }
   
   
   //加密
   NSString * timestamp = [NSDate getNowTimeTimestamp];
   NSString * md5Str = [YYToolModel md5EncryptionForRequest:timestamp];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"request-timestamp"];
    [manager.requestSerializer setValue:md5Str forHTTPHeaderField:@"encryption"];
   
    NSString * username = [YYToolModel getUserdefultforKey:@"user_name"];
    if (username == NULL)
    {
        username = @"";
    }
    [manager.requestSerializer setValue:username forHTTPHeaderField:@"username"];
    if (self.isShow)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
           UIView * view = [UIApplication sharedApplication].delegate.window;
           [YJProgressHUD showCustomAnimation:@"" withImgArry:[YYToolModel gifChangeToImages:@"load1"] inview:view];
           UIImageView * imageView = [view viewWithTag:8888];
           if (imageView)
           {
//              MYLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", view.subviews);
              //写在里面是为了启动时设置下面的逻辑，其他接口不用
              NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
              if (userCenter)
              {
                 [view bringSubviewToFront:imageView];
              }
              else
              {
                 MyUserAgreementView * userView = [view viewWithTag:9999];
                 if ([view.subviews containsObject:[YJProgressHUD shareinstance].hud] && [view.subviews containsObject:userView])
                 {
                    NSInteger index = [view.subviews indexOfObject:[YJProgressHUD shareinstance].hud];
                    NSInteger index1 = [view.subviews indexOfObject:userView];
                    [view exchangeSubviewAtIndex:index withSubviewAtIndex:index1];
                 }
              }
           }
        });
    }
   
   switch (requestMethod)
   {
      case RequestMethodGET: {
         requestTask = [manager GET:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }

            }];
        }
            break;

        case RequestMethodPOST: {

            if (self.constructionBodyBlock != nil) {

               requestTask = [manager POST:url parameters:nil headers:@{} constructingBodyWithBlock:self.constructionBodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {

                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleResultWithResponseObject:responseObject error:nil];
                    if (success) {
                        success(self);
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                    [self handleResultWithResponseObject:nil error:error];
                    if (failure) {
                        failure(self);
                    }
                }];
            }
            else {

               requestTask = [manager POST:url parameters:params headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {

                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                    [self handleResultWithResponseObject:responseObject error:nil];
                    if (success) {
                        success(self);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                    [self handleResultWithResponseObject:nil error:error];
                    if (failure) {
                        failure(self);
                    }
                }];
            }

        }
            break;

        case RequestMethodPUT: {

           requestTask = [manager PUT:url parameters:params headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }


            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }
            }];

        }
            break;

        case RequestMethodDELETE: {

           requestTask = [manager DELETE:url parameters:params headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }

            }];

        }
            break;

        default:
            break;
    }
    self.task = requestTask;
    
}
/*
- (void)startWithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure {
    
    RequestMethod requestMethod = self.requestMethod;
    NSString *url = [self requestUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [self requestParameters];
    
    NSURLSessionDataTask *requestTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html; charset=utf-8"];
//    if (requestMethod == RequestMethodPOST && [url isEqualToString:@"http://54.185.179.20/api/users/search"]) {
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    }
//    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:AUTHID];
//    if (authID) {
//        [manager.requestSerializer setValue:authID forHTTPHeaderField:AUTHID];
//    }

//    [manager.requestSerializer setValue:authID forHTTPHeaderField:AUTHID];
    [manager.requestSerializer setValue:[self dataTOjsonString:params] forHTTPHeaderField:@"jsonText"];

    switch (requestMethod) {
        case RequestMethodGET: {
            requestTask = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                 [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }
               
            }];

        }
            break;
            
        case RequestMethodPOST: {
            
            if (self.constructionBodyBlock != nil) {
                
                requestTask = [manager POST:url parameters:nil constructingBodyWithBlock:self.constructionBodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self handleResultWithResponseObject:responseObject error:nil];
                    if (success) {
                        success(self);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self handleResultWithResponseObject:nil error:error];
                    if (failure) {
                        failure(self);
                    }
                    
                }];
                
            }
            else {
                
                requestTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self handleResultWithResponseObject:responseObject error:nil];
                    if (success) {
                        success(self);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [self handleResultWithResponseObject:nil error:error];
                    if (failure) {
                        failure(self);
                    }
                    
                }];
                
            }
           
        }
            break;
            
        case RequestMethodPUT: {
            
            requestTask = [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }

                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }
            }];
    
        }
            break;
            
        case RequestMethodDELETE: {
            
            requestTask = [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleResultWithResponseObject:responseObject error:nil];
                if (success) {
                    success(self);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleResultWithResponseObject:nil error:error];
                if (failure) {
                    failure(self);
                }
                
            }];
            
        }
            break;
            
        default:
            break;
    }
    self.task = requestTask;
    
}
*/
- (void)startNew2WithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure {

    RequestMethod requestMethod = self.requestMethod;
    NSString *url = [self requestUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [self requestParameters];

    NSURLSessionDataTask *requestTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    //    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    //    NSData *body = 你需要提交的data;
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    //    [request setHTTPBody:data];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= 30;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:data];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (!error) {
//            NSLog(@"request success = %@ =%@",response,responseObject);
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"jsonDict success = %@ =%@",jsonDict,[[jsonDict objectForKey:@"status"] objectForKey:@"error_desc"]);
            [self handleResultWithResponseObject:responseObject error:nil];

            if (success) {
                success(self);
            }

        } else {

            [self handleResultWithResponseObject:nil error:error];
            if (failure) {
                failure(self);
            }
            NSLog(@"request error = %@",error);
        }
    }] resume];
}

- (void)startNew3WithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure {

    RequestMethod requestMethod = self.requestMethod;
    NSString *url = [self requestUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [self requestParameters];

    NSURLSessionDataTask *requestTask = nil;

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    req.timeoutInterval= 30;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    if (authID) {
        [req setValue:authID forHTTPHeaderField:TOKEN];

//        [manager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
    }

    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [req setHTTPBody:data];

    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [self handleResultWithResponseObject:responseObject error:nil];

            if (success) {
                success(self);
            }

        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];




//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
//    if (authID) {
//        [manager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
//    }
//    [manager.requestSerializer setValue:@"value1" forHTTPHeaderField:@"key1"];
//    [manager.requestSerializer setValue:@"value2" forHTTPHeaderField:@"key2"];
//    [manager POST:url
//       parameters:@{
//                    @"key1":@"value1",
//                    @"key2":@"value2"
//                    ......
//                    }
//         progress:nil
//          success:^(NSURLSessionTask *task, id responseObject) {
//              NSLog("response:%@", responseObject);
//          }
//     }
//          failure:^(NSURLSessionTask *task, NSError *error) {
//              NSLog(@"error:%@", error);
//          }];


//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
//    if (authID) {
//        [manager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
//    }
//    [manager.requestSerializer setValue:[DeviceInfo shareInstance].channel forHTTPHeaderField:@"channel"];
//    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceType forHTTPHeaderField:@"device-type"];
//    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceVersion forHTTPHeaderField:@"device-version"];
//    [manager.requestSerializer setValue:[DeviceInfo shareInstance].ffOpenUDID forHTTPHeaderField:@"IMEI"];

    //    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    //    NSData *body = 你需要提交的data;
//    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    //    [request setHTTPBody:data];
//
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
//    request.timeoutInterval= 30;
//    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    [request setValue:authID forHTTPHeaderField:TOKEN];
//
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:authID forHTTPHeaderField:TOKEN];
//    // 设置body
//    [request setHTTPBody:data];

//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                 @"text/html",
//                                                 @"text/json",
//                                                 @"text/javascript",
//                                                 @"text/plain",
//                                                 nil];
//    manager.responseSerializer = responseSerializer;
//
//    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        if (!error) {
//
//            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            //            NSLog(@"jsonDict success = %@ =%@",jsonDict,[[jsonDict objectForKey:@"status"] objectForKey:@"error_desc"]);
//            [self handleResultWithResponseObject:responseObject error:nil];
//
//            if (success) {
//                success(self);
//            }
//
//        } else {
//
//            [self handleResultWithResponseObject:nil error:error];
//            if (failure) {
//                failure(self);
//            }
//            NSLog(@"request error = %@",error);
//        }
//    }] resume];

}



- (void)startNewWithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure {

    RequestMethod requestMethod = self.requestMethod;
    NSString *url = [self requestUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [self requestParameters];
    NSURLSessionDataTask *requestTask = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *authID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    if (authID) {
        [manager.requestSerializer setValue:authID forHTTPHeaderField:TOKEN];
    }
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].channel forHTTPHeaderField:@"channel"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceType forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].deviceVersion forHTTPHeaderField:@"device-version"];
    [manager.requestSerializer setValue:[DeviceInfo shareInstance].ffOpenUDID forHTTPHeaderField:@"IMEI"];
//    NSData *body = 你需要提交的data;
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    [request setHTTPBody:data];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval = 30;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:authID forHTTPHeaderField:TOKEN];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:authID forHTTPHeaderField:TOKEN];
    // 设置body
    [request setHTTPBody:data];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;

    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (!error) {

            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self handleResultWithResponseObject:responseObject error:nil];

            if (success) {
                success(self);
            }

        } else {

            [self handleResultWithResponseObject:nil error:error];
            if (failure) {
                failure(self);
            }
            NSLog(@"request error = %@",error);
        }
    }] resume];
}

- (nullable id)requestParameters {
    
    return [NSDictionary dictionary];
}

//cancel current request
- (void)cancelRequest {
    
    if (self.task) {
        [self.task cancel];
    }
    
}

- (void)requestCompleted
{
    
}

#pragma mark - private

- (nonnull NSString *)requestUrl {
    if ([self.requestURL hasPrefix:@"http"]) {
       MYLog(@"==========%@", self.requestURL);
        return self.requestURL;
    }
   //信息流专门判断
   if ([self.requestURL isEqualToString:@"base/Index/getToDayNews"]) {
         return [NSString  stringWithFormat:@"http://api.data.kaifumao.com/%@", self.requestURL];
   }
    
    if ([self.baseURL hasPrefix:@"http"]) {
        return [NSString  stringWithFormat:@"%@%@", self.baseURL, self.requestURL];
    }
    
    NSLog(@"URL配置错误");
    return @"";
}

- (void)handleResultWithResponseObject:(id)responseObject error:(NSError *)error {
   
   if (self.isShow)
   {
       dispatch_async(dispatch_get_main_queue(), ^{
           [YJProgressHUD hide];
       });
   }
   
//   if ([responseObject objectForKey:@"data"] && [responseObject count] == 1) {
//      NSString * string = [YYToolModel AES128Decrypt:responseObject[@"data"] key:K_AES_KEY];
//      NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
//      NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//      self.responseObject = dict;
//   }else{
      self.responseObject = responseObject;
//   }

   self.error = error;
    if (!error) {
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if (self.requestParameters) {
            MYLog(@"请求的url--%@\n请求参数--%@\n返回参数--%@", self.requestURL, self.requestParameters,self.responseObject);
        }
        else
        {
           MYLog(@"请求的url--%@\n请求参数--%@\n返回的参数--%@",self.requestURL, self.requestParameters,self.responseObject);
        }
    }
    else {
        MYLog(@"请求的url--%@%@\n请求参数--%@\n请求失败error--%@", Base_Request_Url, self.requestURL, self.requestParameters, error.description);

        if (error.code != NSURLErrorCancelled && self.isToastErrorDesc && ![self.requestURL containsString:@"ios/single/sign"]) {
            [MBProgressHUD showToast:error.localizedDescription toView:[UIApplication sharedApplication].keyWindow];
        }
    }
    NSDictionary * dic = [self.responseObject[@"status"] deleteAllNullValue];
    if ([dic[@"succeed"] integerValue] == 0 && [dic[@"error_code"] integerValue] == 1016)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"member_info"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
        
        if (![self.requestURL isEqualToString:@"user/message/getUnReadNum"])
        {
            UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
           NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
           //重新登录，必须在首页的引导页面做完之后才能显示，避免引导页在登录页面上面
            if ([vc isKindOfClass:[UITabBarController class]] && userCenter)
            {
                DWTabBarController * tabbarVC = (DWTabBarController *)vc;
                NSArray *array = tabbarVC.childViewControllers;
                UINavigationController *nav = [array objectAtIndex:tabbarVC.selectedIndex];
                LoginViewController * login = [LoginViewController new];
                login.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:login animated:YES];
            }
        }
    }
    else if ([dic[@"succeed"] integerValue] == 0 && [dic[@"error_code"] integerValue] == 1046)
    {
       [self requestCompleted];
       [[YYToolModel getCurrentVC].navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self requestCompleted];
    }
}

- (NSDictionary *)base64EncodeData:(NSDictionary *)params
{
   NSError *error = nil;
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
   if (error) {
       NSLog(@"JSON序列化失败----%@",error.description);
   } else { //加密json
       //1.base64
       NSData *base64Json = [jsonData base64EncodedDataWithOptions:1];
       //2.函数加密
       NSString *str = [[NSString alloc] initWithData:base64Json encoding:NSUTF8StringEncoding];
       //去掉字符串中的空格
       str = [str stringByReplacingOccurrencesOfString:@"" withString:@""];
       //去掉字符串中的换行符
       str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
       str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
       params = @{@"data":[NSString stringWithFormat:@"%@%@", [self getRandomStringWithNum:5], str]};
   }
   return params;
}

- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

@end
