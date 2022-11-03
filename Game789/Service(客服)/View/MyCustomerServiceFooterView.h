//
//  MyCustomerServiceFooterView.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCustomerServiceFooterView : BaseView

@property (nonatomic, copy) NSString *telNumber;
@property (weak, nonatomic) IBOutlet UILabel *showTelNumber;

@end

NS_ASSUME_NONNULL_END
