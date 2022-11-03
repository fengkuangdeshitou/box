//
//  DownLoadManageCell.h
//  Game789
//
//  Created by Maiyou on 2018/11/27.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "YCDownloadItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadManageCell : BaseTableViewCell <YCDownloadItemDelegate, MyResignTimeTaskDelegate>

@property (nonatomic, copy) void (^downLoadStatusChanged)(YCDownloadStatus downloadStatus);
@property (nonatomic, copy) void (^deleteLoadData)(NSInteger index);

@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDownSpeed;
@property (weak, nonatomic) IBOutlet UILabel *showDownSize;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showDownSpeed_top;

@property (strong, nonatomic) NSString *downLoadURL;
@property (strong, nonatomic) NSString *routeURL;

@property (strong, nonatomic) NSDictionary *data;
@property (nonatomic, strong) YCDownloadItem *item;
@property (nonatomic, strong) MyColorCircle *circleView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
