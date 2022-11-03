//
//  JGProgressHUDSuccessIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUD.h"
#import "NSString+URLEncode.h"

@implementation JGProgressHUDSuccessIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {

    
    self = [super initWithImage:[UIImage imageNamed:[@"jg_hud_success" getImagePath]]];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Success",);
}

@end
