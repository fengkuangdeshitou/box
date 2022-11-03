//
//  MyShowGameImageListCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayVideoAction)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MyShowGameImageListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gameScreenIamge;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, copy) PlayVideoAction playVideoAction;

@end

NS_ASSUME_NONNULL_END
