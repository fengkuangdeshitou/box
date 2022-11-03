//
//  BaseRequest.h
//  LoveViteApp
//
//  Created by weiheng on 2017/6/19.
//  Copyright © 2017年 ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "NSString+MD5.h"
#import "macro.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};


@interface BaseRequest : NSObject
@property (strong, nonatomic) id _Nullable data;
@property (strong, nonatomic, nullable) NSURLSessionDataTask *task;

@property (strong, nonatomic, nullable) id responseObject;

@property (assign, nonatomic) NSInteger success;
@property (copy, nonatomic) NSString * _Nonnull error_desc;

@property (assign, nonatomic) NSInteger pageNumber;
//charge个人中心货币明细
@property (assign, nonatomic) NSInteger pageNumbers;
@property (assign, nonatomic) NSInteger count;
/** 请求失败是否toast错误描述 默认NO 不返回  yes 返回  */
@property (nonatomic, assign) BOOL isToastErrorDesc;
/** 是否显示 */
@property (nonatomic, assign) BOOL isShow;

/**
 *  default is 'NULL',available when last request was failure.
 */
@property (strong, nonatomic, nullable) NSError *error;

@property (nonatomic, strong) NSString * _Nullable type;

@property (nonatomic, strong) NSString * _Nullable mainType;

#pragma mark - Properties
/**
 *  default is 'nil'.
 */
@property (copy, nonatomic, nonnull) NSString *baseURL;
/**
 *  default is 'nil'.
 */
@property (copy, nonatomic, nonnull) NSString *requestURL;
/**
 *  default is 'nil'.
 */
@property (strong, nonatomic, nullable, readonly) id requestParametersObject;
/**
 *  default is 30(seconds).
 */
@property (nonatomic) NSTimeInterval requestTimeOutInterval;
/**
 *  default is 'QNRequestMethodGET'.
 */
@property (nonatomic) RequestMethod requestMethod;

/**
 *  POST upload request with file,default is 'NULL'.
 */
@property (copy, nonatomic) void (^ _Nullable constructionBodyBlock)(id <AFMultipartFormData> _Nonnull formData);

- (void)startWithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure;

- (void)startNewWithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure;
- (void)startNew3WithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure;
//subclass implementation,never call 'super'.place request paremeters here in subclass.
- (nullable id)requestParameters;

//cancel current request
- (void)cancelRequest;

- (void)requestCompleted;

- (void)start22WithRequestSuccessBlock:(void (^ _Nullable)(BaseRequest * _Nonnull request))success failureBlock:(void(^ _Nullable)(BaseRequest * _Nonnull request))failure;

-(NSString*)dataTOjsonString:(id)object;

// 登录注册密码修改base64加密
- (NSDictionary *)base64EncodeData:(NSDictionary *)params;
- (NSString *)getRandomStringWithNum:(NSInteger)num;

@end
