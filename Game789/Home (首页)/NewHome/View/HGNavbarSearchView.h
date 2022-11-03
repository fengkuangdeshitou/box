//
//  HGNavbarSearchView.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGNavbarSearchView : UIView

@property (weak, nonatomic) IBOutlet UIButton *showBtn1;
@property (weak, nonatomic) IBOutlet UIButton *showBtn2;

@property (nonatomic, strong) UIViewController * currentVC;
/** 是否为游戏详情 */
@property (nonatomic, assign) BOOL isGameDetail;
/** 是否游戏收藏 */
@property (nonatomic, assign) BOOL isCollected;
/** 是否为游戏视频 */
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, copy) NSString *gameId;

@property (nonatomic, copy) void(^SearchBtnClick)(BOOL value);


@end

NS_ASSUME_NONNULL_END
