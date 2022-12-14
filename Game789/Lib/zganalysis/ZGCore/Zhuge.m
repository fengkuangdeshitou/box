#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif
//
//  Zhuge.m
//
//  Copyright (c) 2014 37degree. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <libkern/OSAtomic.h>

#import "ZhugeCompres.h"
#import "ZhugeBase64.h"
#import "Zhuge.h"
#import "ZGLog.h"
#import "ZGHttpHelper.h"
#import "ZhugeConstants.h"

#import "ZGSharedDur.h"
#import "ZGUtil.h"
#import "ZGSqliteManager.h"

#import "UIViewController+Zhuge.h"
#import "UIApplication+Zhuge.h"
#import "ZhugeSwizzle.h"
#import "UIGestureRecognizer+Zhuge.h"

#import "DeepShare.h"


@interface Zhuge ()

@property (nonatomic, copy) NSString *apiURL;
@property (nonatomic, copy) NSString *backupURL;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, strong) NSNumber *sessionId;
@property (nonatomic, strong) NSDate *screenShotTime;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic) UIBackgroundTaskIdentifier taskId;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableArray *eventsQueue;
@property (nonatomic, strong) ZhugeConfig *config;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger sendCount;
@property (nonatomic, assign) SCNetworkReachabilityRef reachability;
@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyInfo;
@property (nonatomic, strong) NSString *net;
@property (nonatomic, strong) NSString *radio;
@property (nonatomic, strong) NSString *cr;
@property (nonatomic, strong) NSMutableDictionary *eventTimeDic;
@property (nonatomic, strong) NSMutableDictionary *envInfo;
@property (nonatomic, assign) NSInteger  zhugeSeeReal;
@property (nonatomic, assign) NSString *  zhugeSeeNet;
@property (nonatomic, copy) NSString *ZGPublicKey;
@property (nonatomic ,copy)NSString *ZGPublicMD5;
@property (nonatomic) BOOL isForeground;
@property (nonatomic) volatile int32_t sessionCount;
@property (nonatomic) volatile int32_t seeCount;
@property (nonatomic) BOOL localZhugeSeeState;

@property (nonatomic, strong) NSMutableArray * archiveEventQueue;
@property (nonatomic,strong) NSMutableDictionary * utmDic;
@property (nonatomic, assign) int retryPost;

/**
 * ??????deepShare????????????????????????????????????????????????????????? ?????????NO???
 */
@property (nonatomic,assign) BOOL  flushBool;

@end

@implementation Zhuge

//1??????????????????????????????????????????????????????????????????
static Zhuge *selfClass =nil;

static NSUncaughtExceptionHandler *previousHandler;

static void ZhugeReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    if (info != NULL && [(__bridge NSObject*)info isKindOfClass:[Zhuge class]]) {
        @autoreleasepool {
            Zhuge *zhuge = (__bridge Zhuge *)info;
            [zhuge reachabilityChanged:flags];
        }
    }
}

static Zhuge *sharedInstance = nil;

#pragma mark - ?????????

+ (Zhuge *)sharedInstance {
    
    static Zhuge *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.config = [[ZhugeConfig alloc] init];
        sharedInstance.eventTimeDic = [[NSMutableDictionary alloc]init];
    });
    return sharedInstance;
}

- (ZhugeConfig *)config {
    return _config;
}

-(NSString *)getZGSeeUploadURL{
    if ([self.apiURL isEqualToString:@"https://u.zhugeapi.com"]) {
        return @"https://ubak.zhugeio.com/sdk_zgsee";
    }else{
        return [self.apiURL stringByAppendingString:@"/sdk_zgsee"];
    }
}

-(NSString *)getZGSeePolicyURL{
    if ([self.apiURL isEqualToString:@"https://u.zhugeapi.com"]) {
        return @"https://ubak.zhugeio.com/appkey/default";
    }else{
        return [self.apiURL stringByAppendingFormat:@"/appkey/%@",self.appKey];
    }
}

-(void)startWithAppKey:(NSString *)appKey andDid:(NSString *)did launchOptions:(NSDictionary *)launchOptions{
    self.deviceId = did;
    [self startWithAppKey:appKey launchOptions:launchOptions withDelegate:nil];
}

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions {
    [self startWithAppKey:appKey launchOptions:launchOptions withDelegate:nil];
}

// ??????DeepShare??????????????? star ??????
- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions delegate:(id)delegate {
    [self startWithAppKey:appKey launchOptions:launchOptions withDelegate:delegate];
}

