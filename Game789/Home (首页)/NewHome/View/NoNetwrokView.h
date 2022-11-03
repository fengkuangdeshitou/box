//
//  NoNetwrokView.h
//  Trading
//
//  Created by maiyou on 2021/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NoNetwrokViewDelegate <NSObject>

- (void)onAgainRequestAction;

@end

@interface NoNetwrokView : UIView

+ (NoNetwrokView *)sharedInstance;

@property(nonatomic,weak)id<NoNetwrokViewDelegate>delegate;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
