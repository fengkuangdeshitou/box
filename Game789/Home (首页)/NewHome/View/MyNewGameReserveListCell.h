//
//  MyNewGameReserveListCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNewGameReserveListCell : WSLRollViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *reserveTime;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;


/**  是否可以预约  */
@property (nonatomic, assign) BOOL isReservedSucess;
/** 首页视频video 首页预约reserved 游戏大厅精选的banner */
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) void(^playBtnAction)(void);
@property (nonatomic, copy) void(^receiveBtnAction)(BOOL receive);

@end

NS_ASSUME_NONNULL_END