- (void)startWithAppKey:(NSString *)appKey andDid:(NSString *)did launchOptions:(NSDictionary *)launchOptions withDelegate:(id)delegate {
    self.deviceId = did;
    [self startWithAppKey:appKey launchOptions:launchOptions withDelegate:delegate];
}

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions withDelegate:(id)delegate{
    @try {
        if (appKey == nil || [appKey length] == 0) {
            ZhugeDebug(@"appKey???????????????");
            return;
        }
        selfClass = self;
        self.appKey = appKey;
        self.flushBool = NO;
        self.userId = @"";
        self.deviceToken = @"";
        self.sessionId = nil;
        self.net = @"";
        self.radio = @"";
        self.telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        self.taskId = UIBackgroundTaskInvalid;
        NSString *label = [NSString stringWithFormat:@"io.zhuge.%@.%p", appKey, self];
        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.eventsQueue = [[NSMutableArray alloc] init];
        self.archiveEventQueue = [[NSMutableArray alloc] init];
        self.cr = [self carrier];
//        [[ZGSqliteManager shareManager] openDataBase];
        
        if (!self.apiURL || self.apiURL.length ==0) {
            self.apiURL = ZG_BASE_API;
            self.backupURL = ZG_BACKUP_API;
        }
        
        if (self.config.zgSeeEnable) {
            //?????????zhugesee??????
            self.zhugeSeeNet = @"4";
            self.zhugeSeeReal = 1;
            //??????????????????zgSee
            [self zgSeeBool];
        }
        
        // SDK??????
        if(self.config) {
            ZhugeDebug(@"SDK????????????: %@", self.config);
        }
        if (self.config.debug) {
            [self.config setSendInterval:2];
        }

        [self setupListeners];
        [self unarchive];
        if (launchOptions && launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
            [self trackPush:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] type:@"launch"];
        }
        if (!self.deviceId) {
            self.deviceId = [self defaultDeviceId];
        }
        if (self.config.exceptionTrack) {
            previousHandler = NSGetUncaughtExceptionHandler();
            NSSetUncaughtExceptionHandler(&ZhugeUncaughtExceptionHandler);
        }
        
        if (delegate) {
            self.delegate = delegate;
            [DeepShare initWithAppID:self.appKey withLaunchOptions:launchOptions withDelegate:self];
        }
        
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"startWithAppKey exception %@",exception);
    }
}
- (void)trackException:(NSException *) exception{
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // ???????????????  ????????????????????????(????????????,??????nil,??????????????????...) ??????????????????????????????
    NSString * name = [exception name];
    NSMutableString *stack = [NSMutableString string];
    long sum = 0;
    for (NSString *ele in arr) {
        sum = sum + ele.length;
        if ((sum + 5) >256) {
            break;
        }
        [stack appendString:[ele stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [stack appendString:@" \n "];
    }
    NSMutableDictionary *pr = [self eventData];
    pr[@"$????????????"]=name;
    pr[@"$????????????"]=reason;
    pr[@"$??????????????????"]= [[NSProcessInfo processInfo] processName];

    pr[@"$????????????"] = [[NSBundle mainBundle] bundleIdentifier];
    pr[@"$????????????"] = stack;
    pr[@"$???????????????"] = self.isForeground?@"??????":@"??????";
    pr[@"$eid"] = @"??????";
    NSMutableDictionary *e = [NSMutableDictionary dictionary];
    e[@"dt"] = @"abp";
    e[@"pr"] = pr;
    NSArray *events = @[e];
    NSString *eventData = [self encodeAPIData:[self wrapEvents:events]];

    ZhugeDebug(@"?????????????????????%@",eventData);
    NSData *eventDataBefore = [eventData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *zlibedData = [eventDataBefore zgZlibDeflate];

    NSString *event = [zlibedData zgBase64EncodedString];
    NSString *result = [[event stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSString *requestData = [NSString stringWithFormat:@"method=event_statis_srv.upload&compress=1&event=%@", result];

    NSData *response = [self apiRequest:@"/APIPOOL/" WithData:requestData andError:nil];
    if (!response) {
        ZhugeDebug(@"??????????????????");
    }
    
    if (previousHandler) {
        previousHandler(exception);
    }
}
// ??????????????????????????????
void ZhugeUncaughtExceptionHandler(NSException * exception){
    [[Zhuge sharedInstance]trackException:exception];
}

#pragma mark - DeepShare
- (void)onInappDataReturned: (NSDictionary *) params withError: (NSError *) error  tag:(NSString *)tag{
    self.utmDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    if (!error) {
        ZhugeDebug(@"DeepShare finished init with params = %@", [params description]);
//        self.utmDic[@"$utm_source"] = params[@"utm_source"];
//        self.utmDic[@"$utm_medium"] = params[@"utm_medium"];
//        self.utmDic[@"$utm_campaign"] = params[@"utm_campaign"];
//        self.utmDic[@"$utm_content"] = params[@"utm_content"];
//        self.utmDic[@"$utm_term"] = params[@"utm_term"];
        if (params[@"$zg_did"]) {
            self.deviceId = params[@"$zg_did"];
        }
        if (params.allKeys.count > 0) {
            if ([tag isEqualToString: REQ_TAG_REGISTER_INSTALL]) {
                self.utmDic[@"$utm_type"] = @"1";
            }
            if ([tag isEqualToString:@"t_register_open"]) {
                self.utmDic[@"$utm_type"] = @"0";
            }
        }
        else {
            if ([tag isEqualToString: REQ_TAG_REGISTER_INSTALL]) {
                self.utmDic[@"$utm_type"] = @"3";
            }
            if ([tag isEqualToString:@"t_register_open"]) {
                self.utmDic[@"$utm_type"] = @"2";
            }
        }
        
        if ([tag isEqualToString:REQ_TAG_REGISTER_INSTALL]) {
            ZhugeDebug(@"???????????????");
        }
        if ([tag isEqualToString:@"t_register_open"]) {
            ZhugeDebug(@"???????????????");
        }
        
        if ([self.delegate respondsToSelector:@selector(zgOnInappDataReturned:withError:)]) {
//            NSMutableDictionary * zgParams = [NSMutableDictionary dictionaryWithDictionary:params];
//            [zgParams addEntriesFromDictionary:self.utmDic];
//            NSLog(@"zgParams ==== ==%@",zgParams);
//            [zgParams removeObjectForKey:@"utm_source"];
//            [zgParams removeObjectForKey:@"utm_medium"];
//            [zgParams removeObjectForKey:@"utm_campaign"];
//            [zgParams removeObjectForKey:@"utm_content"];
//            [zgParams removeObjectForKey:@"utm_term"];
//            [zgParams removeObjectForKey:@"utm_type"];
            [self.delegate zgOnInappDataReturned:self.utmDic withError:error];
        }
    } else {
        ZhugeDebug(@"DeepShare init error id: %ld %@",error.code, error);
    }
    
    self.flushBool = YES;
    
    if (self.archiveEventQueue.count>0) {
        NSMutableArray * flushAry = [NSMutableArray array];
        for (NSDictionary * dic in self.archiveEventQueue) {
            [dic[@"pr"] addEntriesFromDictionary:self.utmDic];
            [flushAry addObject:dic];
        }
        dispatch_async(self.serialQueue, ^{
            [self flushQueue: flushAry];
            self.archiveEventQueue = [NSMutableArray array];
        });
    }
}

+ (BOOL)handleURL:(NSURL *)url {
    return [DeepShare handleURL:url];
}

+ (BOOL)continueUserActivity:(NSUserActivity *)userActivity {
    return [DeepShare continueUserActivity:userActivity];
}

#pragma mark - ????????????
-(void)setUtm:(nonnull NSDictionary *)utmInfo {
    if(!utmInfo){
        return;
    }
    if (!self.utmDic) {
        self.utmDic = [[NSMutableDictionary alloc] init];
    }
    if ([utmInfo objectForKey:@"utm_source"]) {
        [self.utmDic setValue:utmInfo[@"utm_source"] forKey:@"$utm_source"];
    }
    if ([utmInfo objectForKey:@"utm_medium"]) {
        [self.utmDic setValue:utmInfo[@"utm_medium"] forKey:@"$utm_medium"];
    }
    if ([utmInfo objectForKey:@"utm_campaign"]) {
        [self.utmDic setValue:utmInfo[@"utm_campaign"] forKey:@"$utm_campaign"];
    }
    if ([utmInfo objectForKey:@"utm_content"]) {
        [self.utmDic setValue:utmInfo[@"utm_content"] forKey:@"$utm_content"];
    }
    if ([utmInfo objectForKey:@"utm_term"]) {
        [self.utmDic setValue:utmInfo[@"utm_term"] forKey:@"$utm_term"];
    }
}

- (void)setUploadURL:(NSString *)url andBackupUrl:(NSString *)backupUrl{
    
    if (url && url.length>0) {
        
        self.apiURL = [self parseUrl: url];
        self.backupURL = backupUrl;
    }else{
        ZhugeDebug(@"?????????url?????????????????????:%@",url);
    }
}
- (NSString *)parseUrl:(NSString *) url{
    NSString * result;
    if ([url hasSuffix:@"/"]) {
        result = [url substringToIndex:[url length] - 1];
    }else{
        result = url;
    }
    if ([result hasSuffix:@"/apipool"] || [result hasSuffix:@"/APIPOOL"] ) {
        result = [result substringToIndex:[result length] - 8];
    }
    return result;
}
- (void)setSuperProperty:(NSDictionary *)info{

    if (!self.envInfo) {
        self.envInfo = [[NSMutableDictionary alloc] init];
    }
    self.envInfo[@"event"] = info;
}

- (void)enableAutoTrack{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        NSError *error = NULL;
        //$AppClick
        // Actions & Events
        [UIApplication zhuge_swizzleMethod:@selector(sendAction:to:from:forEvent:)
                                withMethod:@selector(zhuge_sendAction:to:from:forEvent:)
                                     error:&error];
        if (error) {
            
            ZhugeDebug(@"swizzle application action failed ,%@",error);
            error = NULL;
        }
        [UITapGestureRecognizer zhuge_swizzleMethod:@selector(addTarget:action:)
                                         withMethod:@selector(zhuge_addTarget:action:)
                                              error:&error];
        
        [UITapGestureRecognizer zhuge_swizzleMethod:@selector(initWithTarget:action:)
                                         withMethod:@selector(zhuge_initWithTarget:action:)
                                              error:&error];
        
        [UILongPressGestureRecognizer zhuge_swizzleMethod:@selector(addTarget:action:)
                                               withMethod:@selector(zhuge_addTarget:action:)
                                                    error:&error];
        
        [UILongPressGestureRecognizer zhuge_swizzleMethod:@selector(initWithTarget:action:)
                                               withMethod:@selector(zhuge_initWithTarget:action:)
                                                    error:&error];
        if (error) {
            
            ZhugeDebug(@"swizzle tap gesture action failed ,%@",error);
            error = NULL;
        }
    });
    [self.config setAutoTrackEnable:YES];
}
- (BOOL)isAutoTrackEnable{
    return self.isAutoTrackEnable;
}
- (void)setPlatform:(NSDictionary *)info{
    if (!self.envInfo) {
        self.envInfo = [NSMutableDictionary dictionary];
    }
    self.envInfo[@"device"] = info;
}

- (NSString *)getDid {
    if (!self.deviceId) {
        self.deviceId = [self defaultDeviceId];
    }
    
    return self.deviceId;
}
- (NSString *)getSid{
    
    if (!self.sessionId) {
        self.sessionId = @0;
    }
    return [NSString stringWithFormat:@"%@", self.sessionId] ;
}
// ???????????????????????????????????????
- (void)setupListeners{
    BOOL reachabilityOk = NO;
    if ((_reachability = SCNetworkReachabilityCreateWithName(NULL, "www.baidu.com")) != NULL) {
        SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
        if (SCNetworkReachabilitySetCallback(_reachability, ZhugeReachabilityCallback, &context)) {
            if (SCNetworkReachabilitySetDispatchQueue(_reachability, self.serialQueue)) {
                reachabilityOk = YES;
            } else {
                SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
            }
        }
    }
    if (!reachabilityOk) {
        ZhugeDebug(@"failed to set up reachability callback: %s", SCErrorString(SCError()));
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // ????????????(GRPS,WCDMA,LTE,...),IOS7?????????????????????
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self setCurrentRadio];
        [notificationCenter addObserver:self
                               selector:@selector(setCurrentRadio)
                                   name:CTRadioAccessTechnologyDidChangeNotification
                                    object:nil];
    }
#endif
    
    // ????????????????????????
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillTerminate:)
                               name:UIApplicationWillTerminateNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];
}
// ????????????????????????
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [self trackPush:userInfo type:@"msgrecv"];
}

