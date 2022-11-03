//
//  MyTwoActivityItemsCell.h
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTwoActivityItemsCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *showBtn1;
@property (weak, nonatomic) IBOutlet UIButton *showBtn2;

@property (nonatomic, strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
