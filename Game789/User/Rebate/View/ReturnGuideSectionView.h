//
//  ReturnGuideSectionView.h
//  Game789
//
//  Created by xinpenghui on 2018/3/19.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnGuideSectionViewDelegate <NSObject>

- (void)ReturnGuideSectionViewPressAction:(NSInteger)index;

@end

@interface ReturnGuideSectionView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *fireImg;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) id<ReturnGuideSectionViewDelegate>delegate;

- (void)resetTitles:(NSString *)title;

@end