#pragma mark - ??????????????????
//????????????????????????????????????????????????
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    @try {
        self.isForeground = YES;
        [self sessionStart];
        if ([self.config isSeeEnable]) {
            [self zgSeeStart];
        }
        [self uploadDeviceInfo];
        [self startFlushTimer];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationDidBecomeActive exception %@",exception);
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    @try {
        self.isForeground = NO;
        [self sessionEnd];
        [self stopFlushTimer];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationWillResignActive exception %@",exception);
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    @try {
       
        self.taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
            self.taskId = UIBackgroundTaskInvalid;
        }];
        
        [self flush];
        //???????????????????????????????????????  sid????????????
//        [self zgSeeUpLoadNumData:50 cacheBool:NO];

        dispatch_async(_serialQueue, ^{
            [self archive];
            if (self.taskId != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
                self.taskId = UIBackgroundTaskInvalid;
            }
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationDidEnterBackground exception %@",exception);
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    @try {
        
        dispatch_async(_serialQueue, ^{
            [self archive];
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationWillTerminate exception %@",exception);
    }
}

#pragma mark - ??????ID

// ??????ID
- (NSString *)defaultDeviceId {
    // IDFA
    NSString *deviceId = [self adid];
    
    // IDFV from KeyChain
    if (!deviceId) {
        deviceId = [self idFromKeyChain];
    }
    
    if (!deviceId) {
        ZhugeDebug(@"error getting device identifier: falling back to uuid");
        deviceId = [[NSUUID UUID] UUIDString];
    }
    return deviceId;
}

// ??????ID
- (NSString *)adid {
    NSString *adid = nil;
#ifndef ZHUGE_NO_ADID
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) {
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        adid = [uuid UUIDString];
    }
#endif
    if (adid&&[adid isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        //iOS10???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        return nil;
    }
    return adid;
}

- (NSString *)newStoredID {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("zgid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("zgid_service"));
    
    NSString *uuid = nil;
    if (NSClassFromString(@"UIDevice")) {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    } else {
        uuid = [[NSUUID UUID] UUIDString];
    }
    
    CFDataRef dataRef = CFBridgingRetain([uuid dataUsingEncoding:NSUTF8StringEncoding]);
    CFDictionarySetValue(query, kSecValueData, dataRef);
    OSStatus status = SecItemAdd(query, NULL);
    
    if (status != noErr) {
        ZhugeDebug(@"Keychain Save Error: %d", (int)status);
        uuid = nil;
    }
    
    CFRelease(dataRef);
    CFRelease(query);
    
    return uuid;
}

- (NSString *)idFromKeyChain {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("zgid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("zgid_service"));
    
    // See if the attribute exists
    CFTypeRef attributeResult = NULL;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef *)&attributeResult);
    if (attributeResult != NULL)
        CFRelease(attributeResult);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound) {
            return [self newStoredID];
        } else {
            ZhugeDebug(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    // Fetch stored attribute
    CFDictionaryRemoveValue(query, kSecReturnAttributes);
    CFDictionarySetValue(query, kSecReturnData, (id)kCFBooleanTrue);
    CFTypeRef resultData = NULL;
    status = SecItemCopyMatching(query, &resultData);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound){
            return [self newStoredID];
        } else {
            ZhugeDebug(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    NSString *uuid = nil;
    if (resultData != NULL)  {
        uuid = [[NSString alloc] initWithData:CFBridgingRelease(resultData) encoding:NSUTF8StringEncoding];
    }
    
    CFRelease(query);
    
    return uuid;
}

#pragma mark - ????????????

// ?????????????????????
- (BOOL)inBackground {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}

// ????????????
- (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

// ?????????
- (NSString *)resolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return [[NSString alloc] initWithFormat:@"%.fx%.f",rect.size.height*scale,rect.size.width*scale];
}

// ?????????
- (NSString *)carrier {
    CTCarrier *carrier =[self.telephonyInfo subscriberCellularProvider];
    if (carrier != nil) {
        NSString *mcc =[carrier mobileCountryCode];
        NSString *mnc =[carrier mobileNetworkCode];
        return [NSString stringWithFormat:@"%@%@", mcc, mnc];
    }
    return @"(null)(null)";
}

// ????????????
- (BOOL)isJailBroken {
    static const char * __jb_app = NULL;
    static const char * __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    __jb_app = NULL;
    for ( int i = 0; __jb_apps[i]; ++i ) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]]) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }
    
    return NO;
}

// ????????????
- (BOOL)isPirated {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    /* SC_Info */
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/SC_Info",bundlePath]]) {
        return YES;
    }
    /* iTunesMetadata.plist */
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/iTunesMetadata.plist",bundlePath]]) {
        return YES;
    }
    return NO;
}

// ?????????????????????
//- (void)updateNetworkActivityIndicator:(BOOL)on {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = on;
//    });
//}

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags {
    if (flags & kSCNetworkReachabilityFlagsReachable) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            self.net = @"0";//2G/3G/4G
        } else {
            self.net = @"4";//WIFI
        }
    } else {
        self.net = @"-1";//??????
    }
    ZhugeDebug(@"????????????: %@", [@"-1" isEqualToString:self.net]?@"??????":[@"0" isEqualToString:self.net]?@"????????????":@"WIFI");
}

// ????????????(GPRS,WCDMA,LTE,...)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
- (void)setCurrentRadio {
    dispatch_async(self.serialQueue, ^(){
        self.radio = [self currentRadio];
        ZhugeDebug(@"????????????: %@", self.radio);
    });
}

- (NSString *)currentRadio {
    NSString *radio = _telephonyInfo.currentRadioAccessTechnology;
    if (!radio) {
        radio = @"None";
    } else if ([radio hasPrefix:@"CTRadioAccessTechnology"]) {
        radio = [radio substringFromIndex:23];
    }
    return radio;
}
#endif

-(NSString *)currentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [fm stringFromDate:date];
}
#pragma mark - ????????????
/**
 ?????????????????????
 @return ?????????????????????Dictionary
 */
