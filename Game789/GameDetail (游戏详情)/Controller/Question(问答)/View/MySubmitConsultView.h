//
//  MySubmitConsultView.h
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

typedef void(^SubmitSuccess)(BOOL isQuestion);

NS_ASSUME_NONNULL_BEGIN

@interface MySubmitConsultView : BaseView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *enterContent;
@property (weak, nonatomic) IBOutlet UILabel *playedCount;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel1;
@property (weak, nonatomic) IBOutlet UIView *entryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryView_bottom;
/**  是否为问答详情  */
@property (nonatomic, assign) BOOL  isConsultDetail;
/**  提交问题的游戏id  */
@property (nonatomic, copy) NSString * gameId;
/**  提交回答的该问题id  */
@property (nonatomic, copy) NSString * questionId;
/**  多少位玩过游戏的人  */
@property (nonatomic, copy) NSString * playedGameCount;

@property (nonatomic, copy) SubmitSuccess submitText;

@end

NS_ASSUME_NONNULL_END
