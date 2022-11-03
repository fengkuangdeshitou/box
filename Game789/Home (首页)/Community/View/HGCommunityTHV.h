//
//  HGCommunityTHV.h
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGCommunityTHV;

NS_ASSUME_NONNULL_BEGIN

@protocol HGCommunityTHVDelegate <NSObject>

- (void)community:(HGCommunityTHV *)community didSelectedItem:(NSDictionary *)item;

@end

@interface HGCommunityTHV : UIView

@property (nonatomic, assign) CGFloat view_height;
//@property (weak, nonatomic) IBOutlet UILabel *bottomLineLabel;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, weak) id<HGCommunityTHVDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
