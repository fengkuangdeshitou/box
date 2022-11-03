//
//  UserPersonalCenterView.h
//  Game789
//
//  Created by Maiyou on 2018/10/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserPersonalCenterView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *user_icon;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *comment_count;
@property (weak, nonatomic) IBOutlet UILabel *like_count;
@property (weak, nonatomic) IBOutlet UIImageView *memberLevelImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIcon_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_width;
@property (weak, nonatomic) IBOutlet UIImageView *memberMark;

@property (nonatomic, strong) NSDictionary * dataDic;

@property(nonatomic,copy)void(^exchangeButtonBlock)(NSInteger index);

- (void)didselectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
