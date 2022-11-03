//
//  SellAmountViewCell.h
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellAmountViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet UILabel *showValue;
@property (weak, nonatomic) IBOutlet UITextField *enterText;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle1;
@property (weak, nonatomic) IBOutlet UILabel *showDetail1;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
