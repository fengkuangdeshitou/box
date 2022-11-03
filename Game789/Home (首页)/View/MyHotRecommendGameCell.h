//
//  MyHotRecommendGameCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/10.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHotRecommendGameCell : BaseTableViewCell <YCDownloadItemDelegate, MyResignTimeTaskDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentIcon_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabel_left;

@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (strong, nonatomic) NSString *downLoadURL;
@property (strong, nonatomic) NSString *routeURL;

@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UILabel *hotLabels;
@property (weak, nonatomic) IBOutlet UIButton *buttonGradient;
@property (weak, nonatomic) IBOutlet UILabel *disHot;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

//热门推荐
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotRecommend;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (nonatomic, assign) BOOL isHotGame;

@property (nonatomic, strong) YCDownloadItem * downloadItem;
/**  是否分包  */
@property (nonatomic, assign) BOOL isPackage;
@property (nonatomic, strong) MyColorCircle *circleView;

@end

NS_ASSUME_NONNULL_END
