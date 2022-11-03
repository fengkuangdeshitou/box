//
//  MemberInterestsModel.h
//  Game789
//
//  Created by maiyou on 2021/9/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberInterestsModel : NSObject

@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * desc;
@property(nonatomic,copy) NSString * object;
@property(nonatomic,assign) BOOL auth;
@property(nonatomic,strong) NSArray * levelArray;
@property(nonatomic,strong) NSDictionary * data;


@end

NS_ASSUME_NONNULL_END
