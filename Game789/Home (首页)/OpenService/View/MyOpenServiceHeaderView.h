//
//  MyOpenServiceHeaderView.h
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "MyHotGameClassifyCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOpenServiceHeaderView : BaseView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/**  今日开服的时间  */
@property (nonatomic, strong) NSArray * dataArray;
/**  即将开服的日期  */
@property (nonatomic, strong) NSArray * dateArray;
/** 当前选择的时间 */
@property (nonatomic, assign) NSInteger selectedTimeIndex;
/** 10 今日开服 20 即将开服 30 历史开服 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) void(^collectionSelectedIndex)(NSInteger index, NSString *date);

@end

NS_ASSUME_NONNULL_END
