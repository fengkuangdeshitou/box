//
//  MyUserReturnTaskCell.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyUserReturnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnTaskCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDesc;
@property (weak, nonatomic) IBOutlet UIButton *showStatus;
@property (nonatomic,strong) MyUserReturnModel *userModel;

@end

NS_ASSUME_NONNULL_END