-(NSMutableDictionary *)buildCommonData {
    NSMutableDictionary *common;
    if (self.utmDic) {
        common = [NSMutableDictionary dictionaryWithDictionary:self.utmDic];
    } else {
        common = [[NSMutableDictionary alloc] init];
    }
    if (self.userId.length > 0) {
        common[@"$cuid"] = self.userId;
    }
    common[@"$cr"]  = self.cr;
    //???????????????
    common[@"$ct"] = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970] *1000];
    common[@"$tz"] = [NSNumber numberWithInteger:[[NSTimeZone localTimeZone] secondsFromGMT]*1000];//??????????????????
    common[@"$os"] = @"iOS";
    common[@"$url"] = Zhuge.sharedInstance.url;
    common[@"$ref"] = Zhuge.sharedInstance.ref;
    //DeepShare ??????
    [common addEntriesFromDictionary:self.utmDic];
    return common;
}

// ????????????
- (void)sessionStart {
    @try {
        if (!self.sessionId) {
            //???????????????
            self.sessionCount = 0;
            self.seeCount = 0;
            self.sessionId = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] *1000];
            ZhugeDebug(@"????????????(ID:%@)", self.sessionId);
            if (self.config.sessionEnable) {
                NSMutableDictionary *e = [NSMutableDictionary dictionary];
                e[@"dt"] = @"ss";
                NSMutableDictionary *pr = [self buildCommonData];
                pr[@"$an"] = self.config.appName;
                pr[@"$cn"]  = self.config.channel;
                pr[@"$net"] = self.net;
                pr[@"$mnet"]= self.radio;
                pr[@"$ov"] = [[UIDevice currentDevice] systemVersion];
                pr[@"$sid"] = self.sessionId;
                pr[@"$vn"] = self.config.appVersion;
                pr[@"$sc"]= @0;
                e[@"pr"] = pr;
                [self enqueueEvent:e];
            }
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"sessionStart exception %@",exception);
    }
}

// ????????????
- (void)sessionEnd {
    @try {
        ZhugeDebug(@"????????????(ID:%@)", self.sessionId);
        
        if (self.sessionId) {
            if (self.config.sessionEnable) {
                NSMutableDictionary *e = [NSMutableDictionary dictionary];
                e[@"dt"] = @"se";
                NSMutableDictionary *pr = [self buildCommonData];
                int32_t value =  OSAtomicIncrement32(&_sessionCount);
                NSNumber *ts = pr[@"$ct"];
                NSNumber *dru = @([ts unsignedLongLongValue] - [self.sessionId unsignedLongLongValue]);
                pr[@"$an"] = self.config.appName;
                pr[@"$cn"]  = self.config.channel;
                pr[@"$dru"] = dru;
                pr[@"$net"] = self.net;
                pr[@"$mnet"]= self.radio;
                pr[@"$sid"] = self.sessionId;
                pr[@"$vn"] = self.config.appVersion;
                pr[@"$ov"] = [[UIDevice currentDevice] systemVersion];
                pr[@"$sc"] = [NSNumber numberWithInt:value];
                e[@"pr"] = pr;
                [self enqueueEvent:e];
            }
            self.sessionId = nil;
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"sessionEnd exception %@",exception);
    }
}

// ??????????????????
- (void)uploadDeviceInfo {
    [self trackDeviceInfo];

    @try {
        NSNumber *zgInfoUploadTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"zgInfoUploadTime"];
        NSNumber *ts = @(round([[NSDate date] timeIntervalSince1970]));
        if (zgInfoUploadTime == nil ||[ts longValue] > [zgInfoUploadTime longValue] + 86400) {
            [self trackDeviceInfo];
            [[NSUserDefaults standardUserDefaults] setObject:ts forKey:@"zgInfoUploadTime"];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"uploadDeviceInfo exception %@",exception);
    }
}
-(void)autoTrack:(NSDictionary *)info{
    if (![info objectForKey:@"$eid"]) {
        ZhugeDebug(@"auto track with illegal content %@",info);
        return;
    }
    if (!self.sessionId) {
        [self sessionStart];
    }
    dispatch_async(self.serialQueue, ^{
        @try {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
            NSMutableDictionary *pr = [self eventData];
            [pr addEntriesFromDictionary:info];
            [data setObject:pr forKey:@"pr"];
            [data setObject:@"abp" forKey:@"dt"];
            [self enqueueEvent:data];
        }
        @catch (NSException *exception) {
            ZhugeDebug(@"start track properties exception %@",exception);
        }
    });
    
}


-(void)startTrack:(NSString *)eventName{
    @try {
        if (!eventName) {
            ZhugeDebug(@"startTrack event name must not be nil.");
            return;
        }
        dispatch_async(self.serialQueue, ^{
            NSNumber *ts = @([[NSDate date] timeIntervalSince1970]);
            ZhugeDebug(@"startTrack %@ at time : %@",eventName,ts);
            [self.eventTimeDic setValue:ts forKey:eventName];
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"start track properties exception %@",exception);
    }

    
}
-(void)endTrack:(NSString *)eventName properties:(NSDictionary*)properties{
    @try {
        dispatch_async(self.serialQueue, ^{
            NSNumber *start = [self.eventTimeDic objectForKey:eventName];
            if (!start) {
                ZhugeDebug(@"end track event name not found ,have you called startTrack already?");
                return;
            }
            if (!self.sessionId) {
                [self sessionStart];
            }
            [self.eventTimeDic removeObjectForKey:eventName];
            NSNumber *end = @([[NSDate date] timeIntervalSince1970]);
            ZhugeDebug(@"endTrack %@ at time : %@",eventName,end);
            NSMutableDictionary *dic = properties?[self addSymbloToDic:properties]:[NSMutableDictionary dictionary];
            dic[@"$dru"] = [NSNumber numberWithUnsignedLongLong:(end.doubleValue - start.doubleValue)*1000];
            dic[@"$eid"] = eventName;
            int32_t value =  OSAtomicIncrement32(&self->_sessionCount);
            dic[@"$sc"] = [NSNumber numberWithInt:value];
            [dic addEntriesFromDictionary:[self eventData]];
            if (self.envInfo) {
                NSDictionary *info = [self.envInfo objectForKey:@"event"];
                if (info) {
                    NSMutableDictionary *data = [self addSymbloToDic:info];
                    [dic addEntriesFromDictionary:data];
                }
            }
            NSMutableDictionary *e = [NSMutableDictionary dictionaryWithCapacity:2];
            [e setObject:dic forKey:@"pr"];
            [e setObject:@"evt" forKey:@"dt"];
            [self enqueueEvent:e];
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"end track properties exception %@",exception);
    }
}
// ?????????????????????
- (void)track:(NSString *)event {
    [self track:event properties:nil];
}


- (void)trackRevenue:(NSMutableDictionary *)properties {
    
    NSString *price = [NSString stringWithFormat:@"%@",properties[ZhugeEventRevenuePrice]];
    NSString *number = [NSString stringWithFormat:@"%@",properties[ZhugeEventRevenueProductQuantity]];
    //price?????????NSDecimalNumber
    NSDecimalNumber *priceDec = [NSDecimalNumber decimalNumberWithString:price];
    //number?????????NSDecimalNumber
    NSDecimalNumber *numberDec = [NSDecimalNumber decimalNumberWithString:number];
    //???????????????
    NSDecimalNumber *totalDec = [priceDec decimalNumberByMultiplyingBy:numberDec];
    
    [properties setObject:priceDec forKey:ZhugeEventRevenuePrice];
    [properties setObject:numberDec forKey:ZhugeEventRevenueProductQuantity];
    [properties setObject:totalDec forKey:ZhugeEventRevenueTotalPrice];
    [self trackRevenue:ZG_REVENUE properties:properties];
}

- (void)trackRevenue:(NSString *)event properties:(NSMutableDictionary *)properties {
    @try {
        if (event == nil || [event length] == 0) {
            ZhugeDebug(@"?????????????????????");
            return;
        }
        
        if (!self.sessionId) {
            [self sessionStart];
        }
        NSMutableDictionary *pr = [self eventData];
        if (properties) {
            [pr addEntriesFromDictionary:[self conversionRevenuePropertiesKey:properties]];
        }
        if (self.envInfo) {
            NSDictionary *info = [self.envInfo objectForKey:@"event"];
            if (info) {
                NSMutableDictionary *dic = [self addSymbloToDic:info];
                [pr addEntriesFromDictionary:dic];
            }
        }
        pr[@"$eid"] = event;
        int32_t value =  OSAtomicIncrement32(&_sessionCount);
        pr[@"$sc"] = [NSNumber numberWithInt:value];
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"dt"] = @"abp";
        e[@"pr"] = pr;
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"track properties exception %@",exception);
    }
}

