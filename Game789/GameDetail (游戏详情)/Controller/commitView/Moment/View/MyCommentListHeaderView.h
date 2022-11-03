//
//  MyCommentListHeaderView.h
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *questionCount;
@property (weak, nonatomic) IBOutlet UILabel *showDesc;
@property (weak, nonatomic) IBOutlet UILabel *answerCount;
@property (weak, nonatomic) IBOutlet UILabel *consultTitle;
@property (weak, nonatomic) IBOutlet UILabel *consultSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *consultSubtitle1;
@property (weak, nonatomic) IBOutlet UILabel *consultSubtitle2;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (nonatomic, strong) UIButton * selectedBtn;
@property (nonatomic, copy) void(^selectSortAction)(NSString *sort, NSInteger tag);

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
