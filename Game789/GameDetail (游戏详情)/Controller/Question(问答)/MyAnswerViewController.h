//
//  MyAnswerViewController.h
//  Game789
//
//  Created by Maiyou on 2019/2/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "MyGetQuestionModel.h"

typedef void(^SubmitAnswerSuccess)();

NS_ASSUME_NONNULL_BEGIN

@interface MyAnswerViewController : BaseViewController

@property (nonatomic, copy) NSString * question_id;

@property (nonatomic, strong) MyGetQuestionModel * quesModel;

@property (nonatomic, copy) SubmitAnswerSuccess answerSuccess;
/**  从个人中心点击或者当前发表的问题为自己  */
@property (nonatomic, assign) BOOL isPersonal;

@end

NS_ASSUME_NONNULL_END