-(NSMutableDictionary *)conversionRevenuePropertiesKey:(NSDictionary *)dic{
    __block NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithCapacity:[dic count]];
    for (NSString *key in dic) {
        id value = dic[key];
        NSString *newKey = [NSString stringWithFormat:@"$%@",key];
        [copy setValue:value forKey:newKey];
    }
    
    return copy;
}


- (void)track:(NSString *)event properties:(NSMutableDictionary *)properties {
    @try {
        if (event == nil || [event length] == 0) {
            ZhugeDebug(@"?????????????????????");
            return;
        }
        
        if (!self.sessionId) {
            [self sessionStart];
        }
        NSMutableDictionary *pr = [self eventData];
        if (properties) {
            [pr addEntriesFromDictionary:[self addSymbloToDic:properties]];
        }
        if (self.envInfo) {
            NSDictionary *info = [self.envInfo objectForKey:@"event"];
            if (info) {
                NSMutableDictionary *dic = [self addSymbloToDic:info];
                [pr addEntriesFromDictionary:dic];
            }
        }
        pr[@"$eid"] = event;
        int32_t value =  OSAtomicIncrement32(&_sessionCount);
        pr[@"$sc"] = [NSNumber numberWithInt:value];
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"dt"] = @"evt";
        e[@"pr"] = pr;
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"track properties exception %@",exception);
    }
}
-(NSMutableDictionary *)eventData{
    NSMutableDictionary *pr = [self buildCommonData];
    pr[@"$an"] = self.config.appName;
    pr[@"$cn"]  = self.config.channel;
    pr[@"$mnet"]= self.radio;
    pr[@"$net"] = self.net;
    pr[@"$ov"] = [[UIDevice currentDevice] systemVersion];
    pr[@"$sid"] = self.sessionId;
    pr[@"$vn"] = self.config.appVersion;
    return pr;
}



- (void)identify:(NSString *)userId properties:(NSDictionary *)properties {
    @try {
        if (userId == nil || userId.length == 0) {
            ZhugeDebug(@"??????ID????????????");
            return;
        }
        if (!self.sessionId) {
            [self sessionStart];
        }
        self.userId = userId;
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"dt"] = @"usr";
        NSMutableDictionary *pr = [self buildCommonData];
        if (properties) {
            NSDictionary *dic = [self addSymbloToDic:properties];
            [pr addEntriesFromDictionary:dic];
        }
        pr[@"$an"] = self.config.appName;
        pr[@"$cuid"] = userId;
        pr[@"$vn"] = self.config.appVersion;
        pr[@"$cn"]  = self.config.channel;
        e[@"pr"] = pr;
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"identify exception %@",exception);
    }
}

-(void)updateIdentify: (NSDictionary *)properties {
    if (!self.userId.length) {
        ZhugeDebug(@"?????????identify,??????????????????????????????");
        return;
    }
    [self identify:self.userId properties:properties];
}

- (void)trackDeviceInfo {
    @try {
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"dt"] = @"pl";
        NSMutableDictionary *pr = [self buildCommonData];
        // ??????
        pr[@"$dv"] = [self getSysInfoByName:"hw.machine"];
        // ????????????
        pr[@"$jail"] =[self isJailBroken] ? @1 : @0;
        // ??????
        pr[@"$lang"] = [[NSLocale preferredLanguages] objectAtIndex:0];
        // ?????????
        pr[@"$mkr"] = @"Apple";
        // ??????
        pr[@"$os"] = @"iOS";
        pr[@"$zs"] = self.localZhugeSeeState?@"1":@"";
        // ????????????
        pr[@"$private"] =[self isPirated] ? @1 : @0;
        //?????????
        pr[@"$rs"] = [self resolution];
        if (self.envInfo) {
            NSDictionary *info = [self.envInfo objectForKey:@"device"];
            if (info) {
                NSMutableDictionary *dic = [self addSymbloToDic:info];
                [pr addEntriesFromDictionary:dic];
            }
        }
        e[@"pr"] = pr;
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"trackDeviceInfo exception, %@",exception);
    }
}


#pragma mark --- ????????????????????????
- (void)zgSeeStart {
    //????????????????? --?? ??????????????????????????????????????????????????????log
    NSMutableArray * dataArray = [NSMutableArray array];
    NSMutableDictionary * prDic = [NSMutableDictionary dictionary];
    if (self.userId.length > 0) {
        prDic[@"$cuid"] = self.userId;
    }
    self.screenShotTime = nil;
    prDic[@"$ct"] = [NSNumber numberWithUnsignedInteger:[[NSDate date] timeIntervalSince1970] *1000];
    prDic[@"$sid"] = [NSString stringWithFormat:@"%@",self.sessionId];
    prDic[@"$net"] = self.net;
    prDic[@"$os"] = @"iOS";
    prDic[@"$ov"] = [[UIDevice currentDevice] systemVersion];;
    prDic[@"$dv"] = [self getSysInfoByName:"hw.machine"];
    prDic[@"$br"] = @"Apple";
    prDic[@"$av"] = self.config.appVersion;
    prDic[@"Ssc"] = @0;
    OSAtomicIncrement32(&self->_seeCount);
    prDic[@"$cr"] = self.cr;
    
    NSMutableDictionary * sqlDic = [NSMutableDictionary dictionary];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
    dataDic[@"pr"] = prDic;
    dataDic[@"dt"] = @"ss";
//    dataDic[@"key"] = @"";
    
    //???????????????
    sqlDic[@"sid"] = self.sessionId;
    sqlDic[@"data"] = [self dictionaryToJson:dataDic];
    
    
    //?????????????????? ???????????????Array
    [dataArray addObject:dataDic];
    NSMutableDictionary *aryDic = [self wrapEvents:dataArray];
    //?????????????????????????????????
    NSString * str = [[[[self encodeAPIData:aryDic] dataUsingEncoding:NSUTF8StringEncoding] zgZlibDeflate] zgBase64EncodedString];
    NSString *dicStr = [NSString stringWithFormat: @"event=%@",str];
    
    // ??????sid????????????
    if (self.sessionId != nil) {
        //????????????????????????
        if (self.zhugeSeeReal == 0 && ([self.zhugeSeeNet isEqualToString:self.net] || [self.zhugeSeeNet isEqualToString:@"1"])) {
            // ??????????????????????????????
            [ZGHttpHelper post:[self getZGSeeUploadURL] RequestStr:dicStr FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                 if (httpResponse.statusCode == 200) {
                     ZhugeDebug(@"zgSeeEnd --- ??????????????????");
                 } else {
                     ZhugeDebug(@"zgSeeEnd --- ??????????????????  %@",connectionError);
                 }
             }];
        } else {
//            NSInteger dicNumber = 999;
//            BOOL addBool = [[ZGSqliteManager shareManager] addZGSeeCoreDataDic:sqlDic dicNumber:dicNumber];
//            if (addBool == YES) {
//                ZhugeDebug(@"zgSeeEnd --- ????????????????????????");
//            } else {
//                ZhugeDebug(@"zgSeeEnd --- ????????????????????????");
//            }
        }
    }
}
#pragma mark --- ??????zhugesee??????
- (void)zgSeeBool {
    //????????????ZGSee
    NSString *url = [self getZGSeePolicyURL];
    __block NSDictionary * dic = nil;
    __block NSNumber *policy = nil;
    __block NSNumber * real = nil;
    __weak typeof(self) weakSelf = self;
    [ZGHttpHelper sendRequestForUrl:url FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"url == %@",url);
        NSLog(@"httpResponse.statusCode == %ld",(long)httpResponse.statusCode);
        if (httpResponse.statusCode == 200 && data){
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dic == nil) {
                NSLog(@"check appsee error. Data will be lose.");
                return;
            }
            policy = [dic objectForKey:@"policy"];
            if (policy == nil) {
                strongSelf.config.serverPolicy = -1;
            }else{
                strongSelf.config.serverPolicy = [policy integerValue];
            }
            real = [dic objectForKey:@"real"];
            strongSelf.zhugeSeeReal = [real integerValue];
            strongSelf.zhugeSeeNet = [NSString stringWithFormat:@"%@", [dic objectForKey:@"net"]];
            strongSelf.ZGPublicKey = [dic objectForKey:@"rsa-public"];
            strongSelf.ZGPublicMD5 = [dic objectForKey:@"rsa-md5"];
        } else {
            ZhugeDebug(@"zgSee --- ???????????? %@",connectionError);
        }
    }];
}
- (void)zgSeeUpLoadNumData:(NSInteger)numData cacheBool:(BOOL)cacheBool {
    //?????????????????? ???????????????????????????
    NSMutableArray * ary = [[ZGSqliteManager shareManager] uploaddataStoredNumData:numData];
    
    //??????CoreData???????????? ???????????????????????????
    if (ary.count < 1) {
        return;
    }
    
    NSMutableArray * dataArray = [NSMutableArray array];
    NSString * sid = @"";
    for (NSMutableDictionary * dic in ary) {
        NSMutableDictionary * data = [NSMutableDictionary dictionary];
        data = [self dictionaryWithJsonString:dic[@"data"]];
        sid = dic[@"sid"];
        [dataArray addObject:data];
    }
    
    if (![[NSString stringWithFormat:@"%@",sid] isEqualToString:[NSString stringWithFormat:@"%@",self.sessionId]]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic = [self wrapEvents:dataArray];
        //?????????????????????????????????
        NSString * dicStr = [[[[self encodeAPIData:dic] dataUsingEncoding:NSUTF8StringEncoding] zgZlibDeflate] zgBase64EncodedString];
        if ([self.zhugeSeeNet isEqualToString:self.net] || [self.zhugeSeeNet isEqualToString:@"1"]) {
            [ZGHttpHelper post:[self getZGSeeUploadURL] RequestStr:dicStr FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                 if (httpResponse.statusCode == 200) {
                     ZhugeDebug(@"zgSee --- ??????????????????");
                     [[ZGSqliteManager shareManager] deletezgSeeCoreDataSid:sid];
//                     [self zgSeeUpLoadNumData:numData cacheBool:cacheBool];
                     
                 } else {
                     ZhugeDebug(@"zgSee --- ??????????????????  %@",connectionError);
                 }
             }];
        }
    }
}
//??????see ????????????

