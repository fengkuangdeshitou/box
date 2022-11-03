//
//  MyHotGameClassifyCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHotGameClassifyCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
