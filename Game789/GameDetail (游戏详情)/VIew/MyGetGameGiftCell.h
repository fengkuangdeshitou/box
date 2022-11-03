//
//  MyGetGameGiftCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/23.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^GetGiftPackageAction)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MyGetGameGiftCell : BaseTableViewCell

@property (nonatomic, strong) NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet UILabel *packageName;
@property (weak, nonatomic) IBOutlet UILabel *packageContent;
@property (weak, nonatomic) IBOutlet UIButton *getGiftButton;

@property (nonatomic, copy) GetGiftPackageAction packageAction;

@end

NS_ASSUME_NONNULL_END