- (void)setZhuGeSeeEvent:(NSMutableDictionary *)seeData {
    if (!self.sessionId) {
        return;
    }
    if (!self.localZhugeSeeState) {
        self.localZhugeSeeState = YES;
        [self trackDeviceInfo];
        dispatch_async(_serialQueue, ^{
            [self archiveSeeState];
        });
    }
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //????????????????????????????????????
            NSMutableArray * dataArray = [NSMutableArray array];
            //??????????????????
            NSMutableDictionary * prDic = seeData;
            
            prDic[@"$ival"] = @([self getCurrentIval]);
            if (self.userId.length > 0) {
                prDic[@"$cuid"] = self.userId;
            }
            prDic[@"$ct"] = [NSNumber numberWithUnsignedInteger:[[NSDate date] timeIntervalSince1970] *1000];
            prDic[@"$sid"] = self.sessionId;
            prDic[@"$net"] = self.net;
            prDic[@"$os"] = @"iOS";
            prDic[@"$sc"] =[NSNumber numberWithInt:self.seeCount];
            OSAtomicIncrement32(&self->_seeCount);
            prDic[@"$ov"] = [[UIDevice currentDevice] systemVersion];;
            prDic[@"$av"] = self.config.appVersion;
            prDic[@"$cr"]  = self.cr;
            prDic[@"$dv"] = [self getSysInfoByName:"hw.machine"];
            prDic[@"$br"] = @"Apple";
            prDic[@"$dru"] = @([[ZGSharedDur shareInstance] durInterval]);
            NSString *pixD =[seeData[@"$pix"] zgBase64EncodedString];
            prDic[@"$pix"] = pixD;

            
            NSData *prData =  [NSJSONSerialization dataWithJSONObject:prDic options:0 error:nil];

            NSString * aesKeyData = [self random128BitAESKey];
            //????????????
            NSString * aesKey = [ZGUtil encryptString:aesKeyData publicKey:self.ZGPublicKey];
            //????????????????????????
            NSString *event = [ZGUtil AES128Encrypt:[prData zgZlibDeflate] sesKey:aesKeyData];
            
            //????????????
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
            dataDic[@"key"] = aesKey;
            dataDic[@"dt"] = @"zgsee";
            dataDic[@"rsa-md5"] = self.ZGPublicMD5;
            dataDic[@"pr"] = event;
            
            //???????????????
            NSMutableDictionary * sqlDic = [NSMutableDictionary dictionary];
            sqlDic[@"sid"] = self.sessionId;
            sqlDic[@"data"] = [self dictionaryToJson:dataDic];
            
            
            [dataArray addObject:dataDic];
            NSMutableDictionary *wrappedDic =  [self wrapEvents:dataArray];
            NSData *wrappedData =  [NSJSONSerialization dataWithJSONObject:wrappedDic options:0 error:nil];
            NSString * str = [[wrappedData zgZlibDeflate]zgBase64EncodedString];

            //?????????????????????????????????
            NSString *dicStr = [NSString stringWithFormat: @"event=%@",str];
        
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                // ??????sid????????????
                if (self.sessionId != nil) {
                    //????????????????????????
                    if (self.zhugeSeeReal == 0 && ([self.zhugeSeeNet isEqualToString:self.net] || [self.zhugeSeeNet isEqualToString:@"1"])) {
                        // ??????????????????????????????
                        NSLog(@" == %@",[self getZGSeeUploadURL]);
                        [ZGHttpHelper post:[self getZGSeeUploadURL] RequestStr:dicStr FinishBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                             if (httpResponse.statusCode == 200) {
                                 ZhugeDebug(@"zgSee --- ??????????????????");
                             } else {
                                 ZhugeDebug(@"zgSee --- ??????????????????  %@",connectionError);
                             }
                         }];
                    } else {
//                        NSInteger dicNumber = 999;
//
//                        BOOL addBool = [[ZGSqliteManager shareManager] addZGSeeCoreDataDic:sqlDic dicNumber:dicNumber];
//                        if (addBool == YES) {
//                            ZhugeDebug(@"zgSee --- ????????????????????????");
//                        } else {
//                            ZhugeDebug(@"zgSee --- ????????????????????????");
//                        }
                    }
                }
            });
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"trackDeviceInfo exception, %@",exception);
    }
    
}
//??????128?????????
- (NSString *)random128BitAESKey {
    uint8_t randomBytes [16];
    int result = SecRandomCopyBytes(kSecRandomDefault,8,randomBytes);
    if(result == errSecSuccess){
        NSMutableString * uuidStringReplacement = [[NSMutableString alloc] initWithCapacity:8 * 2];
        for(NSInteger index = 0; index< 8; index ++) {
            [uuidStringReplacement appendFormat:@"%02x",randomBytes [index]];
        }
//        ZhugeDebug(@"uuidStringReplacement === %@",uuidStringReplacement);
        return uuidStringReplacement;
    } else {
        ZhugeDebug(@"SecRandomCopyBytes????????????????????????");
        return @"";
    }
    return @"";
}

