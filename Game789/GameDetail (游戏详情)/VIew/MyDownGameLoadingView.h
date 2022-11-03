//
//  MyDownGameLoadingView.h
//  Game789
//
//  Created by Maiyou on 2019/7/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDownGameLoadingView : BaseView
{
    NSTimer * _resginTimer;
}

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) NSInteger resginCount;
@property (nonatomic, assign) NSInteger stepNum;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, copy) NSString *gameid;
/**  下载类型  */
@property (nonatomic, assign) NSInteger downType;

@property (weak, nonatomic) IBOutlet UILabel *showStatus1;
@property (weak, nonatomic) IBOutlet UILabel *showStatus2;
@property (weak, nonatomic) IBOutlet UILabel *showStatus3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
// 个人签名轮询获取下载地址
@property (nonatomic, copy) void(^GetVipGameDownUrl)(NSInteger code, NSString *url);


@end

NS_ASSUME_NONNULL_END
