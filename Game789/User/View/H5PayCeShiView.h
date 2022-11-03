//
//  H5PayCeShiView.h
//  Game789
//
//  Created by Maiyou on 2018/10/10.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface H5PayCeShiView : UIView

@property (weak, nonatomic) IBOutlet UITextView *enterText;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) UIViewController * currentVC;

@end
