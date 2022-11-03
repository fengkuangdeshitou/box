//
//  MySelectGameListCell.h
//  Mycps
//
//  Created by Maiyou on 2019/11/14.
//  Copyright © 2019 Maiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MySelectGameListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *game_type;
@property (weak, nonatomic) IBOutlet UILabel *game_name;
@property (weak, nonatomic) IBOutlet UILabel *showDiscount;
@property (strong, nonatomic) NSDictionary *dataDic;



@end

NS_ASSUME_NONNULL_END
