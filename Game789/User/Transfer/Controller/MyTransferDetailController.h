//
//  MyTransferDetailController.h
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "MySubmitTransferData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTransferDetailController : BaseViewController

@property (nonatomic, copy) NSString *detail_id;
@property (nonatomic, assign) BOOL isSubmit;
    
@end

NS_ASSUME_NONNULL_END
