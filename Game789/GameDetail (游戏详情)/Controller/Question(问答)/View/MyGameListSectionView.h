//
//  MyGameListSectionView.h
//  Mycps
//
//  Created by Maiyou on 2018/11/13.
//  Copyright © 2018 Maiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyGameListSectionViewDelegate <NSObject>

- (void)keywordSearchAction:(NSString *_Nonnull)keyword;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyGameListSectionView : UIView

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) id<MyGameListSectionViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