#pragma mark - ??????ival
- (CGFloat)getCurrentIval{
    if (!self.screenShotTime) {
        self.screenShotTime = [NSDate date];
        return 0;
    }
//    long long time=[self.screenShotTime longLongValue];
//    NSDate *didDate = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    CGFloat ival = [[NSDate date] timeIntervalSinceDate:self.screenShotTime];
    return ival;
}
#pragma mark - ???json
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    if (dic == nil) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - ????????????
// ??????????????????
- (void)trackPush:(NSDictionary *)userInfo type:(NSString *) type {
    @try {
        
        ZhugeDebug(@"push payload: %@", userInfo);
        if (userInfo && userInfo[@"mid"]) {
            NSMutableDictionary *e = [NSMutableDictionary dictionary];
            e[@"$mid"] = userInfo[@"mid"];
            e[@"$ct"] = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970] *1000];
            e[@"$tz"] = [NSNumber numberWithInteger:[[NSTimeZone localTimeZone] secondsFromGMT]*1000];//??????????????????
            e[@"$channel"] = @"";
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"dt"] = type;
            dic[@"pr"]  = e;
            [self enqueueEvent:dic];
            [self flush]; 
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"trackPush exception %@",exception);
    }
}

// ???????????????????????????ID
- (void)setThirdPartyPushUserId:(NSString *)userId forChannel:(ZGPushChannel) channel {
    @try {
        if (userId == nil || [userId length] == 0) {
            ZhugeDebug(@"userId????????????");
            return;
        }
        
        NSMutableDictionary *pr = [NSMutableDictionary dictionary];
        pr[@"$push_ch"] = [self nameForChannel:channel];
        pr[@"$push_id"] = userId;
        //??????????????????
        pr[@"$tz"]    = [NSNumber numberWithInteger:[[NSTimeZone localTimeZone] secondsFromGMT]*1000];
        pr[@"$ct"]  =  [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] *1000];
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"dt"] = @"um";
        e[@"pr"] = pr;
        
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"track properties exception %@",exception);
    }
}

-(NSString *)nameForChannel:(ZGPushChannel) channel {
    switch (channel) {
        case ZG_PUSH_CHANNEL_XIAOMI:
            return @"xiaomi";
        case ZG_PUSH_CHANNEL_JPUSH:
            return @"jpush";
        case ZG_PUSH_CHANNEL_UMENG:
            return @"umeng";
        case ZG_PUSH_CHANNEL_BAIDU:
            return @"baidu";
        case ZG_PUSH_CHANNEL_XINGE:
            return @"xinge";
        case ZG_PUSH_CHANNEL_GETUI:
            return @"getui";
        default:
            return @"";
    }
}

/**
 ????????????????????????
 */
-(NSMutableDictionary *)wrapEvents:(NSArray *)events{
    NSMutableDictionary *batch = [NSMutableDictionary dictionary];
    batch[@"ak"]    = self.appKey;
    batch[@"debug"] = self.config.debug?@1:@0;
    batch[@"sln"]   = @"itn";
    batch[@"owner"] = @"zg";
    batch[@"pl"]    = @"ios";
    batch[@"sdk"]   = @"zg-ios";
    batch[@"sdkv"]  = self.config.sdkVersion;
    NSDictionary *dic = @{@"did":[self getDid]};
    batch[@"usr"]   = dic;
    batch[@"ut"]    = [self currentDate];
    //??????????????????
    batch[@"tz"]    = [NSNumber numberWithInteger:[[NSTimeZone localTimeZone] secondsFromGMT]*1000];
    batch[@"data"]  = events;
    return batch;
}
#pragma mark - ??????&??????

-(NSMutableDictionary *)addSymbloToDic:(NSDictionary *)dic{
    NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithCapacity:[dic count]];
    for (NSString *key in dic) {
        id value = dic[key];
        NSString *newKey = [NSString stringWithFormat:@"_%@",key];
        [copy setValue:value forKey:newKey];
    }
    return copy;
}


// JSON?????????
- (NSData *)JSONSerializeObject:(id)obj {
    id coercedObj = [self JSONSerializableObjectForObject:obj];
    NSError *error = nil;
    NSData *data = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:coercedObj options:0 error:&error];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"%@ exception encoding api data: %@", self, exception);
    }
    if (error) {
        ZhugeDebug(@"%@ error encoding api data: %@", self, error);
        
    }
    return data;
}

// JSON?????????
- (id)JSONSerializableObjectForObject:(id)obj {
    // valid json types
    if ([obj isKindOfClass:[NSString class]] ||
        [obj isKindOfClass:[NSNumber class]] ||
        [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    // recurse on containers
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *a = [NSMutableArray array];
        for (id i in obj) {
            [a addObject:[self JSONSerializableObjectForObject:i]];
        }
        return [NSArray arrayWithArray:a];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        for (id key in obj) {
            NSString *stringKey;
            if (![key isKindOfClass:[NSString class]]) {
                stringKey = [key description];
            } else {
                stringKey = [NSString stringWithString:key];
            }
            id v = [self JSONSerializableObjectForObject:obj[key]];
            d[stringKey] = v;
        }
        return [NSDictionary dictionaryWithDictionary:d];
    }
    
    // default to sending the object's description
    NSString *s = [obj description];
    return s;
}

// API????????????
- (NSString *)encodeAPIData:(NSMutableDictionary *) batch {
    NSData *data = [self JSONSerializeObject:batch];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//json???????????????????????????
- (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                
                                                               options:NSJSONReadingMutableContainers
                                
                                                                 error:&err];
    
    if(err) {
        
        ZhugeDebug(@"json???????????????%@",err);
        
        return nil;
        
    }
    
    return dic;
}

#pragma mark - ????????????

// ???????????????????????????
- (void)startFlushTimer {
    [self stopFlushTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.config.sendInterval > 0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.config.sendInterval
                                                          target:self
                                                        selector:@selector(flush)
                                                        userInfo:nil
                                                         repeats:YES];
            
            ZhugeDebug(@"???????????????????????????");
        }
    });
}

// ???????????????????????????
- (void)stopFlushTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            [self.timer invalidate];
            ZhugeDebug(@"???????????????????????????");
        }
        self.timer = nil;
    });
}

#pragma mark - ????????????

// ????????????????????????

- (void)enqueueEvent:(NSMutableDictionary *)event {
    dispatch_async(self.serialQueue, ^{
        [self syncEnqueueEvent:event];
    });
}

- (void)syncEnqueueEvent:(NSMutableDictionary *)event {
    ZhugeDebug(@"????????????: %@", event);
    
    if (self.flushBool == YES) {
        [self.eventsQueue addObject:event];
        [self flush];
        if ([self.eventsQueue count] > self.config.cacheMaxSize) {
            [self.eventsQueue removeObjectAtIndex:0];
        }
    } else {
        [self.eventsQueue addObject:event];
        if ([self.eventsQueue count] > self.config.cacheMaxSize) {
            [self.eventsQueue removeObjectAtIndex:0];
        }
    }
    
}

- (void)flush {
    dispatch_async(self.serialQueue, ^{
        [self flushQueue: self->_eventsQueue];
    });
}

