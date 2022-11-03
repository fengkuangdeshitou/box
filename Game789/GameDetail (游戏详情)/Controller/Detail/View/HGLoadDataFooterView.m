//
//  HGLoadDataFooterView.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGLoadDataFooterView.h"

@implementation HGLoadDataFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGLoadDataFooterView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}
@end
