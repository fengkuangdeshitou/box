//
//  MyAppUpdateView.m
//  Game789
//
//  Created by Maiyou on 2019/11/2.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyAppUpdateView.h"

@implementation MyAppUpdateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAppUpdateView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.closeView.hidden = YES;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 3;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#8C8C8C"], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.updateContent.attributedText = [[NSAttributedString alloc] initWithString:self.dataDic[@"update_content"] attributes:attributes];
}

- (IBAction)updateAppClick:(id)sender
{
    [self updateApp];
}

- (IBAction)closeButtonClick:(id)sender
{
    [self removeFromSuperview];
}

- (void)updateApp
{
    if ([DeviceInfo shareInstance].isGameVip)
    {
        [self removeFromSuperview];
        NSDictionary * vipDic = @{@"maiyou_gameid" : @"152",
                                  @"down_type" : @"3",
                                  @"vip_ios_url" : @""};
        [[YYToolModel shareInstance] loadingView:vipDic];
    }
    else
    {
        NSURL* nsUrl = [NSURL URLWithString:self.dataDic[@"down_url"]];
        [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
        
        //退出APP强制安装
        exit(0);
    }
}

//http://api3.app.99maiyou.com/iosDownload?id=152&agent=wf8z
- (void)requestByURLConnection:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
    quest.HTTPMethod = @"GET";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
      {
          NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
          
        NSLog(@"statusCode: %ld", (long)urlResponse.statusCode);
          NSLog(@"%@", urlResponse.allHeaderFields);
      }];
    [task resume];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    NSLog(@"statusCode: %ld", (long)response.statusCode);
    
    NSDictionary *headers = response.allHeaderFields;
    NSLog(@"%@", headers);
    NSLog(@"redirect   url: %@", headers[@"Location"]); // 重定向的地址，如：http://www.jd.com
    NSLog(@"newRequest url: %@", [request URL]);        // 重定向的地址，如：http://www.jd.com
    NSLog(@"redirect response url: %@", [response URL]);// 触发重定向请求的地址，如：http://www.360buy.com
    
    completionHandler(request);
    //    completionHandler(nil);// 参数为nil，表示拦截（禁止）重定向
}

@end