- (void)flushQueue:(NSMutableArray *)queue {
    @try {
        while ([queue count] > 0) {
            if (self.sendCount >= self.config.sendMaxSizePerDay) {
                
                ZhugeDebug(@"?????????????????????????????????(??????????????????:%lu, ??????:%lu, ???????????????: %lu)", (unsigned long)self.sendCount, (unsigned long)self.config.sendMaxSizePerDay, (unsigned long)[queue count]);
                return;
            }
            
            NSUInteger sendBatchSize = ([queue count] > 50) ? 50 : [queue count];
            if (self.sendCount + sendBatchSize >= self.config.sendMaxSizePerDay) {
                sendBatchSize = self.config.sendMaxSizePerDay - self.sendCount;
            }
            
            NSArray *events = [queue subarrayWithRange:NSMakeRange(0, sendBatchSize)];
            
            ZhugeDebug(@"??????????????????(?????????????????????:%lu, ?????????????????????:%lu, ??????????????????:%lu, ??????:%lu)", (unsigned long)[events count], (unsigned long)[queue count], (unsigned long)self.sendCount, (unsigned long)self.config.sendMaxSizePerDay);
            
            NSString *eventData = [self encodeAPIData:[self wrapEvents:events]];
            
            ZhugeDebug(@"???????????????%@",eventData);
            NSData *eventDataBefore = [eventData dataUsingEncoding:NSUTF8StringEncoding];
            NSData *zlibedData = [eventDataBefore zgZlibDeflate];
            
            NSString *event = [zlibedData zgBase64EncodedString];
            NSString *result = [[event stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *requestData = [NSString stringWithFormat:@"method=event_statis_srv.upload&compress=1&event=%@", result];
            
            NSData *response = [self apiRequest:@"/APIPOOL/" WithData:requestData andError:nil];
            if (!response) {
                ZhugeDebug(@"??????????????????");
                break;
            }
            ZhugeDebug(@"??????????????????");
            self.sendCount += sendBatchSize;
            [queue removeObjectsInArray:events];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"flushQueue exception %@",exception);
    }
}

- (NSData*) apiRequest:(NSString *)endpoint WithData:(NSString *)requestData andError:(NSError *)error {
    BOOL success = NO;
    int  retry = 0;
    NSData *responseData = nil;
    while (!success && retry < 3) {
        NSURL *URL = nil;
        if (retry > 0 && self.backupURL) {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/",self.backupURL]];
        }else{
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.apiURL,endpoint]];
        }

        ZhugeDebug(@"api request url = %@ , retry = %d",URL,retry);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"POST"];
        NSString * urlString = [requestData stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
        [request setHTTPBody:[urlString dataUsingEncoding:NSUTF8StringEncoding]];
        request.timeoutInterval =30;
//        [self updateNetworkActivityIndicator:YES];
        
        NSURLResponse *urlResponse = nil;
        NSError *reqError = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&reqError];
        if (reqError) {
            ZhugeDebug(@"error : %@",reqError);
            retry++;
            continue;
        }
//        [self updateNetworkActivityIndicator:NO];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) urlResponse;
        NSInteger code = [httpResponse statusCode];
        if (code == 200 && responseData != nil) {
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            ZhugeDebug(@"API??????: %@",response);
//            [self updateNetworkActivityIndicator:NO];
            success = YES;
        }else{
            retry++;
        }
    }
    
    if (!success) {
        return nil;
    }
    return responseData;
}

#pragma  mark - ?????????
// ???????????????
- (NSString *)filePathForData:(NSString *)data {
    NSString *filename = [NSString stringWithFormat:@"zhuge-%@-%@.plist", self.appKey, data];
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:filename];
}
//????????????
-(NSString *)environmentInfoFilePath{
    return [self filePathForData:@"environment"];
}
// ????????????
- (NSString *)eventsFilePath {
    return [self filePathForData:@"events"];
}

// ????????????
- (NSString *)propertiesFilePath {
    return [self filePathForData:@"properties"];
}
// ????????????
- (NSString *)seeStateFilePath {
    return [self filePathForData:@"see-state"];
}
- (void)archive {
    @try {
        [self archiveEvents];
        [self archiveProperties];
        [self archiveEnvironmentInfo];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"archive exception %@",exception);
    }
}
- (void)archiveEvents {
    NSString *filePath = [self eventsFilePath];
    NSMutableArray *eventsQueueCopy = [NSMutableArray arrayWithArray:[self.eventsQueue copy]];
    ZhugeDebug(@"??????????????? %@",filePath);
    if (![NSKeyedArchiver archiveRootObject:eventsQueueCopy toFile:filePath]) {
        ZhugeDebug(@"??????????????????");
    }
}

- (void)archiveProperties {
    NSString *filePath = [self propertiesFilePath];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setValue:self.userId forKey:@"userId"];
    [p setValue:self.deviceId forKey:@"deviceId"];
    [p setValue:self.sessionId forKey:@"sessionId"];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *today = [DateFormatter stringFromDate:[NSDate date]];
    [p setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.sendCount] forKey:[NSString stringWithFormat:@"sendCount-%@", today]];
    
    ZhugeDebug(@"??????????????? %@: %@",  filePath, p);
    if (![NSKeyedArchiver archiveRootObject:p toFile:filePath]) {
        ZhugeDebug(@"??????????????????");
    }
}
- (void)archiveSeeState{
    @try{
        NSString *filePath = [self seeStateFilePath];
        if (![NSKeyedArchiver archiveRootObject:@"YES" toFile:filePath]) {
            ZhugeDebug(@"zhuge see state????????????");
        }
    }@catch (NSException *e){
        ZhugeDebug(@"??????see state??????.%@",e);
    }
}
- (void)archiveEnvironmentInfo{
    if (!self.envInfo) {
        return;
    }
    NSString *filePath = [self environmentInfoFilePath];
    NSMutableDictionary *dic = [self.envInfo copy];
    if (![NSKeyedArchiver archiveRootObject:dic toFile:filePath]) {
        ZhugeDebug(@"?????????????????????????????????");
    }
}

- (void)unarchive {
    @try {
        [self unarchiveEvents];
        [self unarchiveProperties];
        [self unarchiveSeeState];
        [self unarchiveEnvironmentInfo];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"unarchive exception %@",exception);
    }
}

- (id)unarchiveFromFile:(NSString *)filePath deleteFile:(BOOL) delete{
    id unarchivedData = nil;
    @try {
        unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"??????????????????");
        unarchivedData = nil;
    }
    if (delete && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!removed) {
            ZhugeDebug(@"?????????????????? %@", error);
        }else{
            ZhugeDebug(@"?????????????????? %@",filePath);
        }
    }
    return unarchivedData;
}

- (void)unarchiveEnvironmentInfo{
    self.envInfo = (NSMutableDictionary *)[[self unarchiveFromFile:[self environmentInfoFilePath] deleteFile:NO] mutableCopy];
    if (self.envInfo) {
        if([self.envInfo objectForKey:@"event"]){
            ZhugeDebug(@"??????????????????????????????%@",self.envInfo[@"event"]);
        }
        if ([self.envInfo objectForKey:@"device"]) {
            ZhugeDebug(@"????????????????????????%@",self.envInfo[@"device"]);        }
    }
}
- (void)unarchiveEvents {
    self.eventsQueue = (NSMutableArray *)[[self unarchiveFromFile:[self eventsFilePath] deleteFile:YES] mutableCopy];
    if (!self.eventsQueue) {
        self.eventsQueue = [NSMutableArray array];
    }
}

- (void)unarchiveProperties {
    NSDictionary *properties = (NSDictionary *)[self unarchiveFromFile:[self propertiesFilePath] deleteFile:NO];
    if (properties) {
        self.userId = properties[@"userId"] ? properties[@"userId"] : @"";
        if (!self.deviceId) {
            self.deviceId = properties[@"deviceId"] ? properties[@"deviceId"] : [self defaultDeviceId];
        }
        self.sessionId = properties[@"sessionId"] ? properties[@"sessionId"] : nil;
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *today = [DateFormatter stringFromDate:[NSDate date]];
        NSString *sendCountKey = [NSString stringWithFormat:@"sendCount-%@", today];
        self.sendCount = properties[sendCountKey] ? [properties[sendCountKey] intValue] : 0;
    }
}
- (void)unarchiveSeeState{
    NSString *seeState = (NSString *)[self unarchiveFromFile:[self seeStateFilePath] deleteFile:NO];
    if (seeState) {
        self.localZhugeSeeState = YES;
    }
}
@end
