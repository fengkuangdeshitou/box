//
//  MyServiceCenterSectionView.m
//  Game789
//
//  Created by Maiyou001 on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyServiceCenterSectionView.h"

@implementation MyServiceCenterSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyServiceCenterSectionView" owner:self options:nil].firstObject;
    }
    return self;
}

@end
