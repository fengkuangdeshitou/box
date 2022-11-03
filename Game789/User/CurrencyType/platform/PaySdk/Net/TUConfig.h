//
//  TUConfig.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/28.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#ifndef TUConfig_h
#define TUConfig_h

//支付宝code定义
#define ALIPAYCANCEL @"1"
#define ALIPAYFAILDE @"2"
#define SERVERONABLE @"3"



//渠道文件名称
#define TUUChannel  @"TUUChannel"

//bundle文件名
#define TUUSDK @"MYSDK"


#define TUUDEBUG 0  //0为debug状态,1为release状态

#if TUUDEBUG == 0
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#elif TUUDEBUG == 1
#define NSLog(...) {}
#endif




#endif /* TUConfig_h */
