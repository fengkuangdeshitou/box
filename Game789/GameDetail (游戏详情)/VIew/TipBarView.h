//
//  TipBarView.h
//  Game789
//
//  Created by Maiyou on 2018/11/7.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TipBarView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *showText;
@property (weak, nonatomic) IBOutlet UIButton *colseButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtn_centerY;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, assign) BOOL isFirst;

@end

