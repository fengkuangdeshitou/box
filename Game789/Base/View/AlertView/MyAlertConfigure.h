//
//  MyAlertConfigure.h
//  Game789
//
//  Created by Maiyou001 on 2022/8/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAlertConfigure : BaseModel

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * content;

@property (nonatomic,strong) NSArray *btnTitles;
@property (nonatomic,strong) NSArray *btnTitleColors;
@property (nonatomic,strong) NSArray *btnBackColors;

//默认 120
@property (nonatomic, assign) CGFloat btnWidth;
//默认 20
@property (nonatomic, assign) CGFloat btnSpace;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, assign) BOOL showIcon;

@property (nonatomic,assign) NSTextAlignment textAlignment;

@property (nonatomic,strong) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
