//
//  UserNickCollectionReusableView.m
//  Game789
//
//  Created by Maiyou on 2018/7/13.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "UserNickCollectionReusableView.h"

@implementation UserNickCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _headPortraitImg  = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 0, 50, 50)];
        [self addSubview:_headPortraitImg];
        
    }
    return self;
}
@end
