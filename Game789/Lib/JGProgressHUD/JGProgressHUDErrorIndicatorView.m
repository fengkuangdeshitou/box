//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"
#import "NSString+URLEncode.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {

    self = [super initWithImage:[UIImage imageNamed:[@"jg_hud_error" getImagePath]]];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

- (void)updateAccessibility {
    self.accessibilityLabel = NSLocalizedString(@"Error",);
}

@end
