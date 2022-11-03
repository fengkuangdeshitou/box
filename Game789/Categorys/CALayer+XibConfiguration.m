//
//  CALayer+XibConfiguration.m
//  Mycps
//
//  Created by Maiyou on 2018/9/12.
//  Copyright © 2018年 Maiyou. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

- (void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}


- (void)setShadowUIColor:(UIColor *)color
{
    self.shadowColor = color.CGColor;
}

- (UIColor *)shadowUIColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
